# Delete all local branches that are fully merged into master.
function prune
  git branch -l --merged=origin/master | grep -vE  'master|\*' | xargs git branch -D
end
