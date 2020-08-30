# Open a browser to CircleCI workflows on this branch
function cci
  set -l remote (git remote -v | grep push | sed 's|^.*github.com[:/]\(.*\)\.git.*$|\1|')
  set -l org (echo $remote | cut -d/ -f1)
  set -l repo (echo $remote | cut -d/ -f2)
  set -l branch (git symbolic-ref HEAD 2>/dev/null | sed -e 's:refs/heads/::')

  open "https://circleci.com/gh/$org/workflows/$repo/tree/$branch"
end
