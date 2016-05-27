# Pull All the Things! Performs a `git fetch`, fast-forwards the working branch
# if applicable, and pulls the Docker image of the corresponding tag name,
# if any.
#
# Does not give any output from `git pull`; this would be nice to have...
#
# Usage:
#   `pull!` to fast-forward working branch and pull corresponding image
#   `pull! branchname` to fast-forward chosen branch and pull corresponding image

function pull!
  # Git repository parameters
  set -l working_branch (git symbolic-ref HEAD 2>/dev/null | sed -e 's:refs/heads/::')
  test -n "$argv[1]"; and set -l branch $argv[1]; or set -l branch $working_branch

  # Docker image parameters (derived from Git parameters)
  set -l org (basename (dirname $PWD))
  set -l repository (basename $PWD)
  set -l tag $branch

  # special case for master -> latest naming convention
  if test $tag = master
    set tag latest
  end
  set -l image "$org/$repository:$tag"

  echo "Pulling branch: origin/$branch"
  git pull --ff-only origin $branch &

  if test -f Dockerfile
  echo "Pulling image: $image"
    docker pull $image
  else
    echo "No Dockerfile; skip image pull"
  end

  jobs | grep -q 'git pull'; and fg %git
end
