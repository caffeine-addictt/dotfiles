if [ -f "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Set aliases
alias cmds='~/Documents/projects/command-help/cmds.sh'
