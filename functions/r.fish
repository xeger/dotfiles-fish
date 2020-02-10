# Run a script/task of a Ruby or Javascript project located in PWD.
function r
  if test -f Rakefile
    bundle exec rake $argv
  else if test -f yarn.lock
    yarn $argv
  else if test -f package-lock.json
    npm run $argv
  else
    echo "r: Don't know how to run scripts in $PWD"
    return 1
  end
end
