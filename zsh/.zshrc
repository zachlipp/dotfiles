# Go configuration
# GOPATH=$HOME/go
# GOBIN=$GOPATH/bin

export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=$HOME/.gem/ruby/2.6.0/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH=$HOME/Library/Python/3.9/bin:$PATH
export PATH=$HOME/Library/Python/3.8/bin:$PATH
export PATH=$HOME/.pyenv:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=/Library/TeX/texbin:$PATH
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH

# antigen {
    source ~/antigen.zsh 

    # Load the oh-my-zsh library
    antigen use oh-my-zsh

    # Bundles
    antigen bundle colored-man-pages
    antigen bundle colorize
    antigen bundle docker
    antigen bundle git
    antigen bundle gradle
    antigen bundle pip
    antigen bundle python
    antigen bundle taskwarrior
    antigen bundle kubectl
    antigen bundle wd
    antigen bundle zsh-users/zsh-autosuggestions
    antigen bundle zsh-users/zsh-completions
    antigen bundle zsh-users/zsh-history-substring-search
    antigen bundle zsh-users/zsh-syntax-highlighting

    # Load the theme
    # https://github.com/zsh-users/antigen/issues/675#issuecomment-452764451
    THEME=denysdovhan/spaceship-prompt 
    antigen list | grep $THEME; if [ $? -ne 0 ]; then antigen theme $THEME; fi

    # Tell Antigen that you're done
    antigen apply
# }

# Configure theme
SPACESHIP_NODE_SHOW=false
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_KUBECTL_SHOW=true
SPACESHIP_KUBECTL_VERSION_SHOW=false
SPACESHIP_TIME_SHOW=true



# Aliases
source ~/.aliases.zsh

# Misc
source ~/.fzf.zsh
autoload -Uz compinit
compinit
source <(kubectl completion zsh)

# Pyenv
source ~/.iterm2_shell_integration.zsh
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
