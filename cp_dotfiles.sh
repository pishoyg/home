### Flags

GIT_REPO=""
IS_ALL=false
MESSAGE=""

while [ $# -gt 0 ]; do
  case $1 in
  --help)
    echo "Synchronize home directory files using a Git repo."
    echo "Updates to your home directory files should be made in \${HOME}, not \${GIT_REPO}. The script will perform the following steps:"
    echo "1. Copy the most recent versions of files from \${HOME} to \${GIT_REPO}."
    echo "2. Create a commit for the changes copied from \${HOME}."
    echo "3. Perform a rebase-pull from the remote, thus synchronizing your recent changes with any changes that were made and pushed to the Git repo from some other machine."
    echo "4. Perform a push, thus updating the remote with the local changes."
    echo "5. Copy the rebase-pull result from the \${GIT_REPO} to \${HOME}."
    echo "NOTE: A dirty \${GIT_REPO} will be simply overriden in step #1. This is why changes should be made in \${HOME} rather than in \${GIT_REPO}."
    echo "NOTE: You shouldn't run 'git fetch' in the repo on your own. Use this script."
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

  cp -r \
    "${SRC}"/.config/glab-cli/aliases.yml \
    "${SRC}"/.config/glab-cli/config.yml \
    "${DEST}/.config/glab-cli/"

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
      "${SRC}"/.docs-gitconfig.txt \
      "${DEST}"
    cp -r \
      "${SRC}/.pip/pip.conf" \
      "${DEST}/.pip/"
  fi
}

main() {

  echo $'\n'">>>>>>>>>> Copying files from ${HOME} to ${GIT_REPO}."
  copy ~ "${GIT_REPO}"

  echo $'\n'">>>>>>>>>> Committing in ${GIT_REPO}."
  git -C "${GIT_REPO}" add --all
  git -C "${GIT_REPO}" commit --message "${MESSAGE}"

  echo $'\n'">>>>>>>>>> Pulling to ${GIT_REPO} from the remote repo."
  git -C "${GIT_REPO}" pull --rebase

  echo $'\n'">>>>>>>>>> Pushing from ${GIT_REPO} to the remote repo."
  git -C "${GIT_REPO}" push

  echo $'\n'">>>>>>>>>> Copying from ${GIT_REPO} to ${HOME}."
  copy "${GIT_REPO}" ~
}

main
