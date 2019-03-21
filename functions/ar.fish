function ar
  rm -f ~/.aws/im-credentials.fish
  assume-role $argv[1] $HOME/.config/fish/scripts/dump-im-aws-creds.fish $argv[1]
  if test -f ~/.aws/im-credentials.fish
    source ~/.aws/im-credentials.fish
    echo "Switched AWS account to $IM_AWS_ACCOUNT_NAME"
    return 0
  else
    return 1
  end
end
