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
    echo "Prune local branches that no longer exist in remotes:"
    git remote prune origin
    for branchname in (git branch -l --format='%(refname:short)')
      if ! string match -r '^\\*' $branchname
        if test -z (git branch -lr origin/$branchname)
          git branch -D $branchname
        end
      end
    end
  end
end
