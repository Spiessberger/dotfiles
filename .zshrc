# history
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

export EDITOR=vim

# completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case insensitive
autoload -Uz compinit
_zcompdir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[ -d "$_zcompdir" ] || mkdir -p "$_zcompdir"
compinit -d "$_zcompdir/zcompdump"
unset _zcompdir

# keybinds
bindkey -e

# word motion
bindkey "^[[1;5C" forward-word      # ctrl + arrow right
bindkey "^[[1;5D" backward-word     # ctrl + arrow left
bindkey "^[[1;3C" forward-word      # alt  + arrow right
bindkey "^[[1;3D" backward-word     # alt  + arrow left

# pos1/end. kitty sends ^[OH/^[OF in application mode and ^[[H/^[[F otherwise,
# while tmux rewrites both forms to ^[[1~/^[[4~ -- so bind every variant.
for k in "^[[H" "^[OH" "^[[1~" "^[[7~"; do bindkey "$k" beginning-of-line; done
for k in "^[[F" "^[OF" "^[[4~" "^[[8~"; do bindkey "$k" end-of-line; done
unset k

# deletion. without the first line, del is unbound and inserts a literal "~"
bindkey "^[[3~"   delete-char
bindkey "^[[3;5~" kill-word           # ctrl + del
bindkey "^H"      backward-kill-word  # ctrl + backspace (kitty sends ^H, plain backspace is ^?)

# fallback for terminals whose sequences differ from all of the above
[[ -n "${terminfo[khome]}" ]] && bindkey -- "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}"  ]] && bindkey -- "${terminfo[kend]}"  end-of-line
[[ -n "${terminfo[kdch1]}" ]] && bindkey -- "${terminfo[kdch1]}" delete-char

# prompt
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr   '+'
zstyle ':vcs_info:git:*' formats       ' %F{242}%b%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{242}%b|%a%u%c%f'
add-zsh-hook precmd vcs_info
setopt prompt_subst
PROMPT='%F{cyan}%~%f${vcs_info_msg_0_}
%(?.%F{magenta}.%F{red})➜%f '

# dotfiles bare repo
config() {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}
# complete `config` exactly like `git`:
#   - local -x exports the bare repo location for the duration of the completion,
#     so the git subprocesses _git spawns to list branches/files find it too
#   - service=git is required: _git only completes when $service is "git",
#     otherwise it dispatches to _$service and recurses back into this function
_config() {
  local -x GIT_DIR="$HOME/.dotfiles" GIT_WORK_TREE="$HOME"
  local service=git
  _git
}
compdef _config config

# aliases
alias repoall="repo forall -c git"

# shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# plugins (dnf: zsh-autosuggestions zsh-syntax-highlighting)
# if-blocks rather than `[[ ... ]] && source`, which would leave $? at 1 when the
# package is missing and paint the first prompt's arrow red
if [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# keep syntax highlighting last
if [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
