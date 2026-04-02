# homebrew-singctl

Homebrew tap for installing [singctl](https://github.com/sixban6/singctl).

## Install

```bash
brew tap sixban6/singctl
brew install sixban6/singctl/singctl
```

## Upgrade

```bash
brew update
brew upgrade singctl
```

## Auto Update Formula

This tap includes GitHub Actions workflow `.github/workflows/update-formula.yml`.
It checks `sixban6/singctl` latest release every 6 hours and automatically updates
`Formula/singctl.rb` (`version` + `sha256`) and pushes to `main` when needed.

You can also trigger it manually from GitHub Actions: `Update Singctl Formula`.
