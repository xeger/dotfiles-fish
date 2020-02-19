# Install Ruby/Javascript project dependencies in PWD.
function i
  if test -f Gemfile.lock
    bundle install $argv
  else if test -f yarn.lock
    yarn install $argv
  else if test -f package-lock.json
    npm install $argv
  else
    echo "i: no lockfile found; don't know which language/packager paplies"
    return 1  
  end
end
