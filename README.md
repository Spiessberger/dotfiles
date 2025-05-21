# Setup
```
sudo dnf install zsh tmux stow nvim fzf kitty -y
sudo dnf copr enable lihaohong/yazi -y && sudo dnf install yazi -y
sudo dnf copr enable atim/lazygit -y && sudo dnf install lazygit -y

# zsh plugin manager
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
