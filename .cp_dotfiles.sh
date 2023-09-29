### Flags

DEST=""
IS_GIT=false
IS_ALL=false

while [ $# -gt 0 ]; do
  case $1 in
  --help)
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " --help         Display this help message."
    echo " --dest <dir>   Specify destination."
    echo " --git          The destination is a Git directory."
    echo " --all          Copy all files."
    exit 0
    ;;
  --git)
    IS_GIT=true
    ;;
  --all)
    IS_ALL=true
    ;;
  --dest)
    DEST=$2
    shift
    ;;
  *)
    echo "Unknown flag: ${1}"
    exit 1
    ;;
  esac
  shift
done

if [[ -z $DEST ]]; then
  echo "--dest is required."
  exit 1
fi

### Main
cp -r \
  .cp_dotfiles.sh \
  .gitconfig \
  .zshrc \
  "${DEST}"

cp -r \
  .config/nvim \
  "${DEST}/.config/"

if ${IS_ALL}; then
  cp -r \
    .prompt \
    .alias \
    .profile \
    .git-prompt.sh \
    .bookstrap \
    .vimrc \
    .inputrc \
    .replyrc \
    "${DEST}"
fi

if ${IS_GIT}; then
  git -C "${DEST}" add .
  git -C "${DEST}" commit --all --message "DEFAULT"
fi
