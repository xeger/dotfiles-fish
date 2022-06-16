# Run a script/task of a Ruby or Javascript project located in PWD.
function r
  if test -f Makefile
    make $argv
  else if test -f Rakefile
    bundle exec rake $argv
  else if test -f package.json
    set -l pmgr (cat package.json | jq -r .packageManager)
    switch $pmgr
      case 'yarn*'
        yarn $argv
      case '*'
        npm run $argv
    end
  else
    echo "r: Nothing seems to be runnable in this folder"
  end
end
