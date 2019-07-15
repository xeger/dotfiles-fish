# Perform `npm install` or `yarn install` depending on lockfile presence.
function ni
  if test -f yarn.lock
    yarn install $argv
  else
    npm install $argv
  end
end
