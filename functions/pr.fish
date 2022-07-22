# Open a browser to GitHub in order to compare this branch and/or open a
# pull request to another branch.
function pr
  set -l remote (git remote -v | grep push | head -1 | sed 's|^.*github.com[:/]\(.*\)\.git.*$|\1|')
  set -l source (git symbolic-ref HEAD 2>/dev/null | sed -e 's:refs/heads/::')
  set -l dest $argv[1]

  if test -n "$dest"
    if [ $dest = master ]; and git show-ref -q --heads main
      echo "Using main (not $dest) as default branch -- you insensitive prick!"
      set -l dest main
    end
    open "https://github.com/$remote/pull/new/$dest...$source"
  else
    open "https://github.com/$remote/compare/$source"
  end
end
