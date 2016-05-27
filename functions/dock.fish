function dock
  switch $argv[1]
    case localhost
      set -ex DOCKER_HOST
    case '*'
      set -gx DOCKER_HOST "tcp://$argv[1]:2376"
  end

  echo "DOCKER_HOST is $DOCKER_HOST"
  docker version | grep -A10 Server
end
