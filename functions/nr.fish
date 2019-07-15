# Perform `yarn <x>` or `npm run <x>` depending on lockfile 
function nr
  if test -f yarn.lock
    yarn $argv
  else
    npm run $argv
  end
end
