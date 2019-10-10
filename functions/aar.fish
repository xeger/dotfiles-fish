# AWS assume-role with fish sauce and an IM garnish.
function aar
  set -l role_arn (grep -A3 "\[profile $argv[1]\]" ~/.aws/config | grep role_arn | awk 'BEGIN { FS = " = " } ; { print $2 }')
  if test -z $role_arn
    echo "No profile '$argv[1]' in ~/.aws/config"
    return 1
  end
  set -gx AWS_PROFILE $argv[1]
  
  # role_arn e.g. => arn:aws:iam::410444354559:role/SuperUser
  # needed   e.g. => 410444354559:assumed-role/SuperUser
  set -l search_str (echo $role_arn |  awk 'BEGIN { FS = ":" } ; { print $5 ":assumed-" $6 }')
  set -l json_file (grep -lr "$search_str" ~/.aws/cli/cache | head -1)  

  if test -n "$json_file"
    set -gx AWS_SESSION_EXPIRATION (jq -r .Credentials.Expiration  $json_file)
    if ruby -rtime -e 'exit Time.parse(ENV["AWS_SESSION_EXPIRATION"]) > Time.now'
      set -gx AWS_ACCESS_KEY (jq -r .Credentials.AccessKeyId  $json_file)
      set -gx AWS_SECRET_ACCESS_KEY (jq -r .Credentials.SecretAccessKey  $json_file)
      set -gx AWS_SESSION_TOKEN (jq -r .Credentials.SessionToken  $json_file)

      set -gx IM_AWS_ACCESS_KEY $AWS_ACCESS_KEY
      set -gx IM_AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
      set -gx IM_AWS_SESSION_TOKEN $AWS_SESSION_TOKEN

      echo "aar: Using cached credentials for $AWS_PROFILE ($role_arn)"
      return 0
    end
  end

  echo "aar: Initializing CLI session for $AWS_PROFILE ($role_arn)"
  aws iam get-account-summary --query 'SummaryMap.Users'
  set -l iamstatus $status
  if test "$iamstatus" -ne 0
    echo "aar: Failed to obtain credentials ($iamstatus); please try again"
    return 2
  else
    aar $argv[1]
    return 0
  end
end
