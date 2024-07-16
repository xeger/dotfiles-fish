# Force-push the working branch to its remote tracking branch at origin.
function bump
  set pushmode (git config push.default)
  if test $pushmode = simple

    set current_branch (git branch --show-current)
    set local_author (git show -s --format='%an' HEAD)
    git fetch -q origin $current_branch
    set remote_author (git show -s --format='%an' origin/$current_branch)
    if test $local_author != $remote_author
      echo "bump: Cannot force-push; local author is $local_author, remote author is $remote_author"
      return 1
    end
    git push --force-with-lease
    return 0
  else
    echo "bump: Cannot force-push; please `git config --global push.default simple`"
    return 1
  end
end
