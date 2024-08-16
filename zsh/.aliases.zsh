alias cat=bat --plain
alias bat=bat --plain
alias vi=nvim
alias vim=nvim
alias tv=tidy-viewer
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

# venv () {
#   # Uses wd to source Python virutal envs
#   locations=$(wd list)
#   # Searches both shortcut name and filepath, but only counts by line
#   match=$(echo $locations | rg $1)
#   match_count=$(echo $match | wc -l)
#   if [ $match_count=1 ]; then
#     path=$(echo $match | awk '{print $3}')
#     echo "Sourcing from "${path}"..."
#
#     # source ${path}/.venv/bin/activate
#     else
#       echo "Not found"
#   fi
# }
