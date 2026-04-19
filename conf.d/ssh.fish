if test -n "$SSH_AUTH_SOCK"
  set -l key_candidates (find ~/.ssh -maxdepth 1 -type f -name 'id_*' 2>/dev/null)
  set -l private_keys
  if test -n "$key_candidates"
    set private_keys (grep -lE 'BEGIN [A-Z]* ?PRIVATE KEY' $key_candidates 2>/dev/null)
  end
  if test -n "$private_keys"
    ssh-add $private_keys 2> /dev/null
    if test $status != 0
      echo "Could not add private SSH keys to agent"
      echo "Please run this command by hand:"
      echo "ssh-add $private_keys"
    end
  end
end
