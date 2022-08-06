#!/bin/bash

export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Fafacxdxbxegedabagacad

# PROMPT STUFF
GREEN=$(tput setaf 2);
YELLOW=$(tput setaf 3);
RESET=$(tput sgr0);

function git_branch {
  # Shows the current branch if in a git repository
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \(\1\)/';
}

function random_element {
  declare -a array=("$@")
  r=$((RANDOM % ${#array[@]}))
  printf "%s\n" "${array[$r]}"
}

# Default Prompt
setEmoji () {
  EMOJI="$*"
  DISPLAY_DIR='$(dirs)'
  DISPLAY_BRANCH='$(git_branch)'
  PROMPT="${YELLOW}${DISPLAY_DIR}${GREEN}${DISPLAY_BRANCH}${RESET} ${EMOJI}"$'\n'"$ ";
}

newRandomEmoji () {
  setEmoji "$(random_element 😅 👽 🔥 🚀 👻 ⛄ 👾 🍔 😄 🍰 🐑 😎 🏎 🤖 😇 😼 💪 🦄 🥓 🌮 🎉 💯 ⚛️ 🐠 🐳 🐿 🥳 🤩 🤯 🤠 👨‍💻 🦸‍ 🧝‍ 🧞‍ 🧙‍ 👨‍🚀 👨‍🔬 🕺 🦁 🐶 🐵 🐻 🦊 🐙 🦎 🦖 🦕 🦍 🦈 🐊 🦂 🐍 🐢 🐘 🐉 🦚 ✨ ☄️ ⚡️ 💥 💫 🧬 🔮 ⚗️ 🎊 🔭 ⚪️ 🔱)"
}

newRandomEmoji

# allow substitution in PS1
setopt promptsubst

# history size
HISTSIZE=5000
HISTFILESIZE=10000

SAVEHIST=5000
setopt EXTENDED_HISTORY
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# do not store duplications
setopt HIST_IGNORE_DUPS

# PATH ALTERATIONS
## Node
PATH="/usr/local/bin:$PATH:./node_modules/.bin";

## Yarn
PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# alias yarn="echo update the PATH in ~/.zshrc"

# npm.im/n
export N_PREFIX="$HOME/n"; [[ :$PATH: == *"$N_PREFIX/bin"* ]] || PATH="$N_PREFIX/bin:$PATH"  # Added by n-install (see http://git.io/n-install-repo).

# Custom Aliases
alias code="\"/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code\""
function c { code ${@:-.} }
alias ll="ls -1a";
alias ..="cd ../";
alias ..l="cd ../ && ls";
alias cz="code ~/.zshrc";
alias sz="source ~/.zshrc";
alias npm-update="npx npm-check-updates --dep prod,dev --upgrade";
alias yarn-update="yarn upgrade-interactive --latest";
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"

## git aliases
function gc { git commit -m "$@"; }
alias go="git checkout";
alias gs="git status";
alias gp="git pull";
alias gf="git fetch";
alias gpush="git push";
alias gd="git diff";
alias ga="git add .";
dif() { git diff --color --no-index "$1" "$2" | diff-so-fancy; }
cdiff() { code --diff "$1" "$2"; }

## yarn aliases
alias yar="yarn run";
alias yas="yarn run start";
alias yab="yarn run build";
alias yat="yarn run test";

# Custom functions
mg () { mkdir "$@" && cd "$@" || exit; }
cdl() { cd "$@" && ll; }
npm-latest() { npm info "$1" | grep latest; }
killport() { lsof -i tcp:"$*" | awk 'NR!=1 {print $2}' | xargs kill -9 ;}
function quit () {
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: quit appname"
  else
    for appname in $1; do
    osascript -e 'quit app "'$appname'"'
    done
  fi
}

# zsh auto autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Uncomment below for private zshrc configuration that you don't want exposed in the git repo
# source ~/.zshrc.private