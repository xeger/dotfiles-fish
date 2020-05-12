# Install Ruby/Javascript project dependencies in PWD.
function i
  if test -f Gemfile.lock
    bundle install $argv
  else if test -f package-lock.json
    npm install $argv
  else if test -f package.json
    yarn install $argv
  end
end
