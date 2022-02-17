alias cat=bat --plain
alias bat=bat --plain
alias vi=nvim
alias vim=nvim
alias python=python3
alias ipython=ipython3

rmc() {
  docker ps -aq | xargs docker rm
}

rpcp() {
  realpath "$1" | pbcopy
}

containers() {
  docker ps --format='{{.Names}}'
}

dtoken() {
  docker logs "$1" 2>&1 | grep \?token | cut -d = -f 2 | head -n 1 | pbcopy
}

pods() {
  kubectl get pods --no-headers -o custom-columns=:metadata.name
}

ktoken() {
 kubectl logs "$1" | grep -m 1 token | sed 's/.*\?token=//g' | head | pbcopy
}

clean_history () {
  mv .zsh_history .zsh_history_bad && \
      strings .zsh_history_bad > .zsh_history && \
      fc -R .zsh_history
}

ignore_py() {
  curl https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore > .gitignore
}
