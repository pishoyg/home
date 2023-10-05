### Flags

SRC=""
DEST=""
IS_ALL=false
MESSAGE=""
IS_SYNC=false

while [ $# -gt 0 ]; do
  case $1 in
  --help)
    echo "Copy home directory files, typically between your home directory and a Git repo."
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " --help             Display this help message."
    echo " --src <dir>        Specify source. Defaults to \$(pwd)."
    echo " --dest <dir>       Specify destination."
    echo " --all              Copy all files."
    echo " --message <msg>    Commit message. This is ignored if --sync isn't given. Defaults to 'DEFAULT'"
    echo " --sync             This is only valid if the destination is a Git repo. After copying, commit, pull, and push."
    exit 0
    ;;
  --src)
    SRC=$2
    shift
    ;;
  --dest)
    DEST=$2
    shift
    ;;
  --all)
    IS_ALL=true
    ;;
  --message)
    MESSAGE=$2
    shift
    ;;
  --sync)
    IS_SYNC=true
    ;;
  *)
    echo "Unknown flag: ${1}"
    exit 1
    ;;
  esac
  shift
done

if [[ -z $SRC ]]; then
  SRC="$(pwd)"
fi

if [[ -z $DEST ]]; then
  echo "--dest is required."
  exit 1
fi

if [[ -z $MESSAGE ]]; then
  MESSAGE="DEFAULT"
fi


### Main

copy() {
  local SRC="${1}"
  local DEST="${2}"
  cp -r \
    "${SRC}"/cp_dotfiles.sh \
    "${SRC}"/.gitconfig \
    "${SRC}"/.zshrc \
    "${DEST}"

  cp -r \
    "${SRC}"/.config/nvim/init.lua \
    "${DEST}/.config/nvim/"

  if ${IS_ALL}; then
    cp -r \
      "${SRC}"/.prompt \
      "${SRC}"/.alias \
      "${SRC}"/.profile \
      "${SRC}"/.git-prompt.sh \
      "${SRC}"/.bookstrap \
      "${SRC}"/.vimrc \
      "${SRC}"/.inputrc \
      "${SRC}"/.replyrc \
      "${DEST}"
  fi
}

copy "${SRC}" "${DEST}"

if ${IS_SYNC}; then
  git -C "${DEST}" add .
  git -C "${DEST}" commit --all --message "${MESSAGE}"
  git -C "${DEST}" pull --rebase
  if ${IS_PUSH}; then
    git -C "${DEST}" push
  fi
fi
