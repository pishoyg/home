### Flags

GIT_REPO=""
IS_ALL=false
MESSAGE=""

while [ $# -gt 0 ]; do
  case $1 in
  --help)
    echo "Copy home directory files to a Git repo."
    echo "Changes should be made in the home directory. Use this script to synchronize the home directory with the remote repo."
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " --help             Display this help message."
    echo " --git_repo <dir>   Path to the Git repo."
    echo " --all              Copy all files."
    echo " --message <msg>    Commit message. This is ignored if --sync isn't given. Defaults to 'DEFAULT'"
    exit 0
    ;;
  --git_repo)
    GIT_REPO=$2
    shift
    ;;
  --all)
    IS_ALL=true
    ;;
  --message)
    MESSAGE=$2
    shift
    ;;
  *)
    echo "Unknown flag: ${1}"
    exit 1
    ;;
  esac
  shift
done

if [[ -z $GIT_REPO ]]; then
  echo "--git_repo is required."
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

# Copy files from the home directory to the Git directory.
copy ~ "${GIT_REPO}"

# Sync with the remote repo.
git -C "${GIT_REPO}" add .
git -C "${GIT_REPO}" commit --all --message "${MESSAGE}"
git -C "${GIT_REPO}" pull --rebase
git -C "${GIT_REPO}" push

# Copy from the Git directory to the home directory.
copy "${GIT_REPO}" ~
