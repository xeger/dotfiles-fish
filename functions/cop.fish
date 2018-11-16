# Run rubocop only on files that are edited vs. master
function cop
  pushd (git rev-parse --show-toplevel)
  if test -f apps/property/engines/im/.rubocop.yml
    echo "Use IM configuration"
    set config "--config=apps/property/engines/im/.rubocop.yml"
  end
  set paths (git diff --cached --name-status | grep '^[AM]' | cut -f 2)
  if test -z "$paths"
    echo "No cached changes; scan entire IM engine"
    set paths "apps/property/engines/im"
  end
  bundle exec rubocop $config -a $paths
  popd
end
