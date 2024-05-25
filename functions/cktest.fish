function cktest
  switch $argv[1]
    case 'env'
      echo "Populate environment with test credentials:"
      echo "  test @ ck - login all envs"
      set -x TEST_USERNAME (op read op://Shared/ln6etqriqm5ahcqdan62zvl52e/username)
      set -x TEST_PASSWORD (op read op://Shared/ln6etqriqm5ahcqdan62zvl52e/password)
      echo "  test+admin @ ck - login all envs"
      set -x TEST_ADMIN_USERNAME (op read op://Shared/7v2njpe4hfi5dxtkmrzm5qokju/username)
      set -x TEST_ADMIN_PASSWORD (op read op://Shared/7v2njpe4hfi5dxtkmrzm5qokju/password)
      echo "  test+operator @ ck - login all envs"
      set -x TEST_OPERATOR_USERNAME (op read op://Shared/fdtbpdq7sv3ardyg3r6iyzsui4/username)
      set -x TEST_OPERATOR_PASSWORD (op read op://Shared/fdtbpdq7sv3ardyg3r6iyzsui4/password)
      echo "  test+view @ ck - login all envs"
      set -x TEST_VIEW_USERNAME (op read op://Shared/nqpltj5fax4mygkvf7fvsz7r7e/username)
      set -x TEST_VIEW_PASSWORD (op read op://Shared/nqpltj5fax4mygkvf7fvsz7r7e/password)
    case 'port-forward'
      switch $argv[2]
        case 'agent'
          echo "Port forward to agent UX services"
          kubectl port-forward -n darkwing service/darkwing 18080:8080 &
          kubectl port-forward -n legacy service/atlasclient 10001:10001 &
          # kubectl port-forward -n agent-ux service/router 8080:8080 &
        case '*'
          echo "Usage: cktest port-forward <agent>"
          return 2
      end
      echo "Your port forwards are running in the background."
      echo "Manage them with the fish `jobs` command."
    case '*'
      echo "Usage: cktest <env|port-forward>"
      return 1
  end
end
