# ~/.bashrc: executed by bash(1) for non-login shells.

# Path in the common things
PATH="$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/local/bin:/sbin:/bin"
LD_LIBRARY_PATH="/opt/local/lib:/usr/local/lib:/usr/lib"

# ~/local/ is much like /opt, but just for me. All bin/, include/, lib/, etc
# folders are pathed in
for i in $HOME/local/*; do
	[ -d $i/bin ] && PATH="${i}/bin:${PATH}"
	[ -d $i/sbin ] && PATH="${i}/sbin:${PATH}"
	[ -d $i/include ] && CPATH="${i}/include:${CPATH}"
	[ -d $i/lib ] && LD_LIBRARY_PATH="${i}/lib:${LD_LIBRARY_PATH}"
	[ -d $i/lib/pkgconfig ] && PKG_CONFIG_PATH="${i}/lib/pkgconfig:${PKG_CONFIG_PATH}"
	[ -d $i/share/man ] && MANPATH="${i}/share/man:${MANPATH}"
done

# Cabal, for Haskell stuff
if [ -d $HOME/.cabal/bin ] ; then
	PATH="${HOME}/.cabal/bin:${PATH}"
fi

export PATH
export CPATH
export LD_LIBRARY_PATH
export PKG_CONFIG_PATH
export MANPATH

export ACK_OPTIONS="--pager=less --type-add php=.ctp --type-add js=.coffee"
export TZ='Australia/Hobart'
export NODE_PATH=$HOME/local/node/lib/node_modules
umask 002

# Yay vim
export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'
alias vi='vim -p'

# less: Quit if little text, Colours, fold, do not clear screen
export LESS='FRSX'

# Dont grep .svn folders.
export GREP_OPTIONS="--exclude-dir=\.svn"

# Python
# ------
export PYTHONSTARTUP=~/.pythonrc
# Cache pip downloads, for faster installs
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

# Warn about using the global pip. This usually means we forgot to activate a
# virtualenv
function pip() {
	pip_path=`which pip`
	if [[ "$pip_path" == "/usr/bin/pip" ]] ; then
		echo "You are using the system-wide pip."
		read -r -p "Are you sure you want to do this? [y/N] " response
		case $response in
			[yY]) $pip_path $@ ;;
			*) ;;
		esac
	else
		$pip_path $@
	fi
}

# Program alias'
# --------------

# Human readable, coloured ls
alias ls='ls -hF --color=auto'

# Copy to the clipboard, for ctrl+v pasting
alias xclip='xclip -selection "clipboard"'

# Do nothing
alias noop='echo -n ""'

# Use like `command > output-from-command-`datestamp``
alias datestamp='date "+%Y-%m-%d-%H%m"'


# Set up bash nicely
# ------------------

if [ -f "/etc/bash_completion" ] ; then
	. "/etc/bash_completion"
fi

# Search backwards and forwards through history easier
if echo "$-" | grep -q 'i' ; then
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
fi

# Build up PS1
export VIRTUAL_ENV_DISABLE_PROMPT=true
export VCPROMPT_STAGED='+'
export VCPROMPT_MODIFIED='*'
export VCPROMPT_UNTRACKED='?'
alias vcprompt="$HOME/.bashrc.d/vcprompt"

# Set PS1. Levels are:
# * 0, low, minimal: Minimal PS1. Useful for slow systems, or systems with
#   basic shells
# * 1, medium, normal: Prompt showing coloured information, including
#   virtualenv status
# * 2, high, full: Prompt showing coloured information, including virtualenv
#   and version control status

# Generated with bashrc.d/build_ps1.py
function prompt-level() {
	level=$1
	case $level in
	0|low|minimal)
		export PS1='[ \u at \h in \W ] \$ '
		;;
	1|medium|normal)
		export PS1='\n[ \[\e[38;5;40m\]\u\[\e[0m\] at \[\e[38;5;13m\]\h\[\e[0m\]$( if [[ x"$VIRTUAL_ENV" != x ]] ; then dir=$( basename $( echo -n "$VIRTUAL_ENV" | sed -e"s/\/venv\/\?$//" ) ) ; echo " working on \[\e[38;5;51m\]$dir\[\e[0m\]" ; fi ) in \[\e[38;5;202m\]\w\[\e[0m\] ]\n\$ '
		;;
	2|high|full)
		export PS1='\n[ \[\e[38;5;40m\]\u\[\e[0m\] at \[\e[38;5;13m\]\h\[\e[0m\]$( vcprompt -f " on \[\e[38;5;130m\]%n\[\e[0m\]:\[\e[38;5;214m\]%b\[\e[0m\]\[\e[38;5;239m\] [\[\e[0m\]\[\e[31m\]%m\[\e[0m\]\[\e[38;5;33m\]%u\[\e[0m\]\[\e[38;5;239m\]]\[\e[0m\]" --format-git " on \[\e[38;5;130m\]%n\[\e[0m\]:\[\e[38;5;214m\]%b\[\e[0m\]\[\e[38;5;239m\] [\[\e[0m\]\[\e[32m\]%a\[\e[0m\]\[\e[31m\]%m\[\e[0m\]\[\e[38;5;33m\]%u\[\e[0m\]\[\e[38;5;239m\]]\[\e[0m\]")$( if [[ x"$VIRTUAL_ENV" != x ]] ; then dir=$( basename $( echo -n "$VIRTUAL_ENV" | sed -e"s/\/venv\/\?$//" ) ) ; echo " working on \[\e[38;5;51m\]$dir\[\e[0m\]" ; fi ) in \[\e[38;5;202m\]\w\[\e[0m\] ]\n\$ '
		;;
	esac
}

prompt-level 1
