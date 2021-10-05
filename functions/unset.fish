# unset all environment variables matching a pattern
function unset
  set -l all (env | grep -E $argv[1] | cut -d= -f1)
  echo "unset: $all"
  for e in $all
    set -e $e
  end
end
