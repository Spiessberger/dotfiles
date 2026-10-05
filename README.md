# dotfiles

One [GNU Stow](https://www.gnu.org/software/stow/) package per top-level directory.

Run from the repo root; `.stowrc` sets the target to `~`.

```bash
stow <package>    # e.g. stow kitty nvim tmux
stow -D <package> # unlink
```

### Symlinking files instead of directories

By default stow folds: if a target directory doesn't exist yet, it symlinks the whole
directory into the repo, so anything an app writes there ends up in here. To get real
directories with only the individual files symlinked:

```bash
stow --no-folding <package>
```

## Nuances

- **Git identity is not in here.** `user.name`/`user.email` go in `~/.gitconfig`.
