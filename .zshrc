if [[ -z $DISPLAY && $(tty) = /dev/tty1 ]]; then
    exec startx
fi

#------------------------------
## Variables
##------------------------------
export EDITOR="/usr/bin/vim"
#export JAVA_HOME="/usr/lib/jvm/java-6-sun"
#export PATH=/home/home/lib/android-sdk-linux_86:/usr/local/bin:$JAVA_HOME/bin:$PATH
#export GTK_IM_MODULE=ibus
#export XMODIFIERS="@im=ibus"
#export QT_IM_MODULE=ibus

#x-unikey
#export XMODIFIERS="@im=unikey"
#export GTK_IM_MODULE=xim
#export QT_IM_MODULE=xim

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/omnetpp-4.2.1/lib
#export PATH=$PATH:/usr/lib64/llvm/libclang.so
export PATH=$PATH:/opt/vmware/bin
export TCL_LIBRARY=/usr/lib/tcl8.5

export LD_LIBRARY_PATH=/usr/lib/llvm/:$LD_LIBRARY_PATH
#
##-----------------------------
## Dircolors
##-----------------------------
autoload -U colors && colors
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS

autoload -U compinit promptinit
compinit -i
promptinit; prompt gentoo

# Push and pop directories on directory stack
#alias pu='pushd'
#alias po='popd'

# Basic directory operations
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'
alias si='sudo -i'

#alias g='grep -in'

# Show history
alias history='fc -l 1'

# List direcory contents
alias ls="ls --color -F"
alias ll="ls --color -lh"
alias lsa='ls -lah'
alias l='ls -la'


alias afind='ack-grep -il'

alias grep='grep --color=auto'
alias es='emerge --sync && layman -S'
#alias euw='emerge -aupD world'
alias ew='emerge -uaND world'
alias ei='emerge'
alias ec='emerge -CD'
alias tx='tar zxvf'
alias la='ls -A'
alias shd='shutdown -h now'
alias shr='shutdown -r now'

alias -s pdf=evince


#completion
# fixme - the load process here seems a bit bizarre

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end
#setopt correctall


WORDCHARS=''

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# use /etc/hosts and known_hosts for hostname completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  `hostname`
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache avahi bin daemon \
        dbus ftp games halt ldap mysql nagios \
        news nobody ntp nut nx privoxy shutdown sync 

# ... unless we really want to.
zstyle '*' single-ignored show

if [ "$DISABLE_COMPLETION_WAITING_DOTS" != "true" ]; then
  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
fi

## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=8000
SAVEHIST=8000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

bindkey -e
bindkey '\ew' kill-region
bindkey -s '\el' "ls\n"
bindkey -s '\e.' "..\n"
bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[4~" end-of-line
bindkey ' ' magic-space    # also do history expansion on space

bindkey '^[[Z' reverse-menu-complete

# Make the delete key (or Fn + Delete on the Mac) work instead of outputting a ~
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

# Colorful basic prompt
export PS1=$'%{\e[1;32m%}%n%{\e[0m%}%{\e[1;34m%}@%{\e[1;31m%}%m %{\e[1;34m%}%~ %{\e[0m%}%# '
export RPS1=$'%{\e[1;30m%}<%T%{\e[0m%}'
#export PS2=$'%{\e[0;37m%} %_>%{\e[0m%} '
export MOZ_DISABLE_PANGO=1
export BSPWM_SOCKET=/tmp/bspwm-socket
export XDG_CONFIG_HOME=~/.config
#export http_proxy=127.0.0.1:8123
#export JAVA_HOME=/usr/lib/jvm/icedtea-bin-6
export GAMA=/home/tom/old/tool/gama
export PATH=$PATH:$JAVA_HOME/bin:$GAMA
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export PATH=$HOME/.cabal/bin:$PATH

#Show progress while file is copying

# Rsync options are:
# -p - preserve permissions
# -o - preserve owner
# -g - preserve group
# -h - output in human-readable format
# --progress - display progress
# -b - instead of just overwriting an existing file, save the original
# --backup-dir=/tmp/rsync - move backup copies to "/tmp/rsync"
# -e /dev/null - only work on local files
# -- - everything after this is an argument, even if it looks like an option

alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"
