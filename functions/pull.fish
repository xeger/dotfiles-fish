# Pull from remote. Performs a `git fetch` and fast-forwards the local branch
# named in $argv[1] (or the working branch, if no argument is passed).
#
# Usage:
#   `pull` to fast-forward working branch
#   `pull branchname` to fast-forward chosen branch

function pull
  set -l working_branch (git symbolic-ref HEAD 2>/dev/null | sed -e 's:refs/heads/::')
  test -n "$argv[1]"; and set -l branch $argv[1]; or set -l branch $working_branch

  git pull --ff-only origin $branch
end
