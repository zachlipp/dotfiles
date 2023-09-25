source ~/.zplug/init.zsh

# Go configuration
# GOPATH=$HOME/go
# GOBIN=$GOPATH/bin
export EDITOR=nvim
export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=$HOME/.gem/ruby/2.6.0/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH=$HOME/.pyenv:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=/Library/TeX/texbin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH
export PATH=$HOME/my_weird_scripts:$PATH

# Bundles
zplug "ael-code/zsh-colored-man-pages"
zplug "mfaerevaag/wd"
zplug "plugins/kubectl", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug load

alias vi=nvim
bindkey -e
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
source ~/.lscolors.zsh
export CLI_COLOR=1

# Configure zsh
ZSH_AUTOSUGGEST_MANUAL_REBIND=false

# Misc
source ~/.fzf.zsh
source <(kubectl completion zsh)

export VIMRUNTIME=~/.local/share/nvim/nvim/runtime

# Pyenv
source ~/.iterm2_shell_integration.zsh
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
# if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

export PATH="$HOME/.tfenv/bin:$PATH"

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

eval "$(starship init zsh)"
alias ls=exa
