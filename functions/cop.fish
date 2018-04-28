function cop
  pushd (git rev-parse --show-toplevel)
  bx rubocop -a (git diff master --name-only)
  popd
end
