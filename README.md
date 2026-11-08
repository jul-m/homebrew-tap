# homebrew-tap
---
## English

This repository is a Homebrew tap that allows you to install packages that are either not available in the official Homebrew repositories or are provided here in more recent versions.

### Available Packages

- tcping (v3.7) – [GitHub](https://github.com/paradiseduo/tcping)
- step-kms-plugin (v0.17.0) – [GitHub](https://github.com/smallstep/step-kms-plugin)

### Installation

To install a package, use the following command:

```sh
brew install jul-m/tap/<package>
```

For example:

```sh
brew install jul-m/tap/tcping
brew install jul-m/tap/step-kms-plugin
```

### Snippets
#### Shell completion for `step` plugins (zsh) : [share/step/step-plugins-completion.zsh](./share/step/step-plugins-completion.zsh)

`step-kms-plugin` installs a zsh snippet that completes `step <plugin> <TAB>` for any `step-<name>-plugin` executable found in `$PATH`. To enable it, add this line to `~/.zshrc`, after `compinit`:

```sh
source "$(brew --prefix)/opt/step-kms-plugin/share/step-kms-plugin/step-plugins-completion.zsh"
```

The plugin scan and completion loading happen on the first `step` completion of each shell session, so shell startup time is not affected.


### Disclaimer
> [!CAUTION]
> This repository and its maintainer are not affiliated with, endorsed by, or responsible for the official projects or their maintainers. All trademarks, logos, and brand names are the property of their respective owners. Use these packages at your own risk. No warranty is provided.

---

## Français

Ce dépôt est un tap Homebrew qui permet d’installer des paquets qui ne sont pas disponibles dans les dépôts officiels Homebrew ou qui sont proposés ici dans des versions plus récentes.

### Paquets disponibles

- tcping (v3.7) – [GitHub](https://github.com/paradiseduo/tcping)
- step-kms-plugin (v0.17.0) – [GitHub](https://github.com/smallstep/step-kms-plugin)

### Installation

Pour installer un paquet, utilisez la commande suivante :

```sh
brew install jul-m/tap/<paquet>
```

Par exemple :

```sh
brew install jul-m/tap/tcping
brew install jul-m/tap/step-kms-plugin
```

### Snippets
#### Complétion shell pour les plugins `step` (zsh) : [share/step/step-plugins-completion.zsh](./share/step/step-plugins-completion.zsh)

`step-kms-plugin` installe un snippet zsh qui complète `step <plugin> <TAB>` pour tout exécutable `step-<name>-plugin` présent dans `$PATH`. Pour l'activer, ajoutez cette ligne à `~/.zshrc`, après `compinit` :

```sh
source "$(brew --prefix)/opt/step-kms-plugin/share/step-kms-plugin/step-plugins-completion.zsh"
```

La recherche des plugins et le chargement de leur complétion ont lieu à la première complétion `step` de chaque session shell : le démarrage du shell n'est pas ralenti.


### Avertissement
> [!CAUTION]
> Ce dépôt et son mainteneur ne sont pas affiliés, approuvés ou responsables des projets officiels ou de leurs mainteneurs. Toutes les marques, logos et noms de marque sont la propriété de leurs détenteurs respectifs. Utilisez ces paquets à vos propres risques. Aucune garantie n’est fournie.
