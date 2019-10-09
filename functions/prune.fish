# Delete all local branches that are fully merged into master.
function prune
  argparse --name=prune 'r/remote' -- $argv
  or return

  if test -n "$_flag_r"
    echo "Prune remote branches:"
    git remote prune origin > /dev/null
    git branch -r --merged=origin/master | grep -vE  'master|\*' | xargs -L 1 echo
    read -P "Remove ALL of the above branches (please respond 'yes')? " confirmation
    if test "$confirmation" = "yes"
      git branch -r --merged=origin/master | grep -vE  'master|\*' | sed -e 's/^ *origin\//:/' | xargs git push origin
    end
  else
    echo "Prune local branches:"
    git branch -l --merged=origin/master | grep -vE  'master|\*' | xargs git branch -D
  end  
end
