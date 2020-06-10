function eks
  argparse --name=eks 'n/namespace' 'r/region' -- $argv
  or return

  if test -z $argv[1]
    echo "usage: eks <cluster>"
    echo "  common clusters:"
    echo "    - im-prod-demo-cluster-1"
    echo "    - im-prod-cluster-1"
    return 1
  end

  set cluster "$argv[1]"

  if test -n "$_flag_n"
    set namespace $_flag_n
  end

  set -q region $_flag_r
  or set region "us-east-2"

  echo "+ aws eks --region $region update-kubeconfig --name $cluster"
  aws eks --region $region update-kubeconfig --name $cluster

  if test -n "$namespace"
    echo "+ kubectl config set-context (kubectl config current-context) --namespace=$namespace"
    kubectl config set-context (kubectl config current-context) --namespace=$namespace
  end
end
