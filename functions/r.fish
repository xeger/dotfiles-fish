# Run a script/task of a Ruby or Javascript project located in PWD.
function r
  if test -f Makefile; and grep -q "$argv[1]:" Makefile
    make $argv
  else if test -f Rakefile
    bundle exec rake $argv
  else if test -f package.json
    set -l git_root (git rev-parse --show-toplevel 2> /dev/null)
    set -l pmgr (cat package.json | jq -r .packageManager)
    if test -z "$pmgr"; and test -f $git_root/package.json
      set pmgr (cat $git_root/package.json | jq -r .packageManager)
    end
    switch $pmgr
      case 'pnpm*'
        pnpm run $argv
      case 'yarn*'
        yarn $argv
      case '*'
        npm run $argv
    end
  else
    echo "r: Nothing seems to be runnable in this folder"
  end
end
