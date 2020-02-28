# Setup port forwarding to an RDS cluster via kubectl.
function imqadb
  set -l namespace $argv[1]
  if test -z "$namespace"
    echo "imqadb: Please specify a namespace to connect to"
    return 1
  end

  imaws qa

  aws eks --region us-east-2 update-kubeconfig --name standalone-qa-2
  set -l password (aws rds generate-db-auth-token --hostname im-qa-rds-cluster-2.cluster-clnwi6wvmtsz.us-east-2.rds.amazonaws.com --port 3306 --region us-east-2 --username im_operators)
  kubectl --namespace=$namespace port-forward deployment/standalone-api-db-proxy 13306:3306 &
  set -x LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN 1
  echo "--- BEGIN OBNOXIOUSLY LONG MYSQL PASSWORD ---"
  echo $password
  echo "--- END OBNOXIOUSLY LONG MYSQL PASSWORD ---"
  echo
  sleep 3
  mysql --ssl-ca=~/Documents/rds-ca-2019-root.pem  --host=127.0.0.1 --port=13306 --enable-cleartext-plugin --user=im_operators --password="$password" property_$namespace
  kill (jobs -l | grep -E "kubectl.*port-forward.*deployment/standalone-api-db-proxy" | awk '{print $2}')
end
