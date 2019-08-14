#
# ~/.bashrc
#
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
### BASH CFG ###############################################################################################################################################
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
[[ $- != *i* ]] && return

xhost +local:root > /dev/null 2>&1

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s hostcomplete
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
### COLORS #################################################################################################################################################
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
 	else
		PS1='\[\033[01;34m\][\u@\h\[\033[01;37m\] \W\[\033[01;34m\]]\$\[\033[00m\] '
	fi

	alias diff='diff --color=auto'
    alias la='ls -lah --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
    alias ll='ls -lh --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
    alias ls='ls -h --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
    ### https://unix.stackexchange.com/q/148
    GREP_OPTS='--color=auto'      # for aliases since $GREP_OPTIONS is deprecated
    GREP_COLOR='1;32'             # (legacy) bright green rather than default red
    GREP_COLORS="ms=$GREP_COLOR"  # (new) Matching text in Selected line = green
    alias grep='grep $GREP_OPTS'
    alias egrep='egrep $GREP_OPTS'
    alias fgrep='fgrep $GREP_OPTS'
    
    
    

else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
### COLOR IN MAN ###########################################################################################################################################
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
unset use_color safe_term match_lhs sh
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
### ENVIRONMENT ############################################################################################################################################
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
export BROWSER=/usr/bin/xdg-open
export EDITOR=/usr/bin/nano
export JAVA_FONTS=/usr/share/fonts/TTF
export PATH="$HOME/bin:$PATH"
export VISUAL=$EDITOR
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
### COLORS ENV #############################################################################################################################################
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
export SYSTEMD_COLORS=1
export GCC_COLORS="auto"
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33'

export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[0;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
### BASH COMPLETION ########################################################################################################################################
### WARNING REQUIRED: bash-completion ######################################################################################################################
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
### SSH ####################################################################################################################################################
### WARNING REQUIRED: keychain ssh #########################################################################################################################
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
[ -f $HOME/.ssh/id_rsa ] && keychain $HOME/.ssh/id_rsa --quiet
[ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
### FUNCTIONS ##############################################################################################################################################
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
function kz() { sudo pkill -9 ; }
export -f kz
#:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++:#
function pacb() {   if [[ ! -d /tmp/makepkg ]] ; then mkdir -p /tmp/makepkg ; else rm -rf /tmp/makepkg/* ; fi
                    if [[ -f PKGBUILD ]] ; then BUILDDIR=/tmp/makepkg makepkg -sc ; fi }
export -f pacb
#:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++:#
function pacin() { export LANG=en_US && yes|sudo pacman -U *.pkg.tar.xz; }
export -f pacin
#:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++:#
function pacmv() { sudo mv *.pkg.tar.xz /var/cache/pacman/pkg/ ; sudo chown root:root /var/cache/pacman/pkg/* ; }
export -f pacmv
#:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++:#
function pacr() { sudo pacman-mirrors --country Bulgaria Denmark Czech Germany France --api --set-branch testing -P https;yaourt -Syyu ; }
export -f pacr
#:++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++:#
function pun() { if [ -f /var/lib/pacman/db.lck ] ; then sudo rm -rf /var/lib/pacman/db.lck ; fi; }
export -f pun
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
### ALIASES ################################################################################################################################################
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
alias aliases="cat $HOME/.bashrc|grep 'alias '"
alias aur-commit="git pull;mksrcinfo && git add --all && git status && git commit -am 'update' && git push -u origin master"
alias bcd="cd ~;sort -u .bash_history > bash_history && mv bash_history .bash_history;"
alias ccat='pygmentize -g'
alias clean-journal="sudo journalctl --rotate && sudo journalctl --vacuum-time=1s"
alias show-journal="journalctl --this-boot --no-pager --no-hostname"
alias cp="cp -i"            # confirm before overwriting something
alias df='df -hT'           # human-readable sizes
alias eg='sudo nano /etc/default/grub'
alias free='free -mh'       # show sizes in GB
# alias freem="sudo bash -c 'free -h && sync && echo 3 > /proc/sys/vm/drop_caches && free -h'" 
alias gc='git clone'
alias git-commit="git pull;git add --all && git status && git commit -am \"updates 20$(date +%y%m%d)\" && git push -u origin master"
alias grep='grep --color=tty -d skip'
alias paclean="sudo rm -rf /var/cache/pacman/pkg/*"
alias pacex="sudo pacman -D --asexplicit "
alias reboot='systemctl reboot'
alias restartps="killall plasmashell; plasmashell > /dev/null 2>&1 & disown"
alias saidar='saidar -c'
alias src="source $HOME/.bashrc"
alias ug="sudo update-grub"
alias ws='watch sensors'
alias zombie='ps axo stat,ppid,pid,comm | grep -w defunct'
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
# Clear terminal window buffer
alias clear="clear && printf '\e[3J'"
bind -x '"\C-t": clear && echo -e "\033c\c"';
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.bz2)       bunzip2 $1       ;;
      *.rar)       unrar x $1       ;;
      *.tar)       tar xf $1        ;;
      *.gz)        gunzip $1        ;;
      *.tar.bz2)   tar xjf $1       ;;
      *.tar.gz)    tar xzf $1       ;;
      *.tar.xz)    tar xJf $1       ;;
      *.tbz2)      tar xjf $1       ;;
      *.tgz)       tar xzf $1       ;;
      *.xz)        unxz --keep $1   ;;
      *.Z)         uncompress $1    ;;
      *.zip)       unzip $1         ;;
      *.7z)        7z x $1          ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
### HSTR SETTINGS ##########################################################################################################################################
# WARNING REQUIRED: hstr-git ###############################################################################################################################
#:--------------------------------------------------------------------------------------------------------------------------------------------------------:#
export HH_CONFIG=hicolor         # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh -- \C-j"'; fi
