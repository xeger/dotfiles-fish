function eks
  set cluster $argv[1]

  set region us-east-2
  test -n "$argv[2]"; and set region $argv[2]

  echo "aws eks --region $region update-kubeconfig --name $cluster"
  aws eks --region $region update-kubeconfig --name $cluster
end
