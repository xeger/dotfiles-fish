# AWS assume-role with fish sauce and an IM garnish.
function imaws
  argparse --name=imaws 'h/help' 'c/cached' 't/ttl' -- $argv 2> /dev/null
  or set _flag_h 1

  set -l profile_name $argv[1]

  if test -n "$_flag_h"
    echo "Usage: imaws [--cached] [--ttl=<ttl>] <arn|profile>"
    echo "  Uses the AWS CLI to assume-role (w/ MFA if required) into an AWS profile"
    echo "  as named in your from ~/.aws/config file, or as specified by an IAM role ARN."
    echo "Flags:"
    echo "  -c / --cached - do not obtain fresh credentials; exit silently if none cached"
    echo "  -t / --ttl    - min acceptable TTL for cached credentials (default 3600 sec)"
    echo ""
    echo "To unset all environment variables and restore AWS CLI to its default behavior,"
    echo "run imaws without an ARN or profile name."

    return 1
  end

  set -ge AWS_ACCOUNT_ID
  set -ge AWS_PROFILE
  set -ge AWS_ACCESS_KEY_ID
  set -ge AWS_SECRET_ACCESS_KEY
  set -ge AWS_SESSION_EXPIRY
  set -ge AWS_SESSION_TOKEN

  if test -z "$argv[1]"
    echo "imaws: No profile name given; unsetting all environment variables"
    echo "(For usage information, run imaws --help)"
    return 0
  end

  if test -n "$_flag_t"
    set min_ttl $_flag_t
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
      echo "imaws: No profile '$profile_name' in ~/.aws/config"
      return 1
    end
  end

  set -l role_account_id (echo  $role_arn | cut -d: -f5)
  set -l cache_key (echo $role_arn | cut -d: -f5)-(echo $role_arn | cut -d/ -f2)
  set -l json_file $HOME/.aws/cli/cache/imaws-$cache_key.json
  set -l login_account_alias "unknown"

  if test -f "$json_file"
    set -gx AWS_SESSION_EXPIRY (jq -r '.Credentials.Expiration | strptime("%Y-%m-%dT%H:%M:%S+00:00") | mktime' $json_file)
    if test (math $AWS_SESSION_EXPIRY - (jq -n 'now|floor')) -gt $min_ttl
      # NB: Sets creds globally (and weirdly, not locally) for future shell commands
      set -gx AWS_ACCOUNT_ID $role_account_id
      set -gx AWS_PROFILE $profile_name
      set -gx AWS_ACCESS_KEY_ID (jq -r .Credentials.AccessKeyId  $json_file)
      set -gx AWS_SECRET_ACCESS_KEY (jq -r .Credentials.SecretAccessKey  $json_file)
      set -gx AWS_SESSION_TOKEN (jq -r .Credentials.SessionToken  $json_file)

      # Deal with shitty old E2E suites that need CircleCI-style env vars (yech!)
      set -gx IM_AWS_ACCESS_KEY $AWS_ACCESS_KEY_ID
      set -gx IM_AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
      set -gx IM_AWS_SESSION_TOKEN $AWS_SESSION_TOKEN

      echo "imaws: Resumed CLI session for $role_arn"

      if test -f .chamberrc
        # Set creds locally so instaneous imchamber invocation can use them.
        # The `-gx` above can't be seen within the subroutine, weirdly enough. Maybe a fish bug?
        set -lx AWS_ACCOUNT_ID $role_account_id
        set -lx AWS_PROFILE $profile_name
        set -lx AWS_ACCESS_KEY_ID (jq -r .Credentials.AccessKeyId  $json_file)
        set -lx AWS_SECRET_ACCESS_KEY (jq -r .Credentials.SecretAccessKey  $json_file)
        set -lx AWS_SESSION_TOKEN (jq -r .Credentials.SessionToken  $json_file)
        imchamber
      end

      return 0
    end
  end

  if test -n "$_flag_c"
    return 0
  end

  echo "imaws: Initializing CLI session for $role_arn"

  set source_profile (grep -A5 "\[profile $profile_name\]" ~/.aws/config | grep source_profile | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
  if test -n "$source_profile"
    set profile_stuff --profile=$source_profile
    set -x AWS_ACCESS_KEY_ID (grep -A3 "\[$source_profile\]" ~/.aws/credentials | grep aws_access_key_id | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
    set -x AWS_SECRET_ACCESS_KEY (grep -A3 "\[$source_profile\]" ~/.aws/credentials | grep aws_secret_access_key | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
    set login_account_alias (aws iam list-account-aliases | jq -r '.AccountAliases[0]')
  end
  if test -z "$AWS_ACCESS_KEY_ID" -o -z "$AWS_SECRET_ACCESS_KEY" -o -z "$login_account_alias"
    echo "imaws: Failed to obtain credentials for source profile $source_profile; cannot perform STS operations"
    return 1
  end

  set duration_seconds (grep -A5 "\[profile $profile_name\]" ~/.aws/config | grep duration_seconds | awk 'BEGIN { FS = " ?= ?" } ; { print $2 }')
  if test -z "$duration_seconds"
    set duration_seconds 43200
  end

  set -l mfa_stuff ""
  if test -n "$mfa_serial"
    set -l aws_email (echo $mfa_serial | cut -d/ -f2)
    set -l mfa_code 'unknown'
    if which -s op; and op item list | grep -q "AWS ($aws_email)"
      echo "+ op item get \"AWS ($aws_email)\""
      set mfa_code (op item get "AWS ($aws_email)" | grep 'one-time password:' | cut -b25-)
    else if which -s ykman
      echo "+ ykman oath accounts code --single AWS:$login_account_alias"
      set mfa_code (ykman oath accounts code --single AWS:$login_account_alias)
    end
    if [ "$mfa_code" = "unknown" ]
      echo "imaws: Failed to obtain MFA code; sorry"
      return 2
    end
    set mfa_stuff --role-session-name=$aws_email --serial-number=$mfa_serial --token-code=$mfa_code
  else
    set mfa_stuff --role-session-name=(whoami)@(hostname)
  end

  # TODO: look into this alternate version
  # aws sts get-session-token $mfa_stuff
  echo "+ aws sts assume-role $profile_stuff --role-arn=$role_arn $mfa_stuff --output=json --duration-seconds=$duration_seconds"
  set -l session_json (aws sts assume-role --role-arn=$role_arn $mfa_stuff --output=json --duration-seconds=$duration_seconds)
  set -l sts_status $status

  if test "$sts_status" -ne 0
    echo "imaws: Failed to obtain credentials ($sts_status); please try again"
    return 3
  else
    mkdir -p (dirname $json_file)
    echo $session_json > $json_file
    imaws $argv[1]
    return 0
  end
end
