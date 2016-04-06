function dock
  switch $argv[1]
    case localhost
      set -xe DOCKER_HOST
    case '*'
      set -x DOCKER_HOST "tcp://$argv[1]:2376"
  end

  echo $DOCKER_HOST
  docker version | grep -A10 Server
end
