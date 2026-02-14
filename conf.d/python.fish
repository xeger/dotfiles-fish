set -l pybin $HOME/Library/Python/3.*/bin
if test -n "$pybin"
  set -x PATH $PATH $pybin
end
set -e pybin
