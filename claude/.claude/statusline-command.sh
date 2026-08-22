#!/usr/bin/env bash
# Claude Code statusline.
#
# Renders: <starship prompt for the session's cwd>  <progress bar>  <context used>/<context total>
#
# The context segment reflects tokens *currently occupying the context
# window* (not cumulative session tokens). Both "used" and "total" are
# derived from the JSON payload Claude Code pipes in on stdin rather than
# being hardcoded.

# ---------------------------------------------------------------------------
# Token count (of the *current* context window) at/above which you expect
# noticeable model degradation. Override by exporting CONTEXT_WARN_THRESHOLD
# in your shell profile before starting Claude Code.
# ---------------------------------------------------------------------------
CONTEXT_WARN_THRESHOLD="${CONTEXT_WARN_THRESHOLD:-150000}"

# Width of the progress bar, in characters.
CONTEXT_BAR_WIDTH="${CONTEXT_BAR_WIDTH:-20}"

# The statusline may run with a trimmed PATH; make sure the usual Homebrew /
# local prefixes are visible so starship and jq are found.
PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
export PATH

# ---------------------------------------------------------------------------
# Read stdin once and stash a copy for later inspection. The exact field names
# in this payload have changed across Claude Code versions, so keeping the last
# raw payload around makes it easy to re-verify them. Safe to delete this line
# once the field names below are confirmed against a live run.
# ---------------------------------------------------------------------------
input="$(cat)"
printf '%s' "$input" > "$HOME/.claude/statusline-last-payload.json" 2>/dev/null

have_jq=0
command -v jq >/dev/null 2>&1 && have_jq=1
have_py=0
command -v python3 >/dev/null 2>&1 && have_py=1

# json_get <dotted.path> -> prints the value, or nothing if absent/null.
json_get() {
  local path="$1"
  if [ "$have_jq" = "1" ]; then
    printf '%s' "$input" | jq -r ".${path} // empty" 2>/dev/null
  elif [ "$have_py" = "1" ]; then
    printf '%s' "$input" | python3 -c '
import json, sys
path = sys.argv[1]
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
cur = data
for part in path.split("."):
    if isinstance(cur, dict):
        cur = cur.get(part)
    else:
        cur = None
        break
if cur is not None:
    print(cur)
' "$path"
  fi
}

cwd="$(json_get 'workspace.current_dir')"
[ -z "$cwd" ] && cwd="$(json_get 'cwd')"
[ -z "$cwd" ] && cwd="$PWD"

transcript_path="$(json_get 'transcript_path')"

# --- Starship segment --------------------------------------------------------
export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/dotfiles/starship/starship.toml}"

prompt_segment=""
if command -v starship >/dev/null 2>&1; then
  # STARSHIP_SHELL=unknown yields raw ANSI with no shell-specific escaping.
  # Under zsh starship wraps colors in %{...%} and under bash in \[...\];
  # either would render as visible garbage in the statusline. (fish is clean
  # too but prepends an erase-to-end-of-screen sequence.)
  raw_prompt="$(STARSHIP_SHELL=unknown starship prompt --path "$cwd" 2>/dev/null)"

  # This config ends in $line_break\$character, and starship's add_newline
  # default prepends a blank line. Drop blank lines, then drop the final line
  # (the bare "❯") since a statusline isn't a prompt. Remaining lines are
  # joined with a space.
  prompt_segment="$(printf '%s\n' "$raw_prompt" | awk '
    NF { lines[++n] = $0 }
    END {
      if (n > 1) n--
      for (i = 1; i <= n; i++) printf "%s%s", lines[i], (i < n ? " " : "")
    }')"
fi

if [ -z "$prompt_segment" ]; then
  # Fallback when starship isn't on PATH: plain dir + git branch, dimmed.
  short_dir="$(basename "$cwd" 2>/dev/null)"
  branch=""
  if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch="$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)"
  fi
  if [ -n "$branch" ]; then
    prompt_segment="$(printf '\033[2m%s\033[0m \033[2m(%s)\033[0m' "$short_dir" "$branch")"
  else
    prompt_segment="$(printf '\033[2m%s\033[0m' "$short_dir")"
  fi
