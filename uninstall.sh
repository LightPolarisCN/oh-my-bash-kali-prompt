#!/usr/bin/env bash
# Remove the Kali-style prompt block from ~/.bashrc.
#
# Usage:
#   ./uninstall.sh           # remove the bashrc block
#   ./uninstall.sh --purge   # also delete the theme file
#
# The most recent ~/.bashrc backup made by install.sh is left untouched.

set -euo pipefail

OMB_DIR=${OMB_DIR:-$HOME/.oh-my-bash}
BASHRC=${BASHRC:-$HOME/.bashrc}
MARK_BEGIN='# >>> oh-my-bash kali prompt >>>'
MARK_END='# <<< oh-my-bash kali prompt <<<'

info() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

[[ -f $BASHRC ]] || { warn "$BASHRC not found, nothing to do"; exit 0; }

if grep -qF -- "$MARK_BEGIN" "$BASHRC"; then
  backup="$BASHRC.bak-$(date +%Y%m%d-%H%M%S-%N)"
  cp -- "$BASHRC" "$backup"
  info "Backed up $BASHRC to $backup"

  tmp=$(mktemp)
  awk -v b="$MARK_BEGIN" -v e="$MARK_END" '
    $0 == b { skip = 1 }
    !skip   { print }
    $0 == e { skip = 0 }
  ' "$BASHRC" >"$tmp"
  mv -- "$tmp" "$BASHRC"
  info "Removed prompt block from $BASHRC"
else
  info "No prompt block found in $BASHRC"
fi

if [[ ${1-} == --purge ]]; then
  rm -rf -- "$OMB_DIR/custom/themes/kali"
  info "Removed $OMB_DIR/custom/themes/kali"
fi

info "Done. Open a new terminal to get your previous prompt back."
