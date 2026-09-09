ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME/.git" ]]; then
  mkdir -p "${ZINIT_HOME:h}"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

ZSH_AUTOSUGGEST_USE_ASYNC=false
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab
zinit snippet OMZP::git
zinit snippet OMZP::sudo
if [[ -r /etc/arch-release ]]; then
  zinit snippet OMZP::archlinux
elif [[ -r /etc/os-release ]] && grep -q '^ID=ubuntu' /etc/os-release; then
  zinit snippet OMZP::ubuntu
fi
zinit snippet OMZP::command-not-found
zinit snippet OMZP::pip

autoload -Uz compinit && compinit
zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons $realpath'

HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
setopt inc_append_history share_history hist_ignore_space
setopt hist_ignore_all_dups hist_save_no_dups hist_ignore_dups

bindkey '^k' history-substring-search-up
bindkey '^j' history-substring-search-down
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

alias vim='nvim'
alias vi='nvim'
alias cat='bat'
alias less='bat'
alias ls='eza --color=auto --icons'
alias ll='eza -la --color=auto --icons --git'
alias icat='kitty +kitten icat'
alias git-commit='git commit -S'

export SYSTEMD_EDITOR=nvim
export EDITOR=nvim
export VISUAL=nvim
export XKB_DEFAULT_OPTIONS=caps:escape
export HISTTIMEFORMAT='%F %T '

command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
command -v mise >/dev/null && eval "$(mise activate zsh)"

fixline() {
  zle clear-screen
  zle reset-prompt
}
zle -N fixline
bindkey '^O' fixline

# Keep syntax highlighting last among plugins so it can wrap widgets cleanly.
zinit light zsh-users/zsh-syntax-highlighting

# Machine-specific paths, device addresses, SDK setup, and private environment
# variables belong here. This file is intentionally not tracked.
[[ -r "$XDG_CONFIG_HOME/zsh/local.zsh" ]] && source "$XDG_CONFIG_HOME/zsh/local.zsh"
