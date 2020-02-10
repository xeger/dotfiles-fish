# Force-push the working branch to its remote tracking branch at origin.
function bump
  set pushmode (git config push.default)
  if test $pushmode = simple
    git push --force-with-lease
    return 0
  else
    echo "bump: Cannot force-push; please `git config --global push-default simple`"
    return 1
  end
end
