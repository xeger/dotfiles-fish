# AWS assume-role with fish sauce and an IM garnish.
function imaws
  argparse --name=imaws 'h/help' 'c/cached' 't/ttl' -- $argv 2> /dev/null
  or set _flag_h 1

  set -l profile_name $argv[1]

  if test -n "$_flag_h"; or test -z "$argv[1]"
    echo "Usage: imaws [--cached] [--ttl=<ttl>] <arn|profile>"
    echo "  Uses the AWS CLI to assume-role (w/ MFA if required) into an AWS profile"
    echo "  as named in your from ~/.aws/config file, or as specified by an IAM role ARN."
    echo "Flags:"
    echo "  -c / --cached - do not obtain fresh credentials; exit silently if none cached"
    echo "  -t / --ttl    - min acceptable TTL for cached credentials (default 3600 sec)"

    return 1
  end

  if test -n "$flag_t"
    set min_ttl $flag_t
  else
    set min_ttl 3600
  end

  set -l role_arn ''
  set -l mfa_serial ''
  set -l profile_name ''
  if string match -qr '^arn:' $argv[1]
    set role_arn $argv[1]
    if test -n "$AWS_MFA_SERIAL"
      set mfa_serial $AWS_MFA_SERIAL
    end
  else
    set profile_name $argv[1]
    set mfa_serial (grep -A5 "\[profile $profile_name\]" ~/.aws/config | grep mfa_serial | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
    set role_arn (grep -A5 "\[profile $profile_name\]" ~/.aws/config | grep role_arn | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
    set source_profile (grep -A5 "\[profile $profile_name\]" ~/.aws/config | grep source_profile | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
    if test -z "$role_arn"
      echo "No profile '$profile_name' in ~/.aws/config"
      return 1
    end
  end

  set -l role_account_id (echo  $role_arn | cut -d: -f5)
  set -l cache_key (echo $role_arn | cut -d: -f5)-(echo $role_arn | cut -d/ -f2)
  set -l json_file $HOME/.aws/cli/cache/imaws-$cache_key.json

  if test -f "$json_file"
    set -gx AWS_SESSION_EXPIRY (jq -r '.Credentials.Expiration | strptime("%Y-%m-%dT%H:%M:%S+00:00") | mktime' $json_file)
    if test (math $AWS_SESSION_EXPIRY - (jq -n 'now|floor')) -gt $min_ttl
      set -gx AWS_ACCOUNT_ID $role_account_id
      set -gx AWS_PROFILE $profile_name
      set -gx AWS_ACCESS_KEY_ID (jq -r .Credentials.AccessKeyId  $json_file)
      set -gx AWS_SECRET_ACCESS_KEY (jq -r .Credentials.SecretAccessKey  $json_file)
      set -gx AWS_SESSION_TOKEN (jq -r .Credentials.SessionToken  $json_file)

      echo "imaws: Resumed CLI session for $role_arn"
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

  echo "imaws: Initializing CLI session for $role_arn"

  set source_profile (grep -A5 "\[profile $profile_name\]" ~/.aws/config | grep source_profile | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
  if test -n "$source_profile"
    set profile_stuff --profile=$source_profile
    set -x AWS_ACCESS_KEY_ID (grep -A3 "\[$source_profile\]" ~/.aws/credentials | grep aws_access_key_id | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
    set -x AWS_SECRET_ACCESS_KEY (grep -A3 "\[$source_profile\]" ~/.aws/credentials | grep aws_secret_access_key | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
  end

  set duration_seconds (grep -A5 "\[profile $profile_name\]" ~/.aws/config | grep duration_seconds | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
  if test -z "$duration_seconds"
    set duration_seconds 43200
  end

  set -l mfa_stuff ""
  if test -n "$mfa_serial"; and which -s ykman
    set -l aws_email (echo $mfa_serial | cut -d/ -f2)
    echo "+ ykman oath accounts code --single AWS:appfolio-im-login"
    set -l mfa_code (ykman oath accounts code --single AWS:appfolio-im-login)
    if test -z "$mfa_code"
      return 2
    end
    set mfa_stuff --role-session-name=$aws_email --serial-number=$mfa_serial --token-code=$mfa_code
  else
    set mfa_stuff --role-session-name=(whoami)@(hostname)
  end

  # TODO: look into this alternate version
  # aws sts get-session-token $mfa_stuff
  echo "aws sts assume-role $profile_stuff --role-arn=$role_arn $mfa_stuff --output=json --duration-seconds=$duration_seconds"
  set -l session_json (aws sts assume-role --role-arn=$role_arn $mfa_stuff --output=json --duration-seconds=$duration_seconds)
  set -l sts_status $status

  if test "$sts_status" -ne 0
    echo "imaws: Failed to obtain credentials ($sts_status); please try again"
    return 3
  else
    echo $session_json > $json_file
    imaws $argv[1]
    return 0
  end
end
