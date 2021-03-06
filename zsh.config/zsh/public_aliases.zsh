# Note to self: AVOID SUFFIX ALIASES, they're not that cool
# Unfortunateley there are people who haven't realized that putting suffixes
# on executables is a horrible idea.
# Therefore doing something like this
#
# alias -s sh=vim
#
# will make ./install.sh open vim, which is gross.
#

# Global
alias lsa="ls -AG"

KERNAL=`uname`

if [[ $KERNAL == "Darwin" ]]; then
    # OS X Aliases
    alias archey="archey --offline"

    # Because wiping your SSH key when you meant to copy it is too painful
    alias autocopy="pbcopy <"

    # View file permissions
    alias permissions="stat -f '%A %a %N'"

    # for homebrew and local executables
    export PATH=/usr/local/bin:$PATH:~/bin

    # Android: adb and fastboot binaries
    if [[ -a ~/Library/Android/sdk/platform-tools ]]; then
        export PATH=$PATH:~/Library/Android/sdk/platform-tools
    fi


elif [[ $KERNAL == "FreeBSD" ]]; then

    #archey alias for *BSD
    if hash bsdinfo 2>/dev/null; then
        alias archey="bsdinfo"
    fi

    # autocopy works like pbcopy in OS X/macOS
    _autoreleasepoolcopy() {
        cat $1 | xclip -selection clipboard
     }

    alias autocopy=_autoreleasepoolcopy

    # A sane path
    export PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/texbin

    # UTF-8 all the things!
    export MM_CHARSET=UTF-8
    export LANG=en_US.UTF-8

elif [[ $KERNAL == "Linux" ]]; then
	export PATH=$PATH:$HOME/bin

	# Manjaro options
	if hash lsb_release 2>/dev/null; then
		if [[ `lsb_release -si` == "ManjaroLinux" ]]; then
			alias archey="screenfetch -c '6 7 7 7'"
		fi
	fi
fi

# Ruby version manager
if hash rbenv 2>/dev/null; then

    export PATH=$HOME/.rbenv/bin:$PATH
	eval "$(rbenv init -)"

    if [[ $KERNAL == "FreeBSD" ]]; then
  # temporary work around for https://github.com/rbenv/rbenv/issues/881
        alias rbenv="RUBY_CONFIGURE_OPTS=--with-opt-dir=/usr/local CC=clang CXX=clang++ rbenv"
    fi
fi

#Elixir version manager
test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

# set vim as editor for everything ever
export VISUAL=vim
export EDITOR="$VISUAL"

# Add private aliases to private_aliases.zsh in your $ZSH directory
if [ -f $ZSH/private_aliases.zsh ]; then
    source $ZSH/private_aliases.zsh
fi

