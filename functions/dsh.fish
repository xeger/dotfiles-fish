function dsh
  set -l container $argv[1]

  if test -f $PWD/docker-compose.yml
    set -l project (basename $PWD | sed -e 's/[^a-z0-9]//g')
    set container {$project}_{$container}_1
  end

  docker exec -t -i $container /bin/bash
end
