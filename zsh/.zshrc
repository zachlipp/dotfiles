case $OSTYPE 
  in "darwin"*)
     export PATH=$PATH:/usr/local/bin
   ;;
esac

# antigen {
    source ~/antigen.zsh 

    # Load the oh-my-zsh library
    antigen use oh-my-zsh

    # Bundles
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
    # https://github.com/zsh-users/antigen/issues/675#issuecomment-452764451
    THEME=denysdovhan/spaceship-prompt 
    antigen list | grep $THEME; if [ $? -ne 0 ]; then antigen theme $THEME; fi

    # Tell Antigen that you're done
    antigen apply
# }

# Aliases
source ~/.aliases.zsh

# Misc
source ~/.fzf.zsh
source <(kubectl completion zsh)
