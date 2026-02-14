if test -n "$SSH_AUTH_SOCK"
  set -l private_keys (grep -r --include=\* -El 'BEGIN [A-Z]* ?PRIVATE KEY' ~/.ssh/*)
  if test $status = 0; and test -n "$private_keys"
    ssh-add $private_keys 2> /dev/null
    if test $status != 0
      echo "Could not add private SSH keys to agent"
      echo "Please run this command by hand:"
      echo "ssh-add $private_keys"
    end
  end
end
