# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages macos iterm2 zsh-256color zsh-apple-touchbar virtualenv vi-mode fzf)

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
################################################
#                ***WARNING***                 #
#         FILE GENERATED BY BOOKSTRAP          #
#  ANY CHANGES TO THIS FILE WILL BE LOST WHEN  #
#         YOU EXECUTE BOOKSTRAP AGAIN          #
################################################

# Homebrew (Intel and M1)
if [ -x "$(command -v /opt/homebrew/bin/brew)" ]
then
    eval $(/opt/homebrew/bin/brew shellenv)
elif [ -x "$(command -v /usr/local/bin/brew)" ]
then
    eval $(/usr/local/bin/brew shellenv)
fi

# local::lib
if [ -d ~/perl5 ]; then
    eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
    export PATH="$HOME/perl5/bin:$PATH"
fi

# local git tree
if [ -d ~/git_tree ]; then
    export GIT_TREE="$HOME/git_tree"
elif [ -d /usr/local/git_tree ]; then
    export GIT_TREE="/usr/local/git_tree"
fi

if [ "$GIT_TREE" != "" ]; then
    export PATH="$PATH:$GIT_TREE/main/bin"
    export PERL5LIB="$PERL5LIB:$GIT_TREE/main/lib:$GIT_TREE/main/inc/Perl-Critic-Policy-BCritical/lib/"
fi

# zsh-completion
if type brew &>/dev/null; then
    BREW_PREFIX=$(brew --prefix)

    # GNU Command Line Tools
    export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="$BREW_PREFIX/opt/grep/libexec/gnubin:$PATH"

    # zsh completions
    FPATH=$BREW_PREFIX/share/zsh-completions:$BREW_PREFIX/share/zsh/site-functions:$FPATH
    autoload -Uz compinit
    compinit -i
fi

# bk completion
_bootstrap_bk () {
    if [ -f /usr/local/bin/bk ]; then
        source <(bk completion zsh)
        _bk
    fi
}

if [[ $SHELL == *zsh* ]]; then
  compdef _bootstrap_bk bk
fi

# Source aliases
if [ -f ~/.alias ]; then
    . ~/.alias
fi

if [ -f ~/.git-prompt.sh ]; then
    . ~/.git-prompt.sh
    GIT_PS1_SHOWCOLORHINTS=1
    setopt PROMPT_SUBST ; PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '
fi

##############################
########## My stuff ##########
##############################

eval "$(/opt/homebrew/bin/brew shellenv)"

# ls
alias ls='ls --color=always -Gh'
alias lf='ls -F'
alias la='ls -A'
alias laf='ls -AF'
alias ll='ls -lA'
alias llf='ls -lAF'

# Vim
if [[ $SHELL == *zsh* ]]; then
  bindkey -v
elif [[ $SHELL == *bash* ]]; then
  set -o vi
fi

alias vi=$(which vim)  # Typing `vi` invokes `vim`.
alias vim=nvim  # Typing `vim` actually invokes `nvim`.
alias vimr='vim -R'  # Open in read-only mode.

# Git
alias g=git

# Python
alias python=python3
alias pip=pip3
alias pipif='pip install --break-system-packages'

# Reboot.
alias reboot='shutdown -r now'

# xtrace
alias xtrace='set -o xtrace'
alias noxtrace='set +o xtrace'

# g++
alias g++20='g++ -std=c++20'

# Play sound aliases.
alias beep='tput bel'
alias frog='afplay /System/Library/Sounds/Frog.aiff'
alias yo='say yo'

# curl
alias curl5='curl -fiv'  # There is no -e.

# Copy alias.
c() {
    x="$(type "$1")"
    x="${x/$1 is an alias for /}"
    echo -n "${x}" | pbcopy
    echo "Copied '${x}'"
}

# Basic stuff!
C="pbcopy"
H="--help"
L="less"
hl() {
    "$@" --help | less
}
ec() {
    echo "$@" | pbcopy
}

# pre-commit
alias pc='pre-commit'

alias pcsc='pre-commit sample-config'
alias pcscpccy='pre-commit sample-config > .pre-commit-config.yaml'

alias pci='pre-commit install'

alias pcr='pre-commit run'
alias pcraf='pre-commit run --all-files'

# Good morning!
alias nofri_home='bash ~/.cp_dotfiles.sh --git_repo ~/git_tree/home --message "${M}"'
alias nofri_git='git syncall'
alias nofri_brew='brew upgrade && brew upgrade $(brew outdated --cask --greedy --quiet | gsed -z "s/\n/ /g")'
alias nofri_pip='pip-review --local --auto'
alias nofri='nofri_home && nofri_git && nofri_brew && nofri_pip'

# yarn
alias y='yarn'
alias yv='yarn version'
alias yvp='yarn version --patch'

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"

