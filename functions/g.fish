function g
  set -l bases $HOME/Code/rightscale $HOME/Code/xeger $HOME/Code/go/src/github.com/rightscale

  set -l suffix "_$argv[1]\$"
  set -l initials (echo "^$argv[1]" | sed -e 's/[A-Za-z]/&[^_]*_/g' | sed -e 's/_$//')

  for base in $bases
    set -l dirs (ls -d $base/*)
    for dir in $dirs
      set -l bn (basename $dir)
      if test $bn = $argv[1] # exact match
        cd $dir
        return 0
      else if echo $bn | grep -qE $initials # initials match
        cd $dir
        return 0
      else if echo $bn | grep -qE $suffix # suffix word match
      cd $dir
      return 0
      end
    end
  end

  echo "Could not find a directory matching '$argv[1]' under any of:"
  for base in $bases
    echo "  $base"
  end
  return 1
end
