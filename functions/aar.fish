# AWS assume-role with fish sauce and an IM garnish.
function aar
  set -l role_arn (grep -A3 "\[profile $argv[1]\]" ~/.aws/config | grep role_arn | awk 'BEGIN { FS = " = " } ; { print $2 }')
  set -l mfa_serial (grep -A3 "\[profile $argv[1]\]" ~/.aws/config | grep mfa_serial | awk 'BEGIN { FS = " = " } ; { print $2 }')
  if test -z $role_arn
    echo "No profile '$argv[1]' in ~/.aws/config"
    return 1
  end
  
  # role_arn e.g. => arn:aws:iam::410444354559:role/SuperUser
  # needed   e.g. => 410444354559:assumed-role/SuperUser
  set -l search_str (echo $role_arn |  awk 'BEGIN { FS = ":" } ; { print $5 ":assumed-" $6 }')
  set -l json_file (grep -lr "$search_str" ~/.aws/cli/cache | head -1)  

  if test -n "$json_file"
    set -gx AWS_SESSION_EXPIRATION (jq -r .Credentials.Expiration  $json_file)
    if ruby -rtime -e 'exit Time.parse(ENV["AWS_SESSION_EXPIRATION"]) > Time.now'
      set -gx AWS_PROFILE $argv[1]
      set -gx AWS_ACCESS_KEY (jq -r .Credentials.AccessKeyId  $json_file)
      set -gx AWS_SECRET_ACCESS_KEY (jq -r .Credentials.SecretAccessKey  $json_file)
      set -gx AWS_SESSION_TOKEN (jq -r .Credentials.SessionToken  $json_file)

      set -gx IM_AWS_ACCESS_KEY $AWS_ACCESS_KEY
      set -gx IM_AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
      set -gx IM_AWS_SESSION_TOKEN $AWS_SESSION_TOKEN

      # AWS creds are obtained; now let's grab all of the app secrets from
      # the AWS parameter store for our product.
      set -l secrets (chamber export --format=dotenv investment-management)
      for line in $secrets
        set -xg (echo $line | cut -d = -f 1) (echo $line | cut -d = -f 2-)
      end

      return 0
    end
  else
    set -l json_file
  end

  echo "aar: Initializing CLI session for $argv[1] ($role_arn)"
  set -l mfa_stuff ""
  if test -n "$mfa_serial"
    read -p "echo 'MFA code: '" mfa_code
    set mfa_stuff --serial-number=$mfa_serial --token-code=$mfa_code
  end
  echo "aws sts assume-role --role-session-name=$argv[1] --role-arn=$role_arn --output=json --duration-seconds=43200 $mfa_stuff"
  set -l session_json (aws sts assume-role --role-session-name=$argv[1] --role-arn=$role_arn --output=json --duration-seconds=43200 $mfa_stuff)
  set -l sts_status $status

  if test "$sts_status" -ne 0
    echo "aar: Failed to obtain credentials ($sts_status); please try again"
    return 2
  else
    echo $session_json > ~/.aws/cli/cache/$argv[1].json
    aar $argv[1]
    return 0
  end
end
