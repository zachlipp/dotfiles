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
export PATH=$HOME/.local/bin:$PATH
export PATH=/Library/TeX/texbin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.modular:$PATH
export PATH="/Users/zlipp/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
export PATH=$HOME/git/emsdk:$PATH
export PATH=$HOME/git/emsdk/upstream/emscripten:$PATH
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"
export PATH="$PATH:$HOME/.local/nvim-macos-arm64/bin"
export PATH="$PATH:/opt/X11/bin"

export MODULAR_HOME=$HOME/.modular
# No reason to gnu stow this
export STARSHIP_CONFIG=$HOME/dotfiles/starship/starship.toml

if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
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

# Pyenv
source ~/.iterm2_shell_integration.zsh

export PATH="$HOME/.tfenv/bin:$PATH"

eval "$(starship init zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
. "$HOME/.cargo/env"
export PATH="/opt/homebrew/opt/dart@2.19/bin:$PATH"

source ~/.aliases.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/zlipp/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH="/Users/zlipp/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/zlipp/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/zlipp/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/zlipp/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/zlipp/perl5"; export PERL_MM_OPT;
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/zlipp/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/zlipp/.lmstudio/bin"
# End of LM Studio CLI section

