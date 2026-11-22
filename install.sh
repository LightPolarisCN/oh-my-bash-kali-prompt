#!/usr/bin/env bash
# Install the Kali-style prompt for Oh My Bash.
#
# Usage:
#   ./install.sh              # install into ~/.oh-my-bash and ~/.bashrc
#   OMB_DIR=/path ./install.sh
#
# The script never uses sudo and never replaces ~/.bashrc; it only appends a
# marked block. Running it twice is safe.

set -euo pipefail

REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
OMB_DIR=${OMB_DIR:-$HOME/.oh-my-bash}
BASHRC=${BASHRC:-$HOME/.bashrc}
THEME_SRC="$REPO_DIR/themes/kali/kali.theme.sh"
THEME_DST_DIR="$OMB_DIR/custom/themes/kali"
MARK_BEGIN='# >>> oh-my-bash kali prompt >>>'
MARK_END='# <<< oh-my-bash kali prompt <<<'

info() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

[[ -f $THEME_SRC ]] || die "theme file not found: $THEME_SRC"
[[ ${BASH_VERSINFO[0]} -ge 4 ]] || warn "Oh My Bash works best with bash >= 4"

if [[ ! -d $OMB_DIR ]]; then
  info "Cloning Oh My Bash into $OMB_DIR"
  command -v git >/dev/null || die "git is required to clone Oh My Bash"
  git clone --depth 1 https://github.com/ohmybash/oh-my-bash.git "$OMB_DIR"
elif [[ ! -f $OMB_DIR/oh-my-bash.sh ]]; then
  die "$OMB_DIR exists but does not look like Oh My Bash"
else
  info "Using existing Oh My Bash at $OMB_DIR"
fi

info "Installing theme to $THEME_DST_DIR"
mkdir -p "$THEME_DST_DIR"
cp -- "$THEME_SRC" "$THEME_DST_DIR/kali.theme.sh"

if [[ ! -f $BASHRC ]]; then
  warn "$BASHRC does not exist, creating it"
  : >"$BASHRC"
fi

if grep -qF -- "$MARK_BEGIN" "$BASHRC"; then
  info "Prompt block already present in $BASHRC, theme refreshed"
else
  backup="$BASHRC.bak-$(date +%Y%m%d-%H%M%S-%N)"
  cp -- "$BASHRC" "$backup"
  info "Backed up $BASHRC to $backup"

  {
    printf '\n'
    cat -- "$REPO_DIR/bashrc.snippet"
  } >>"$BASHRC"
  info "Appended prompt block to $BASHRC"
fi

if ! bash -n "$BASHRC"; then
  die "$BASHRC has a syntax error, restore the backup above"
fi

info "Done. Open a new terminal, or run: source ~/.bashrc"
info "Uninstall with: $REPO_DIR/uninstall.sh"
