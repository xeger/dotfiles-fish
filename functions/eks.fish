function eks
  set cluster $argv[1]

  set namespace xeger
  test -n "$argv[2]"; and set region $argv[2]

  set region us-east-2
  test -n "$argv[3]"; and set region $argv[3]

  echo "Configuring kubectl for cluster '$cluster' and namespace '$namespace'"
  aws eks --region $region update-kubeconfig --name $cluster
  kubectl config set-context (kubectl config current-context) --namespace=$namespace
end
