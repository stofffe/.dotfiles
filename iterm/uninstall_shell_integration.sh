#!/bin/bash

function die() {
  echo "${1}"
  exit 1
}

which printf > /dev/null 2>&1 || die "Shell integration requires the printf binary to be in your path."
which sed > /dev/null 2>&1 || die "Shell integration requires the sed binary to be in your path."

SHELL=$(echo "${SHELL}" | tr / "\n" | tail -1)
HOME_PREFIX='${HOME}'
SHELL_AND='&&'
QUOTE=''
if [ "${SHELL}" == tcsh ]
then
  SCRIPT="${HOME}/.login"
  QUOTE='"'
fi
if [ "${SHELL}" == zsh ]
then
  URL="https://iterm2.com/misc/zsh_startup.in"
  SCRIPT="${HOME}/.zshrc"
  QUOTE='"'
fi
if [ "${SHELL}" == bash ]
then
  test -f "${HOME}/.bash_profile" && SCRIPT="${HOME}/.bash_profile" || SCRIPT="${HOME}/.profile"
  QUOTE='"'
fi
if [ `basename "${SHELL}"` == fish ]
then
  echo "Make sure you have fish 2.2 or later. Your version is:"
  fish -v

  mkdir -p "${HOME}/.config/fish"
  SCRIPT="${HOME}/.config/fish/config.fish"
  HOME_PREFIX='{$HOME}'
  SHELL_AND='; and'
fi
if [ "${URL}" == "" ]
then
  die "Your shell, ${SHELL}, is not supported yet. Only tcsh, zsh, bash, and fish are supported. Sorry!"
  exit 1
fi

FILENAME="${HOME}/.iterm2_shell_integration.${SHELL}"
RELATIVE_FILENAME="${HOME_PREFIX}/.iterm2_shell_integration.${SHELL}"
echo "Removing script from ${FILENAME}..."
rm "${FILENAME}" > /dev/null 2>&1 || die "Couldn't remove script from home directory"
echo "Checking if ${SCRIPT} contains iterm2_shell_integration and removing it..."
sed -i -e '/iterm2_shell_integration/d' "${SCRIPT}" > /dev/null 2>&1
echo "Done."
echo ""
echo "The next time you log in, shell integration will be disabled."
