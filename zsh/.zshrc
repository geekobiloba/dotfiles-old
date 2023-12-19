# BEGIN safe early config
#
# All configs below are SAFE because they test each parameter
# before sourcing or exporting it,
# and do not blindly assume that you use any specific add-ons,
# like oh-my-zsh or Powerevel10K.
# But when you do, they will be loaded properly.
#

# Powerlevel10k instant prompt, should stay close to the top of ~/.zshrc
test -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" && . $_

if [ -n "$HOMEBREW_PREFIX" ] ; then

  # brew completions, should be loaded before oh-my-zsh
  FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:$FPATH"

  test -d ${HOMEBREW_PREFIX}/opt/speedtest/bin          && PATH=$_:$PATH && export PATH
  test -d ${HOMEBREW_PREFIX}/opt/mysql-client/bin       && PATH=$_:$PATH && export PATH
  test -d ${HOMEBREW_PREFIX}/opt/grep/libexec/gnubin    && PATH=$_:$PATH && export PATH
  test -d ${HOMEBREW_PREFIX}/opt/gawk/libexec/gnubin    && PATH=$_:$PATH && export PATH
  test -d ${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin && PATH=$_:$PATH && export PATH

  test -r ${HOMEBREW_PREFIX}/share/google-cloud-sdk/path.zsh.inc       && . $_
  test -r ${HOMEBREW_PREFIX}/share/google-cloud-sdk/completion.zsh.inc && . $_
fi

# pyenv - load before oh-my-zsh pyenv plugin
test -d ~/.pyenv && PYENV_ROOT=$_ && export PYENV_ROOT

# Paths
test -d ~/.pyenv/bin && PATH=$_:$PATH && export PATH
test -d ~/.local/bin && PATH=$_:$PATH && export PATH
test -d ~/.cargo/bin && PATH=$_:$PATH && export PATH
test -d ~/.krew/bin  && PATH=$_:$PATH && export PATH
test -d ~/go/bin     && PATH=$_:$PATH && export PATH
test -d ~/bin        && PATH=$_:$PATH && export PATH

which pipx   &>/dev/null && eval "$(register-python-argcomplete pipx)" # pipx completions
which pyenv  &>/dev/null && eval "$(pyenv  init --path)"
which rbenv  &>/dev/null && eval "$(rbenv  init - zsh)"
which direnv &>/dev/null && eval "$(direnv hook   zsh)"

# Key bindings
bindkey "^A"      beginning-of-line
bindkey "^[[H"    beginning-of-line # Home
bindkey "^[[1;5D" backward-word     # Ctrl-Left
bindkey "^[[1;5C" forward-word      # Ctrl-Right
bindkey "^Y"      yank              # Ctrl-Y
bindkey "^[[F"    end-of-line       # End
bindkey "^E"      end-of-line
bindkey "^K"      kill-line
bindkey "^U"      backward-kill-line
bindkey '^R'      history-incremental-search-backward

# bold red prompt for root
test $EUID -eq 0 && PS1='%B%F{red}[%n@%m:%~]%#%f%b '
# END safe early config

# zsh config
HYPHEN_INSENSITIVE="true"
       HIST_STAMPS="yyyy-mm-dd"

if [ -d ~/.oh-my-zsh ] ; then
  export ZSH="${HOME}/.oh-my-zsh"

  if [ -r ~/.p10k.zsh ] ; then

    # Theme should be loaded before oh-my-zsh
    ZSH_THEME="powerlevel10k/powerlevel10k"

    . ~/.p10k.zsh

    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

    # blue prompt
    typeset -g POWERLEVEL9K_DIR_BACKGROUND=33

    case $(uname -s) in
      Darwin)

        # iTerm2 prompt tail gradation
        typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%K{#585854} %K{#84847C} %K{#B1B1A5} %k'
        typeset -g   POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='%K{#B1B1A5} %K{#84847C} %K{#585854} %k'
        ;;
    esac
  fi

  plugins=(
    zsh-autosuggestions
    zsh-history-substring-search
   #zsh-syntax-highlighting
    fast-syntax-highlighting
    git
    gh
    golang
   #python
    pip
    pyenv
    ruby
    gem
    kubectl
    kubetail
    1password
    knife
    knife_ssh
    httpie
    nmap
    terraform
    rsync
   #macos
   #iterm2
  )

  . ${ZSH}/oh-my-zsh.sh
fi

# Locale
case $(uname -s) in
  Darwin)
    export LANG="en_US.UTF-8"
    ;;
esac

# EDITOR: nvim/vim/vi
if
  which nvim &>/dev/null
then
  export EDITOR='nvim'
  alias      vi='nvim'
  alias     vim='nvim'
  alias    view='nvim -R'
  alias vimdiff='nvim -d'
elif
  which vim &>/dev/null
then
  export EDITOR='vim'
  alias      vi='vim'
else
  export EDITOR='vi'
fi

# nvm
test -r ~/.nvm && NVM_DIR=$_:$PATH && export PATH

if [ -n "$HOMEBREW_PREFIX" ] ; then
  test -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"                    && . $_ # loads nvm
  test -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" && . $_
fi

# code highlighter
alias  highlight='highlight -s candy'
export BAT_THEME='Dracula'

# BEGIN pipx safe environment for Ansible
if [ -d ~/.pipx ] ; then
  export        PIPX_HOME="${HOME}/.pipx"
  export   PIPX_TRASH_DIR="${PIPX_HOME}/trash"
  export PIPX_SHARED_LIBS="${PIPX_HOME}/shared"
  export PIPX_LOCAL_VENVS="${PIPX_HOME}/venvs"
fi
# END pipx safe environment for Ansible

# BEGIN safe late config
# fzf should be loaded after oh-my-zsh plugins
test -r ~/.fzf.zsh                                      && . $_
test -r ~/.local/share/kubectl-aliases/.kubectl_aliases && . $_
test -r ~/.iterm2_shell_integration.zsh                 && . $_
test -r ~/.bazshly/bazshly.sh                           && . $_
test -r ~/.zshrc_work                                   && . $_
test -r ~/.zshrc_priv                                   && . $_
# END safe late config

# BEGIN aliases
alias knife='RBENV_VERSION=3.1.4 knife'
alias  kctx='kubectl ctx'
alias   kns='kubectl ns'
# END aliases

# Show neofetch on every new zsh session
if which neofetch &>/dev/null ; then
  echo
  neofetch
  echo
fi