fi

# --- Context window segment ---------------------------------------------------
used_pct="$(json_get 'context_window.used_percentage')"
ctx_size="$(json_get 'context_window.context_window_size')"
total_input="$(json_get 'context_window.total_input_tokens')"
total_output="$(json_get 'context_window.total_output_tokens')"

used_tokens=""
if [ -n "$used_pct" ] && [ -n "$ctx_size" ]; then
  # Preferred: percentage of the window that is currently occupied. This is
  # unambiguously "what's in the context right now".
  used_tokens="$(awk -v p="$used_pct" -v c="$ctx_size" 'BEGIN{printf "%d", (p/100.0)*c}')"
elif [ -n "$total_input" ] || [ -n "$total_output" ]; then
  used_tokens=$(( ${total_input:-0} + ${total_output:-0} ))
fi

if [ -z "$ctx_size" ] && [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  # Payload didn't carry a total; best-effort scrape the transcript for an
  # explicit context-window-size field before falling back to a constant.
  ctx_size="$(grep -oE '"context_window_size"[[:space:]]*:[[:space:]]*[0-9]+' "$transcript_path" 2>/dev/null \
    | tail -1 | grep -oE '[0-9]+$')"
fi

if [ -z "$ctx_size" ]; then
  # Last-resort default, only used if neither the statusline payload nor the
  # transcript exposes the model's real context window size. Generic safety
  # net, not an assumption about any specific model's window.
  ctx_size=200000
fi

# 142384 -> "142k"; 1000000 -> "1.0M"
fmt_tokens() {
  awk -v n="$1" 'BEGIN{
    if (n >= 1000000) printf "%.1fM", n/1000000.0;
    else printf "%dk", (n+500)/1000;
  }'
}

# The bar is scaled to 2x the warn threshold, not the full window: past that
# point the exact number stops mattering and the bar just reads full.
# Emits a colored bar with a dotted tick marking the warn threshold. Because
# the scale is 2x the threshold, that tick always lands at the midpoint.
make_bar() {
  awk -v used="$1" -v scale="$2" -v w="$3" -v color="$4" 'BEGIN{
    esc = sprintf("%c", 27);
    body = esc "[" color "m";
    reset = esc "[0m";
    tick = reset esc "[2m┊" body;
    split("▏ ▎ ▍ ▌ ▋ ▊ ▉", eighth, " ");
    frac = used / scale;
    if (frac > 1) frac = 1;
    if (frac < 0) frac = 0;
    cells = frac * w;
    full = int(cells);
    part = int((cells - full) * 8);
    mark = int(w / 2 + 0.5);
    printf "%s", body;
    for (i = 0; i < w; i++) {
      if (i == mark) printf "%s", tick;
      if (i < full) printf "█";
      else if (i == full && part > 0) printf "%s", eighth[part];
      else printf "░";
    }
    printf "%s", reset;
  }'
}

bar_segment=""
context_segment=""
if [ -n "$used_tokens" ]; then
  used_fmt="$(fmt_tokens "$used_tokens")"
  total_fmt="$(fmt_tokens "$ctx_size")"
  if [ "$used_tokens" -ge "$CONTEXT_WARN_THRESHOLD" ]; then
    bar_color="1;31"
    context_segment="$(printf '\033[1;31m%s/%s\033[0m' "$used_fmt" "$total_fmt")"
  else
    bar_color="32"
    context_segment="$(printf '\033[2m%s/%s\033[0m' "$used_fmt" "$total_fmt")"
  fi
  bar_segment="$(make_bar "$used_tokens" "$(( CONTEXT_WARN_THRESHOLD * 2 ))" "$CONTEXT_BAR_WIDTH" "$bar_color")"
fi

# --- Output --------------------------------------------------------------------
out="$prompt_segment"
[ -n "$bar_segment" ] && out="$out  $bar_segment"
[ -n "$context_segment" ] && out="$out  $context_segment"
printf '%s\n' "$out"
