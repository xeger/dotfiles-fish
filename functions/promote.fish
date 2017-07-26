function promote
  set -l org rightscale
  set -l image $argv[1]
  set -l bfrom $argv[2]
  set -l bto $argv[3]

  docker pull $org/$image:$bfrom
  and docker tag $org/$image:$bfrom $org/$image:$bto
  and docker push $org/$image:$bto
end
