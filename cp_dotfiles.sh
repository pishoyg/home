### Flags

DEST=""
IS_COMMIT=false
IS_ALL=false
IS_PUSH=false
MESSAGE=""

while [ $# -gt 0 ]; do
  case $1 in
  --help)
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " --help         Display this help message."
    echo " --dest <dir>   Specify destination."
    echo " --all          Copy all files."
    echo " --commit       Add all and create a commit. Only works if the destination is a Git repo."
    echo " --push         Besides creating a commit, push. This is ignored if --commit isn't given."
    echo " --message      Commit message. This is ignored if --commit isn't given. Defaults to 'DEFAULT'"
    exit 0
    ;;
  --push)
    IS_PUSH=true
    ;;
  --commit)
    IS_COMMIT=true
    ;;
  --all)
    IS_ALL=true
    ;;
  --dest)
    DEST=$2
    shift
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

if [[ -z $DEST ]]; then
  echo "--dest is required."
  exit 1
fi

if [[ -z $MESSAGE ]]; then
  MESSAGE="DEFAULT"
fi

### Main
cp -r \
  cp_dotfiles.sh \
  .gitconfig \
  .zshrc \
  "${DEST}"

cp -r \
  .config/nvim/init.lua \
  "${DEST}/.config/nvim/"

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

if ${IS_COMMIT}; then
  git -C "${DEST}" add .
  git -C "${DEST}" commit --all --message "${MESSAGE}"
  if ${IS_PUSH}; then
    git -C "${DEST}" push
  fi
fi
