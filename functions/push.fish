# Push the working branch to its remote tracking branch at origin. If
# there is no remote tracking branch, then push to an upstream branch of the
# same name and set upstream for future pushes.
function push
  set -l branch (git symbolic-ref HEAD 2>/dev/null | sed -e 's:refs/heads/::')

  set -l tracking_branch (git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)
  or set -e tracking_branch

  if test -n "$tracking_branch"
    git push
  else
    git push --set-upstream origin $branch
  end
end
