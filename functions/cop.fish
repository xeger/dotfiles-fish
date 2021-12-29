# Run rubocop only on specified paths or staged changes; fallback to run on everything.
function cop
  set -l paths
  if test -n "$argv"
    set paths $argv
  else
    set -l prefix (git rev-parse --show-prefix)
    set paths (git diff --cached --name-status --relative=$prefix | grep '^[AM].*[.]rb$' | cut -f 2)
  end
  echo "+ bundle exec rubocop -A $paths"
  bundle exec rubocop -A $paths
end
