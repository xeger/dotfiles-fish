# Install Ruby/Javascript project dependencies in PWD.
function i
  if test -f Gemfile
    bundle check || bundle install
  end

  if test -f package.json
    set -l pmgr (cat package.json | jq -r .packageManager)
    switch $pmgr
      case 'npm*'
        npm install
      case 'pnpm*'
        pnpm install
      case 'yarn*'
        yarn install
      case '*'
        if test -f package-lock.json
          npm install
        else if test -f yarn.lock
          yarn install
        else
          if test -n "$pmgr"
            echo "i: Dunno how to install for $pmgr; please add support"
          else
            echo "i: Dunno how to install; please add packageManager to package.json"
          end
          return 1
        end
    end
  end
end

