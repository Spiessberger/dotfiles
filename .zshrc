[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# keybinds
bindkey "^[[1;5C" forward-word      # ctrl + arrow right
bindkey "^[[1;5D" backward-word     # ctrl + arrow left
bindkey "^[[1~"   beginning-of-line # pos1
bindkey "^[[4~"   end-of-line       # end

# case insesnitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# style pure promt
PURE_PROMPT_SYMBOL=➜
zstyle :prompt:pure:path color cyan

# load plugins 
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "mafredri/zsh-async"
plug "sindresorhus/pure"

# enable completions
autoload -Uz compinit
compinit

# aliases
alias repoall="repo forall -c git"

# shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

