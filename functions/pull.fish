# Pull All the Things! Performs a `git fetch`, fast-forwards the working branch
# if applicable, and pulls the latest Docker image of the corresponding tag
# name, if any.
#
# Does not give any output from `docker pull`; this would be nice to have...
function pull
  set -l org (basename (dirname $PWD))
  set -l repository (basename $PWD)
  test -n "$argv[1]"; and set -l tag $argv[1]; or set -l tag latest

  set -l image "$org/$repository:$tag"

  docker pull $image &
  git pull --ff-only
  jobs | grep -q 'docker pull'; and fg %1

  echo "Pulled all the things."
end
