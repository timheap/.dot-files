# ~/.bashrc: executed by bash(1) for non-login shells.

PATH="$HOME/local/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/local/bin:/sbin:/bin"
LD_LIBRARY_PATH="/opt/local/lib:/usr/local/lib:/usr/lib"
for i in $HOME/local/*; do
	[ -d $i/bin ] && PATH="${i}/bin:${PATH}"
	[ -d $i/sbin ] && PATH="${i}/sbin:${PATH}"
	[ -d $i/include ] && CPATH="${i}/include:${CPATH}"
	[ -d $i/lib ] && LD_LIBRARY_PATH="${i}/lib:${LD_LIBRARY_PATH}"
	[ -d $i/lib/pkgconfig ] && PKG_CONFIG_PATH="${i}/lib/pkgconfig:${PKG_CONFIG_PATH}"
	[ -d $i/share/man ] && MANPATH="${i}/share/man:${MANPATH}"
done

if [ -d $HOME/.cabal/bin ] ; then
	PATH="${HOME}/.cabal/bin:${PATH}"
fi

export PATH
export CPATH
export LD_LIBRARY_PATH
export PKG_CONFIG_PATH
export MANPATH

export VISUAL='/usr/bin/vim'
export EDITOR='/usr/bin/vim'
export LESS='FRSX'
export GREP_OPTIONS="--exclude-dir=\.svn"
export ACK_OPTIONS="--pager=less --type-add php=.ctp --type-add js=.coffee"
export TZ='Australia/Hobart'
export NODE_PATH=$HOME/local/lib/node_modules:$HOME/local/node/lib/node_modules
export PYTHONSTARTUP=~/.pythonrc
umask 002

# Program alias'
alias vi='vim -p'
alias ls='ls -hF --color=auto'
alias xclip='xclip -selection "clipboard"'
alias noop='echo -n ""'

if [ -f "/etc/bash_completion" ] ; then
	. "/etc/bash_completion"
fi

if echo "$-" | grep -q 'i' ; then
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
fi

export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

function datestamp() {
	date "+%Y-%m-%d-%H%m"
}

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

# Build up PS1
export VIRTUAL_ENV_DISABLE_PROMPT=true
export VCPROMPT_STAGED='+'
export VCPROMPT_MODIFIED='*'
export VCPROMPT_UNTRACKED='?'
alias vcprompt="$HOME/.bashrc.d/vcprompt"

. $HOME/.bashrc.d/wine-paths.sh

# Generated with bashrc.d/build_ps1.py
export PS1='\n[ \[\e[38;5;40m\]\u\[\e[0m\] at \[\e[38;5;13m\]\h\[\e[0m\]$( vcprompt -f " on \[\e[38;5;130m\]%n\[\e[0m\]:\[\e[38;5;214m\]%b\[\e[0m\]\[\e[38;5;239m\] [\[\e[0m\]\[\e[31m\]%m\[\e[0m\]\[\e[38;5;33m\]%u\[\e[0m\]\[\e[38;5;239m\]]\[\e[0m\]" --format-git " on \[\e[38;5;130m\]%n\[\e[0m\]:\[\e[38;5;214m\]%b\[\e[0m\]\[\e[38;5;239m\] [\[\e[0m\]\[\e[32m\]%a\[\e[0m\]\[\e[31m\]%m\[\e[0m\]\[\e[38;5;33m\]%u\[\e[0m\]\[\e[38;5;239m\]]\[\e[0m\]")$( if [[ x"$VIRTUAL_ENV" != x ]] ; then dir=$( basename $( echo -n "$VIRTUAL_ENV" | sed -e"s/\/venv\/\?$//" ) ) ; echo " working on \[\e[38;5;51m\]$dir\[\e[0m\]" ; fi ) in \[\e[38;5;202m\]\w\[\e[0m\] ]\n\$ '
