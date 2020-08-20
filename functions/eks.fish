function eks
  argparse --name=eks 'n/namespace' 'r/region' -- $argv
  or return

  set cluster "$argv[1]"

  if test -n "$_flag_n"
    set namespace $_flag_n
  end

  set -q region $_flag_r
  or set region "us-east-2"

  if test -z $cluster
    echo "usage: eks <cluster>"
    echo "  available clusters:"
    aws eks list-clusters --region=$region | jq -r '.clusters | map("    - " + .) | .[]'
    return 1
  end

  echo "+ aws eks --region $region update-kubeconfig --name $cluster"
  aws eks --region $region update-kubeconfig --name $cluster

  if test -n "$namespace"
    echo "+ kubectl config set-context (kubectl config current-context) --namespace=$namespace"
    kubectl config set-context (kubectl config current-context) --namespace=$namespace
  end
end
