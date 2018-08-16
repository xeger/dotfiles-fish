# Run rubocop only on files that are edited vs. master
function cop
  pushd (git rev-parse --show-toplevel)
  bx rubocop -a (git diff master --name-only)
  popd
end
