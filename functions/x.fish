# Run a project-local Ruby/JavaScript executable in the PWD.
function x
  if test -f Gemfile; or test (count *.gemspec) -gt 0
    bundle exec $argv
  else if test -f package.json
    set -l pmgr (cat package.json | jq -r .packageManager)
    switch $pmgr
      case 'npm*'
        npx $argv
      case 'yarn*'
        yarn exec $argv
      case '*'
        if test -f package-lock.json
          npx $argv
        else if test -f yarn.lock
          yarn $argv
        else
          echo "i: Dunno how to run; please add packageManager to package.json"
          return 1
        end
    end
  end
end
