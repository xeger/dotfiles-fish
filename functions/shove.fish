# Force-push the working branch to an arbitrary branch of origin.
function shove
  set -l branch (git symbolic-ref HEAD 2>/dev/null | sed -e 's:refs/heads/::')

  if test -n $branch
    echo git push --force origin $branch:$argv[1]
    return 0
  else
    echo "shove: Cannot determine working branch in $PWD"
    return 1
  end
end
