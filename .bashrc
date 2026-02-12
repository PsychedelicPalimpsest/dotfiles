#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\[\e[1;35m\]\u@\h\[\e[0m\] \[\e[0;31m\]\W\[\e[0m\]]\[\e[0;32m\]\$ \[\e[0m\]'
alias mpvg="mpv --player-operation-mode=pseudo-gui"
alias fmount="mount -o uid=1000,gid=1000"

source ~/.aliases
# export PATH=$PATH:~/idea/bin/:~/charm/bin
#
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/piavpn/bin/:$PATH"
export PATH="/usr/local/texlive/2025/bin/x86_64-linux/:$PATH"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source '/home/mitch/.bash_completions/ectf.sh'
