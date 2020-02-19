# Run a project-local Ruby/Javascript executable in the PWD.
function x
  if test -f Gemfile.lock; or test -f *.gemspec
    bundle exec $argv
  else if test -f yarn.lock
    yarn $argv
  else if test -f package-lock.json
    npx $argv
  end
end
