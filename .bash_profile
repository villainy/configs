# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/.pyenv/bin:$HOME/bin:$HOME/.fzf/bin:$HOME/.go/bin
BASE16_SHELL_SET_BACKGROUND=false
#FZF_TMUX=1

export PATH BASE16_SHELL_SET_BACKGROUND FZF_TMUX

[ -e $HOME/.fzf/shell/key-bindings.bash ] && . $HOME/.fzf/shell/key-bindings.bash
which screenfetch &>/dev/null && screenfetch
[ -x /usr/bin/nvim ] && export EDITOR=/usr/bin/nvim

[ $(which rg 2>/dev/null)"x" != "x" ] && export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

shopt -s autocd cdspell checkjobs checkwinsize direxpand dirspell globstar histappend histreedit histverify no_empty_cmd_completion
