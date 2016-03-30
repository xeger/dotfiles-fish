function g
  set -l bases $HOME/Code/rightscale $HOME/Code/xeger $HOME/Code/go/src/github.com/rightscale
  set -l regexp (echo "^$argv[1]" | sed -e 's/[A-Za-z]/&[^_]*_/g' | sed -e 's/_$//')

  for base in $bases
    set -l candidates (ls -d $base/*)
    for candidate in $candidates
      set -l bn (basename $candidate)
      if test $bn = $argv[1]
        cd $candidate
        return 0
      else if echo $bn | grep -qE $regexp
        cd $candidate
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
