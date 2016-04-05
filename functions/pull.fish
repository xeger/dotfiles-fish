# Pull All the Things! Performs a `git fetch`, fast-forwards the working branch
# if applicable, and pulls the latest Docker image of the corresponding tag
# name, if any.
#
# Does not give any output from `docker pull`; this would be nice to have...
#
# Usage:
#   `pull` to fast-forward working branch and pull corresponding image
#   `pull branchname` to fast-forward chosen branch and pull corresponding image

function pull
  set -l working_branch (git symbolic-ref HEAD 2>/dev/null | sed -e 's:refs/heads/::')
  test -n "$argv[1]"; and set -l branch $argv[1]; or set -l branch $working_branch

  set -l org (basename (dirname $PWD))
  set -l repository (basename $PWD)
  set -l image "$org/$repository:$branch"

  if test -f Dockerfile
    docker pull $image &
    echo "Pulling image: $image"
  else
    echo "No Dockerfile; skip image pull"
  end

  echo "Pulling branch: origin/$branch"
  git pull --ff-only origin $branch &

  jobs | grep -q 'docker pull'; and fg %docker
  jobs | grep -q 'git pull'; and fg %git
end
