if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
#eval "$(rbenv init -)"
#source ~/.bashrc
#eval "rbenv init -"
#eval "hub alias -s"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
