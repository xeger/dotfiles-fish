# Run rubocop only on files that are edited vs. master
function cop
  pushd (git rev-parse --show-toplevel)
  if test -f apps/property/engines/im/.rubocop.yml
    echo "Use IM configuration"
    set config "--config=apps/property/engines/im/.rubocop.yml"
  end
  
  if test -n "$argv"
    set paths $argv
  else
    set paths (git diff --cached --name-status | grep '^[AM]' | cut -f 2)
    if test -z "$paths"
      echo "No staged changes; please specify file(s) to fix."
      return 1
    end
  end
  echo "+ bundle exec rubocop $config -a $paths"
  bundle exec rubocop $config -a $paths
  popd
end
