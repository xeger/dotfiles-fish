# Setup port forwarding to an RDS cluster via kubectl.
function imqadb
  set -l eks_cluster standalone-qa-2
  set -l rds_cluster im-qa-rds-primary-cluster-1.cluster-clnwi6wvmtsz.us-east-2.rds.amazonaws.com
  set -l eks_proxy rds-primary-cluster-1-proxy
  imaws qa

  echo "Forwarding 127.0.0.0:13306 via $eks_cluster deployment/$eks_proxy (cross check against qa_db_connect.sh - it may have changed)"
  aws eks --region us-east-2 update-kubeconfig --name $eks_cluster
  set -l password (aws rds generate-db-auth-token --hostname $rds_cluster --port 3306 --region us-east-2 --username im_operators)
  kubectl --namespace=default port-forward deployment/$eks_proxy 13306:3306 &
  set -x LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN 1
  echo "--- BEGIN OBNOXIOUSLY LONG MYSQL PASSWORD ---"
  echo $password
  echo "--- END OBNOXIOUSLY LONG MYSQL PASSWORD ---"
  echo
  sleep 3
  echo "Connecting to $rds_cluster (cross check against qa_db_connect.sh - it may have changed)"
  mysql --ssl-ca=~/Documents/rds-ca-2019-root.pem  --host=127.0.0.1 --port=13306 --enable-cleartext-plugin --user=im_operators --password="$password"
  kill (jobs -l | grep -E "kubectl.*port-forward.*deployment/.eks_proxy" | awk '{print $2}')
end
