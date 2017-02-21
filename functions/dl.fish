function dl
  set -l cnt (count $argv)
  set -l search $argv[$cnt]
  set --erase argv[$cnt]

  set -l candidates (docker ps --format '{{.Names}}' | grep $search)

  if test (count $candidates) -eq 1
    docker logs $argv $candidates[1]
  else if test  (count $candidates) -eq 0
    docker logs $argv $search
  else
    echo "Too many containers match '$search'; please be more specific to disambiguate between:"
    for cand in $candidates
      echo "  $cand"
    end
  end
end
