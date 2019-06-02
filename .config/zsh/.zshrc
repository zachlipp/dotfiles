# antigen {
    source ~/antigen.zsh 

    # Load the oh-my-zsh library
    antigen use oh-my-zsh

    # Bundles
    antigen bundle autojump
    antigen bundle colored-man-pages
    antigen bundle colorize
    antigen bundle docker
    antigen bundle git
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
    antigen theme denysdovhan/spaceship-prompt 

    # Tell Antigen that you're done
    antigen apply
# }

# Aliases
source .aliases.zsh

# Misc
fpath=(~/.config/zsh/completions $fpath)
source ~/.fzf.zsh
source <(kubectl completion zsh)
