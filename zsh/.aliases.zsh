alias cat='bat --plain'
alias bat='bat --plain'
alias vi=nvim
alias vim=nvim
alias tv=tidy-viewer
alias python=python3
alias ipython=ipython3
alias ls='ls --color=auto'


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

uvv() {
  if [ ! -d .venv ]; then
    uv venv
  else
    echo "A virtual environment already exists in this directory"
  fi
}

# https://stackoverflow.com/a/50830617/4738478
function start_venv_if_exists() {
  if [ -d .venv ] ; then
		source ./.venv/bin/activate
	fi
}

# Start on new session (i.e. new tab in iterm)
start_venv_if_exists

function cd() {
  builtin cd "$@"
  if [[ -z "$VIRTUAL_ENV" ]] ; then
    ## If env folder is found then activate the vitualenv
		start_venv_if_exists
  else
    ## check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
      fi
  fi
}
