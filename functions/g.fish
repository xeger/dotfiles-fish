# Supported syntax (& search priority):
#   g foobar --> chdir to foobar relative to pwd, if exists
#   g xyz    --> chdir to some rightscale- or xeger-owned dir named x*_y*_z*
#   g _site  --> chdir to some rightscale- or xeger-owned dir named *_site
function g
  set -l bases $HOME/Monolith $HOME/Code/appfolio $HOME/Code/xeger

  set -l suffix "_$argv[1]\$"
  set -l initials (echo "^$argv[1]" | sed -e 's/[A-Za-z]/&[^_]*_/g' | sed -e 's/_$//')

  # Check whether this is a shortcut for some source-code project.
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

  # Check whether this is the literal name of some directory
  if test -d $argv[1]
    cd $argv[1]
    return 0
  end

  # No matches! Display error message.
  echo "Could not find a directory matching '$argv[1]' under any of:"
  for base in $bases
    echo "  $base"
  end
  return 1
end
