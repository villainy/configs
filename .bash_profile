# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.fzf/bin

export PATH
[ -e $HOME/.fzf/shell/key-bindings.bash ] && . $HOME/.fzf/shell/key-bindings.bash
which screenfetch &>/dev/null && screenfetch
