# vim: filetype=zsh

# brew completions, must be loaded before oh-my-zsh
#FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
test -n $HOMEBREW_PREFIX && FPATH="${_}/share/zsh/site-functions:${FPATH}"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
test -f "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" && . $_

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
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
# COMPLETION_WAITING_DOTS="true"

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
plugins=(
    zsh-autosuggestions
    zsh-history-substring-search
    #zsh-syntax-highlighting
    fast-syntax-highlighting
    git
    golang
    kubectl
    kubetail
)

test -f $ZSH/oh-my-zsh.sh && . $_

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
test -f ~/.p10k.zsh                             && . $_ && typeset -g POWERLEVEL9K_DIR_BACKGROUND=33 # blue prompt
test -f ~/.fzf.zsh                              && . $_
test -f ~/.iterm2_shell_integration.zsh         && . $_
test -f ~/repo/kubectl-aliases/.kubectl_aliases && . $_
test -f ~/.bazshly/bazshly.sh                   && . $_

case $(uname -s) in
  Darwin)
    export LANG="en_US.UTF-8"

    bindkey "^U" backward-kill-line # Ctrl-U

    if [ $EUID -eq 0 ] ; then
      # Allow root to use Homebrew-installed apps.
      # Export PATH before any aliases.
      export PATH="${HOMEBREW_PREFIX}/bin:${PATH}"

      bindkey "^[[1;5D" backward-word      # Ctrl-Left
      bindkey "^[[1;5C" forward-word       # Ctrl-Right
      bindkey "^Y"      yank               # Ctrl-Y
      bindkey '^R'      history-incremental-search-backward
      bindkey "^K"      kill-line          # Ctrl-K
      bindkey "^U"      backward-kill-line # Ctrl-U
      bindkey "^A"      beginning-of-line  # Ctrl-A
      bindkey "^E"      end-of-line        # Ctrl-E
      bindkey "^[[H"    beginning-of-line  # Home
      bindkey "^[[F"    end-of-line        # End

    else
      export PATH="${HOMEBREW_PREFIX}/opt/mysql-client/bin:${PATH}"
     #export PATH="${HOMEBREW_PREFIX}/opt/gawk/libexec/gnubin:${PATH}"

      if [ -f ~/.p10k.zsh ] ; then
        # iTerm2 prompt tail gradation
        typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%K{#585854} %K{#84847C} %K{#B1B1A5} %k'
        typeset -g   POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='%K{#B1B1A5} %K{#84847C} %K{#585854} %k'
      fi

      # gcloud
      test -f ${HOMEBREW_PREFIX}/share/google-cloud-sdk/path.zsh.inc       && . $_
      test -f ${HOMEBREW_PREFIX}/share/google-cloud-sdk/completion.zsh.inc && . $_

      # nvm
      export NVM_DIR="${HOME}/.nvm"

      test -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"                    && . $_ # Thisloads nvm
      test -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" && . $_
    fi
  ;;
esac

if [ $EUID -eq 0 ] ; then
  PS1='%B%F{red}[%n@%m:%~]%#%f%b ' # bold red prompt
else
  which direnv &>/dev/null && eval "$(direnv hook   zsh)"
  which rbenv  &>/dev/null && eval "$(rbenv  init - zsh)"
fi

# EDITOR: nvim/vim/vi
if which nvim &>/dev/null ; then
  export EDITOR="nvim"

  alias      vi="nvim"
  alias     vim="nvim"
  alias    view="nvim -R"
  alias vimdiff="nvim -d"

elif which vim &>/dev/null ; then
  export EDITOR="vim"

  alias vi="vim"

else
  export EDITOR="vi"
fi

# This script was automatically generated by the broot program
# More information can be found in https://github.com/Canop/broot
# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
br(){
  local cmd code cmd_file=$(mktemp)

  if broot --outcmd "$cmd_file" "$@"; then
    cmd=$(<"$cmd_file")
    command rm -f "$cmd_file"
    eval "$cmd"
  else
    code=$?
    command rm -f "$cmd_file"
    return "$code"
  fi
} # br

export BAT_THEME='Dracula'

# Paths
test -d ~/.krew/bin  && PATH=$_:$PATH && export PATH
test -d ~/go/bin     && PATH=$_:$PATH && export PATH
test -d ~/.cargo/bin && PATH=$_:$PATH && export PATH
test -d ~/bin        && PATH=$_:$PATH && export PATH

# Work & private zshrc
test -f ~/.$(basename $SHELL)rc_work && . $_
test -f ~/.$(basename $SHELL)rc_priv && . $_

# Aliases
alias     knife='RBENV_VERSION=3.1.0 knife'
alias highlight='highlight -s candy'

# Show banner on every new ZSH session
if which neofetch &>/dev/null ; then
  echo
  neofetch
  echo
fi

