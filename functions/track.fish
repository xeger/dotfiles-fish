function track
  set -l branch (git symbolic-ref HEAD 2>/dev/null | sed -e 's:refs/heads/::')
  git branch --set-upstream-to $argv[1]/$branch
end
