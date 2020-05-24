function shields
  if test -f /etc/hosts.blocked
    echo "Shields up!"
    sudo mv /etc/hosts /etc/hosts.unblocked
    sudo mv /etc/hosts.blocked /etc/hosts
  else
    echo "Shields down!"
    sufo mv /etc/hosts /etc/hosts.blocked
    sudo mv /etc/hosts.unblocked /etc/hosts
  end
end
