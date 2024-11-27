ZINIT_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git

if [ ! -d $ZINIT_HOME ]; then
    mkdir -p $ZINIT_HOME
    git clone https://github.com/zdharma-continuum/zinit.git $ZINIT_HOME
fi

source $ZINIT_HOME/zinit.zsh

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::kubectl
zinit snippet OMZP::command-not-found
zinit snippet OMZP::docker-compose
zinit snippet OMZP::pip
zinit snippet OMZP::python
zinit snippet OMZP::vi-mode
#
# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP="erase"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups

bindkey '^k' history-substring-search-up
bindkey '^j' history-substring-search-down

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="nord-extended/nord"
plugins=( 
    sudo 
    zsh-autosuggestions
    docker-compose
    git
    npm
    pip
    python
    postgres
    z
    vi-mode
    kubectl-autocomplete
)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias vim="nvim"
alias vi="nvim"
alias less="bat"
alias cat="bat"

alias icat="kitty +kitten icat"
alias ls='ls --color=auto'

eval "$(starship init zsh)"

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

# source ~/.cargo/bin

# apt() {
#   command nala "$@"
# }
# sudo() {
#   if [ "$1" = "apt" ]; then
#     shift
#     command sudo nala "$@"
#   else
#     command sudo "$@"
#   fi
# }
#
export HISTTIMEFORMAT='%F %T '

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# setxkbmap -option caps:escape

# bun completions
[ -s "/home/larry/.bun/_bun" ] && source "/home/larry/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:~/Documents/work/node_modules/.bin:$PATH"
export XKB_DEFAULT_OPTIONS=caps:escape
export DENO_INSTALL="/home/larry/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export SYSTEMD_EDITOR=nvim

export PATH=$PATH:/home/larry/.local/share/bin

# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source /etc/profile.d/google-cloud-cli.sh
