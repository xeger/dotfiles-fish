# Run a project-local Ruby/Javascript executable in the PWD.
function i
  if test -f Gemfile.lock
    bundle exec $argv
  else if test -f yarn.lock
    yarn $argv
  else if test -f package-lock.json
    npx $argv
  end
end
