# Install Ruby/Javascript project dependencies in PWD.
function i
  if test -f Gemfile.lock
    bundle install $argv
  else if test -f package.json
    set -l pmgr (cat package.json | jq -r .packageManager)
    switch $pmgr
      case 'npm*'
        npm install
      case 'yarn*'
        yarn install
      case '*'
        echo "Dunno how to install; please add packageManager to package.json"
        return 1
    end
  end
end
