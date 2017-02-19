function dsh
  set -l search $argv[1]

  set -l candidates (docker ps --format '{{.Names}}' | grep $search)

  if test (count $candidates) -eq 1
    docker exec -t -i $candidates[1] /bin/sh -c '[ -f /bin/bash ] && exec /bin/bash -l || exec /bin/sh -l'
  else
    echo "Too many containers match '$search'; please be more specific to disambiguate between:"
    for cand in $candidates
      echo "  $cand"
    end
  end
end
