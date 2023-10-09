### Flags

GIT_REPO=""
IS_ALL=false
MESSAGE=""

while [ $# -gt 0 ]; do
  case $1 in
  --help)
    echo "Synchronize home directory files using a Git repo."
    echo "Changes should be made in \${HOME}, not \${GIT_REPO}. The script will perform the following steps:"
    echo "1. Copy the most recent versions of files from \${HOME} to \${GIT_REPO}."
    echo "2. Create a commit for the changes copied from \${HOME}."
    echo "3. Perform a rebase-pull from the remote, thus synchronizing your recent changes with any changes that were made and pushed to the Git repo from some other machine."
    echo "4. Perform a push, thus updating the remote with the local changes."
    echo "5. Copy the rebase-pull result from the \${GIT_REPO} to \${HOME}."
    echo "NOTE: A dirty \${GIT_REPO} will be simply overriden in step #1. This is why changes should be made in \${HOME} rather than in \${GIT_REPO}."
    echo "NOTE: You shouldn't run 'git fetch' in the repo on your own. Use this cript."
    echo
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " --help             Display this help message."
    echo " --git_repo <dir>   Path to the Git repo."
    echo " --all              Copy all files."
    echo " --message <msg>    Commit message. Defaults to 'DEFAULT'"
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

main() {

  echo ">>>>>>>>>> Copying files from the home directory to the Git directory."
  copy ~ "${GIT_REPO}"
  git -C "${GIT_REPO}" add .
  git -C "${GIT_REPO}" commit --message "${MESSAGE}"
  echo

  echo ">>>>>>>>>> Syncing the Git directory with the remote repo."
  git -C "${GIT_REPO}" pull --rebase
  git -C "${GIT_REPO}" push
  echo

  echo ">>>>>>>>>> Copying from the Git directory to the home directory."
  copy "${GIT_REPO}" ~
  echo
}

main
