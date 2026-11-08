# step-kms-plugin Homebrew Formula
#
# Installs the step-kms-plugin binary (KMS plugin for the step CLI).
# Source: https://github.com/smallstep/step-kms-plugin
#
class StepKmsPlugin < Formula
  desc "Plugin for the step CLI to use cloud KMS and hardware keys"
  homepage "https://github.com/smallstep/step-kms-plugin"
  version "0.17.0"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/smallstep/step-kms-plugin/releases/download/v0.17.0/step-kms-plugin_0.17.0_darwin_amd64.tar.gz"
      sha256 "a53d782bd34c540789a263aad64c032e28cc38763d314e43953760578384aefe"
    end
    on_arm do
      url "https://github.com/smallstep/step-kms-plugin/releases/download/v0.17.0/step-kms-plugin_0.17.0_darwin_arm64.tar.gz"
      sha256 "31611a54fb92c7c092e3ac19295c3911e5c2bbebbf5f6405f2eb3fcbeff6b643"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/smallstep/step-kms-plugin/releases/download/v0.17.0/step-kms-plugin_0.17.0_linux_amd64.tar.gz"
      sha256 "dd4df0ceabeaa59c4375bf11df51b59688635076ae1e5c463618c7d43fcbe7b3"
    end
    on_arm do
      url "https://github.com/smallstep/step-kms-plugin/releases/download/v0.17.0/step-kms-plugin_0.17.0_linux_arm64.tar.gz"
      sha256 "d6a6e1b50ce8a569606cd1f33c48c67a13d5dddaddb578989fd70a3540d8ebf0"
    end
  end

  def install
    bin.install "step-kms-plugin"
    bash_completion.install "completions/bash_completion" => "step-kms-plugin"
    zsh_completion.install "completions/zsh_completion" => "_step-kms-plugin"
    fish_completion.install "completions/fish_completion" => "step-kms-plugin.fish"
    pwsh_completion.install "completions/powershell_completion" => "_step-kms-plugin.ps1"

    # `step` completes only its own subcommands. This snippet routes `step <plugin> <TAB>` for any
    # `step-<name>-plugin` executable in $PATH to that plugin's zsh completion. Plugin discovery and
    # `completion zsh` run lazily on the first `step` completion of a session, to keep shell startup fast.
    (pkgshare/"step-plugins-completion.zsh").write <<~EOS
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

        if (( CURRENT == 2 )); then
          local -a plugins=(${(k)_step_plugin_exe})
          (( ${#plugins} )) && compadd -X 'step plugins' -- "${plugins[@]}"
        fi
        _step
      }

      autoload -Uz _step
      compdef _step_with_plugins step
    EOS
  end

  def caveats
    <<~EOS
      To complete `step <plugin> <TAB>` (e.g. `step kms <TAB>`) in zsh, add this line to ~/.zshrc
      after compinit:
        source "#{opt_pkgshare}/step-plugins-completion.zsh"
    EOS
  end

  test do
    system bin/"step-kms-plugin", "--help"
  end
end
