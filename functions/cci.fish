# Open a browser to CircleCI workflows on this branch
function cci
  set -l toplevel (git rev-parse --show-toplevel)
  set -l repo (basename $toplevel)
  set -l org (basename (dirname $toplevel))
  set -l branch (git symbolic-ref HEAD 2>/dev/null | sed -e 's:refs/heads/::')

  open "https://circleci.com/gh/$org/workflows/$repo/tree/$branch"
end
