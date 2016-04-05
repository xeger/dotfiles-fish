# Print some information about a Docker image in the LOCAL registry and
# its correlation (if any) to the Git repository in $PWD.
#
# Due to time and space constraints, this command doesn't work with remote
# branches or images. You should `pull` any branches or images that you
# especially care about.
#
# Requires $PWD to be a Git repository and its parent directory to be named
# after a DockerHub image namespace, i.e. the command assumes that code for
# `myorg` lives in a directory such as `~/Code/myorg/myproject`
#
# Relies on some RightScale-specific conventions, namely:
#   - every Docker image is named after its Git repository
#   - every image is labeled with "git.ref"
#
# Usage:
#    `sniff latest` to see local Git branch info
function sniff
  set -l org (basename (dirname $PWD))
  set -l repository (basename $PWD)
  test -n "$argv[1]"; and set -l tag $argv[1]; or set -l tag latest

  # TODO: get rid of hack sooner or later
  if test $tag =  master
    set tag latest
  end

  set -l image "$org/$repository:$tag"
  set -l image_ref (docker inspect --format '{{.ID}}' $image)
  or return 1
  set -l git_ref (docker inspect --format '{{index .ContainerConfig.Labels "git.ref"}}' $image)
  or return 2

  echo
  echo "$image was built from commit $git_ref"
  echo

  echo "The following local branches are 'at' $image:"
  grep -l ca293f24928fdf38b3aeec4e5234f72fb264318a .git/refs/heads/* | sed -e 's:.git/refs/heads/:  :'
  echo

  echo "The following local branches are 'ahead' of $image":
  git branch --contains $git_ref
  echo
end
