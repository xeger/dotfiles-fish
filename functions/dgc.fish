function dgc
  set -l ids (docker ps --filter="status=exited" --format="{{.ID}}")
  echo "Remove exited containers:"
  for id in $ids
    docker rm -v $id
  end
  echo "Prune unused volumes:"
  docker volume prune -f
end
