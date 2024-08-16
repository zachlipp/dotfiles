source ~/.zplug/init.zsh

# Go configuration
# GOPATH=$HOME/go
# GOBIN=$GOPATH/bin
export EDITOR=nvim
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=$HOME/.gem/ruby/2.6.0/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH=$HOME/.pyenv:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=/Library/TeX/texbin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.modular:$PATH
export PATH="/Users/zlipp/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
export PATH=$HOME/git/emsdk:$PATH
export PATH=$HOME/git/emsdk/upstream/emscripten:$PATH

export MODULAR_HOME=$HOME/.modular

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
export CLI_COLOR=1

# Configure zsh
ZSH_AUTOSUGGEST_MANUAL_REBIND=false

# Misc
source ~/.fzf.zsh
source <(kubectl completion zsh)
source <(kubebuilder completion zsh)

export VIMRUNTIME=~/.local/share/nvim/nvim/runtime

# Pyenv
source ~/.iterm2_shell_integration.zsh
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
# if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

export PATH="$HOME/.tfenv/bin:$PATH"

eval "$(starship init zsh)"
alias ls=exa
eval "$(/opt/homebrew/bin/brew shellenv)"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
. "$HOME/.cargo/env"
export PATH="/opt/homebrew/opt/dart@2.19/bin:$PATH"

source ~/.aliases.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
