# Completion for `step <plugin> ...`, where the plugin is an executable `step-<name>-plugin` in $PATH.
# Startup cost is one compdef call. The PATH scan and each plugin's `completion zsh` run lazily,
# on the first `step` completion of the session.
(( $+functions[compdef] )) || return 0

typeset -gA _step_plugin_exe=()   # name -> executable path
typeset -gA _step_plugin_ok=()    # name -> 1 (completion loaded) | 0 (unsupported)
typeset -gi _step_plugin_scanned=0

_step_plugin_scan() {
  (( _step_plugin_scanned )) && return
  _step_plugin_scanned=1
  local dir f name
  for dir in $path; do
    for f in "$dir"/step-*-plugin(N-.x); do
      name=${f:t}
      name=${name#step-}
      name=${name%-plugin}
      [[ -n $name && -z ${_step_plugin_exe[$name]} ]] && _step_plugin_exe[$name]=$f
    done
  done
}

# Defines the plugin's completion function once per session. Returns 0 if it is available.
_step_plugin_load() {
  local name=$1 exe=${_step_plugin_exe[$1]} script
  [[ -n $exe ]] || return 1
  if [[ -z ${_step_plugin_ok[$name]} ]]; then
    _step_plugin_ok[$name]=0
    if script=$("$exe" completion zsh 2>/dev/null) && [[ -n $script ]]; then
      eval "$script" 2>/dev/null && (( $+functions[_${exe:t}] )) && _step_plugin_ok[$name]=1
    fi
  fi
  [[ ${_step_plugin_ok[$name]} == 1 ]]
}

_step_with_plugins() {
  local name=${words[2]}
  _step_plugin_scan

  if (( CURRENT >= 3 )) && [[ -n ${_step_plugin_exe[$name]} ]] && _step_plugin_load "$name"; then
    local exe=${_step_plugin_exe[$name]}
    words=("${exe:t}" "${(@)words[3,-1]}")
    (( CURRENT -= 1 ))
    "_${exe:t}"
    return
  fi

  # A separate compadd alongside _step's _describe hides the native subcommands,
  # so both lists go through one _describe call.
  if (( CURRENT == 2 )); then
    local -a opts=() n
    opts=("${(@f)$(_CLI_ZSH_AUTOCOMPLETE_HACK=1 ${words[@]:0:#words[@]-1} --generate-bash-completion)}")
    opts=(${opts:#})
    for n in ${(k)_step_plugin_exe}; do opts+=("${n}:step plugin"); done
    _describe 'values' opts
    return
  fi
  # Native subcommands and flags, as the native `_step` lists them. `_step` is not called: its file binds `step`
  # to itself when it is loaded (last line `compdef _step step`), and its first call completes nothing.
  local -a opts=() n
  local cur=${words[-1]}
  if [[ $cur == -* ]]; then
    opts=("${(@f)$(_CLI_ZSH_AUTOCOMPLETE_HACK=1 ${words[@]:0:#words[@]-1} ${cur} --generate-bash-completion)}")
  else
    opts=("${(@f)$(_CLI_ZSH_AUTOCOMPLETE_HACK=1 ${words[@]:0:#words[@]-1} --generate-bash-completion)}")
  fi
  opts=(${opts:#})
  if (( ${#opts} )); then
    _describe 'values' opts
  else
    _files
  fi
}

compdef _step_with_plugins step
