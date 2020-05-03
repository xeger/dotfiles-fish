# Run a script/task of a Ruby or Javascript project located in PWD.
function r
  if test -f Rakefile
    bundle exec rake $argv
  else if test -f package-lock.json
    npm run $argv
  else
    yarn $argv
  end
end
