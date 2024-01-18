function cktest
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
end
