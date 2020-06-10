# Delete all local branches that are fully merged into master.
function prune
  argparse --name=prune 'r/remote' -- $argv
  or return

  if test -n "$_flag_r"
    echo "Prune remote branches (WARNING: only understands true merge):"
    git remote prune origin
    git branch -r --merged=origin/master | grep -vE  'master|\*' | xargs -L 1 echo
    read -P "Remove ALL of the above branches (please respond 'yes')? " confirmation
    if test "$confirmation" = "yes"
      git branch -r --merged=origin/master | grep -vE  'master|\*' | sed -e 's/^ *origin\//:/' | xargs git push origin
    end
  else
    git remote prune origin
    echo "Pruning local repository"
    for branchname in (git branch -l --format='%(refname:short)')
      if ! string match -r '^\\*' $branchname
        if test -z (git branch -lr origin/$branchname)
          echo -n ' * '
          git branch -D $branchname
        end
      end
    end
  end
end
