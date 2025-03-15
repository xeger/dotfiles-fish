# Run a project-local Ruby/JavaScript executable in the PWD.
function x
  if test -f Gemfile; or test (count *.gemspec) -gt 0
    bundle exec $argv
  else if test -f package.json
    set -l ws_root '.'
    set -l git_root (git rev-parse --show-toplevel 2> /dev/null)
    if test -n "$git_root"
      set ws_root $git_root
    end
    set -l pmgr (cat $ws_root/package.json | jq -r .packageManager)
    switch $pmgr
      case 'npm*'
        npx $argv
      case 'pnpm*'
        pnpm exec $argv
      case 'yarn*'
        yarn exec $argv
      case '*'
        if test -f package-lock.json
          npx $argv
        else if test -f yarn.lock
          yarn $argv
        else
          if test -n "$pmgr"
            echo "x: Dunno how to exec for $pmgr; please add support"
          else
            echo "x: Dunno how to exec; please add packageManager to package.json"
          end
          return 1
        end
    end
  end
end
