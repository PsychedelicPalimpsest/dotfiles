#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\e[1;35m\u@\h\e[0m \e[0;31m\W\e[0m]\e[0;32m\$ \e[0m'


source ~/.aliases
# export PATH=$PATH:~/idea/bin/:~/charm/bin

