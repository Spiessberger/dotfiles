# dotfiles

Fedora config files, tracked with a bare git repo at `~/.dotfiles` — the files
live directly in `$HOME`, there are no symlinks and nothing is copied.

Tracked: **zsh**, **tmux**, **kitty**, **git**.

## Setup on a new machine

```bash
# 1. packages
sudo dnf install -y \
	zsh zsh-autosuggestions zsh-syntax-highlighting \
	tmux kitty git fzf zoxide bat

# 2. the repo itself
git clone --bare https://github.com/Spiessberger/dotfiles "$HOME/.dotfiles"
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout

# 3. post-checkout setup (no sudo: tpm, cache dirs, git flags)
"$HOME/.local/bin/dotfiles-bootstrap"

# 4. make zsh the login shell, then log out and back in
chsh -s /usr/bin/zsh
```

Also needed: **JetBrainsMono Nerd Font**, which Fedora does not package.

```bash
mkdir -p ~/.local/share/fonts/JetBrainsMono
curl -fLo /tmp/JetBrainsMono.zip \
	https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -f
```

### If step 2 fails with "would be overwritten by checkout"

The checkout refuses to clobber files Fedora already put in `$HOME` (usually
`.bashrc` and `.bash_profile`). Back them up and retry:

```bash
mkdir -p ~/.dotfiles-backup
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout 2>&1 \
	| grep -E '^\s+\.' | awk '{print $1}' \
	| xargs -I{} mv ~/{} ~/.dotfiles-backup/{}
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
```

## Daily use

`.zshrc` defines a `config` function that talks to the bare repo, and registers
git's own completion for it — so `config` tab-completes subcommands, branches
and paths exactly like `git` does.

```bash
config status
config add .config/kitty/kitty.conf
config commit -m "tweak kitty padding"
config push
```

Paths are relative to `$HOME`, and `config` works from any directory.

To start tracking a new file, add it to the allowlist in `~/.gitignore` first —
the work tree is `$HOME`, so the repo ignores everything by default and
un-ignores only what it manages. Then `config add` it as usual.

## What is not tracked

- **niri** — removed for now, to be re-added later.
- **alacritty** — dropped in favour of kitty.

## Notes

- zsh has no plugin manager. `zsh-autosuggestions` and `zsh-syntax-highlighting`
  come from Fedora packages and are sourced by path; the prompt is built from
  zsh's own `vcs_info`.
- tmux still uses [tpm](https://github.com/tmux-plugins/tpm). It self-installs on
  first launch, so `dotfiles-bootstrap` is only a convenience.
- The tmux config lives at `~/.config/tmux/tmux.conf`, not `~/.tmux.conf`
  (needs tmux 3.1+).
