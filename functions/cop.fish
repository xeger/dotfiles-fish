# Run rubocop only on files that are edited vs. master
function cop
  if test -n "$argv"
    set paths $argv
  else
    set -l prefix (git rev-parse --show-prefix)
    set -l paths (git diff --cached --name-status --relative=$prefix | grep '^[AM].*[.]rb$' | cut -f 2)
    if test -z "$paths"
      echo "No staged changes; please specify file(s) to fix."
      return 1
    end
  end
  echo "+ bundle exec rubocop -a $paths"
  bundle exec rubocop -a $paths
end
