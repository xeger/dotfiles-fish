# Print some information about a Docker image in the local registry and
# its correlation (if any) to the Git repository in $PWD.
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
  test -n $argv[1]; and set -l tag $argv[1]; or set -l tag latest

  set -l image "$org/$repository:$tag"
  set -l image_ref (docker inspect --format '{{.ID}}' $image)
  set -l git_ref (docker inspect --format '{{index .ContainerConfig.Labels "git.ref"}}' $image)

  echo "$image is at $image_ref and contains the following git branches:"
  git branch --contains $git_ref
end
