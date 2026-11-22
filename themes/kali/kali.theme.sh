#! bash oh-my-bash.module
# ---------------------------------------------------------------
# Kali-style two-line prompt for Oh My Bash
#
#   ┌──(user@host)-[~/projects]
#   └─$
#
# Everything is configurable from ~/.bashrc, for example:
#
#   KALI_PROMPT_BORDER_COLOR=40
#   KALI_PROMPT_ACCENT_COLOR=75
#   KALI_PROMPT_PATH_COLOR=231
#   KALI_PROMPT_MARK_COLOR=75
#   KALI_PROMPT_SEP_COLOR=45
#   KALI_PROMPT_HOST_SEP='@'
#   KALI_PROMPT_BOLD=1
#   KALI_PROMPT_ROOT_COLOR=196   # optional: paint the whole root prompt red
# ---------------------------------------------------------------

KALI_PROMPT_BORDER_COLOR=${KALI_PROMPT_BORDER_COLOR:-40}    # ┌── └─ frame
KALI_PROMPT_ACCENT_COLOR=${KALI_PROMPT_ACCENT_COLOR:-75}    # user, host
KALI_PROMPT_PATH_COLOR=${KALI_PROMPT_PATH_COLOR:-231}       # working directory
KALI_PROMPT_MARK_COLOR=${KALI_PROMPT_MARK_COLOR:-${KALI_PROMPT_ACCENT_COLOR}}  # $ / #
KALI_PROMPT_SEP_COLOR=${KALI_PROMPT_SEP_COLOR:-45}          # separator between user and host
KALI_PROMPT_ROOT_COLOR=${KALI_PROMPT_ROOT_COLOR-}           # empty = root keeps the normal scheme
KALI_PROMPT_HOST_SEP=${KALI_PROMPT_HOST_SEP:-@}             # use '㉿' for the Kali glyph
KALI_PROMPT_BOLD=${KALI_PROMPT_BOLD:-1}                     # 1 = bold, 0 = normal

function _omb_theme_PROMPT_COMMAND {
  local bold=
  [[ -n ${KALI_PROMPT_BOLD-} && ${KALI_PROMPT_BOLD} != 0 ]] && bold='1;'

  local border accent mark sep
  if ((EUID == 0)) && [[ -n ${KALI_PROMPT_ROOT_COLOR-} ]]; then
    border="\[\e[${bold}38;5;${KALI_PROMPT_ROOT_COLOR}m\]"
    accent=$border
    mark=$border
    sep=$border
  else
    border="\[\e[${bold}38;5;${KALI_PROMPT_BORDER_COLOR}m\]"
    accent="\[\e[${bold}38;5;${KALI_PROMPT_ACCENT_COLOR}m\]"
    mark="\[\e[${bold}38;5;${KALI_PROMPT_MARK_COLOR}m\]"
    sep="\[\e[${bold}38;5;${KALI_PROMPT_SEP_COLOR}m\]"
  fi
  local path_color="\[\e[${bold}38;5;${KALI_PROMPT_PATH_COLOR}m\]"
  local reset='\[\e[0m\]'

  # keep the "user@host: dir" window title
  PS1='\[\e]0;\u@\h: \w\a\]'
  PS1+='${debian_chroot:+($debian_chroot)}'
  PS1+=$border'┌──('$accent'\u'$sep"$KALI_PROMPT_HOST_SEP"$accent'\h'$border')-['$path_color'\w'$border']'
  PS1+='\n'
  PS1+=$border'└─'$mark'\$'$reset' '
}

_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND
