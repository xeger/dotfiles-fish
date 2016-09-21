function watch
  set -l subject $argv[1]

  if test -f docker-compose.yml
    while true
      docker-compose logs -f $subject
      if test $status -ne 0
        break
      end
      echo "Recommence watching in 10 seconds..."
      sleep 10
    end
  else if test -d $subject
    echo "TODO: watching dirs is not implemented"
  else
    echo "watch: $subject is neither a directory nor a docker-compose service"
  end
end
