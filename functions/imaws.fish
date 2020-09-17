# AWS assume-role with fish sauce and an IM garnish.
function imaws
  argparse --name=imbless 'h/help' 'c/cached' -- $argv 2> /dev/null
  or set _flag_h 1

  set -l profile_name $argv[1]

  if test -n "$_flag_h"; or test -z "$profile_name"
    echo "Usage: imaws [--cached] <aws_cli_profile_name>"
    echo "  Uses the AWS CLI to assume-role (w/ MFA if required) into an AWS profile"
    echo "  as named in your from ~/.aws/config file."
    echo "Flags:"
    echo "  cached - do not obtain fresh credentials; exit silently if none cached"
    return 1
  end

  set -l role_arn (grep -A3 "\[profile $profile_name\]" ~/.aws/config | grep role_arn | awk 'BEGIN { FS = " = " } ; { print $2 }')
  set -l mfa_serial (grep -A3 "\[profile $profile_name\]" ~/.aws/config | grep mfa_serial | awk 'BEGIN { FS = " = " } ; { print $2 }')
  if test -z "$role_arn"
    echo "No profile '$profile_name' in ~/.aws/config"
    return 1
  end
  set -l role_account_id (echo  $role_arn | cut -d: -f5)

  set -l json_file $HOME/.aws/cli/cache/imaws-$profile_name.json
  if test -f "$json_file"
    set -gx AWS_SESSION_EXPIRATION (jq -r .Credentials.Expiration  $json_file)
    set -x RBENV_VERSION system ; set -x RUBY_VERSION system
    if ruby -rtime -e 'exit Time.parse(ENV["AWS_SESSION_EXPIRATION"]) > Time.now'
      set -gx AWS_ACCOUNT_ID $role_account_id
      set -gx AWS_PROFILE $profile_name
      set -gx AWS_ACCESS_KEY_ID (jq -r .Credentials.AccessKeyId  $json_file)
      set -gx AWS_SECRET_ACCESS_KEY (jq -r .Credentials.SecretAccessKey  $json_file)
      set -gx AWS_SESSION_TOKEN (jq -r .Credentials.SessionToken  $json_file)

      set -gx IM_AWS_ACCESS_KEY $AWS_ACCESS_KEY_ID
      set -gx IM_AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
      set -gx IM_AWS_SESSION_TOKEN $AWS_SESSION_TOKEN

      # AWS creds are obtained; now let's grab all of the app secrets from
      # the AWS parameter store for our product.
      # set -l secrets_json (chamber export --format=json investment-management)
      # set -l secrets_names (echo $secrets_json | jq -r 'keys | .[]')
      # for name in $secrets_names
      #   set -gx (echo $name | tr a-z A-Z)  (echo $secrets_json | jq -r .$name)
      # end

      echo "imaws: Resumed CLI session for $profile_name ($role_arn)"
      return 0
    end
  end

  if test -n "$_flag_c"
    return 0
  end

  set -ge AWS_ACCOUNT_ID
  set -ge AWS_PROFILE
  set -ge AWS_ACCESS_KEY_ID
  set -ge AWS_SECRET_ACCESS_KEY
  set -ge AWS_SESSION_TOKEN

  echo "imaws: Initializing CLI session for $profile_name ($role_arn)"
  set -l mfa_stuff ""
  if test -n "$mfa_serial"
    set -l mfa_code (ykman oath code --single AWS:appfolio-login)
    if test -z "$mfa_code"
      return 2
    end
    set mfa_stuff --serial-number=$mfa_serial --token-code=$mfa_code
  end

  # be friendly to Ops and security auditors
  set -l session_name "$EMAIL-$profile_name"

  echo "aws sts assume-role --role-session-name=$session_name --role-arn=$role_arn --output=json --duration-seconds=43200 $mfa_stuff"
  set -l session_json (aws sts assume-role --role-session-name=$profile_name --role-arn=$role_arn --output=json --duration-seconds=43200 $mfa_stuff)
  set -l sts_status $status

  if test "$sts_status" -ne 0
    echo "imaws: Failed to obtain credentials ($sts_status); please try again"
    return 3
  else
    echo $session_json > $json_file
    imaws $profile_name
    return 0
  end
end
