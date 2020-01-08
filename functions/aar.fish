# AWS assume-role with fish sauce and an IM garnish.
function aar
  set -l profile_name $argv[1]
  set -l role_arn (grep -A3 "\[profile $profile_name\]" ~/.aws/config | grep role_arn | awk 'BEGIN { FS = " = " } ; { print $2 }')
  set -l mfa_serial (grep -A3 "\[profile $profile_name\]" ~/.aws/config | grep mfa_serial | awk 'BEGIN { FS = " = " } ; { print $2 }')
  if test -z $role_arn
    echo "No profile '$profile_name' in ~/.aws/config"
    return 1
  end
  
  set -l json_file $HOME/.aws/cli/cache/aar-$profile_name.json
  if test -f "$json_file"
    set -gx AWS_SESSION_EXPIRATION (jq -r .Credentials.Expiration  $json_file)
    if ruby -rtime -e 'exit Time.parse(ENV["AWS_SESSION_EXPIRATION"]) > Time.now'
      set -gx AWS_PROFILE $profile_name
      set -gx AWS_ACCESS_KEY (jq -r .Credentials.AccessKeyId  $json_file)
      set -gx AWS_SECRET_ACCESS_KEY (jq -r .Credentials.SecretAccessKey  $json_file)
      set -gx AWS_SESSION_TOKEN (jq -r .Credentials.SessionToken  $json_file)

      set -gx IM_AWS_ACCESS_KEY $AWS_ACCESS_KEY
      set -gx IM_AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
      set -gx IM_AWS_SESSION_TOKEN $AWS_SESSION_TOKEN

      # AWS creds are obtained; now let's grab all of the app secrets from
      # the AWS parameter store for our product.
      set -l secrets_json (chamber export --format=json investment-management)
      set -l secrets_names (echo $secrets_json | jq -r 'keys | .[]')
      for name in $secrets_names
        set -gx (echo $name | tr a-z A-Z)  (echo $secrets_json | jq -r .$name)
      end

      return 0
    end
  else
    set -l json_file
  end

  set -ge AWS_PROFILE
  set -ge AWS_ACCESS_KEY
  set -ge AWS_SECRET_ACCESS_KEY
  set -ge AWS_SESSION_TOKEN

  echo "aar: Initializing CLI session for $profile_name ($role_arn)"
  set -l mfa_stuff ""
  if test -n "$mfa_serial"
    set -l mfa_code (ykman oath code --single AWS:appfolio-login)
    if test -z "$mfa_code"
      return 2
    end
    # read -p "echo 'MFA code: '" mfa_code
    set mfa_stuff --serial-number=$mfa_serial --token-code=$mfa_code
  end
  echo "aws sts assume-role --role-session-name=$profile_name --role-arn=$role_arn --output=json --duration-seconds=43200 $mfa_stuff"
  set -l session_json (aws sts assume-role --role-session-name=$profile_name --role-arn=$role_arn --output=json --duration-seconds=43200 $mfa_stuff)
  set -l sts_status $status

  if test "$sts_status" -ne 0
    echo "aar: Failed to obtain credentials ($sts_status); please try again"
    return 3
  else
    echo $session_json > $json_file
    aar $profile_name
    return 0
  end
end
