# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

alias vim=nvim
alias docker='sudo docker'
alias docker-compose='sudo docker-compose'
alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm mmorgan/dockerfile-from-image"

if [[ $- =~ "i" ]];then 
    . ~/.bash_prompt
    . ~/.base16_theme
fi
