# AWS assume-role with fish sauce and an IM garnish.
function aar
  rm -f ~/.aws/aws-credentials-$argv[1].fish
  assume-role -duration 12h0m0s $argv[1] $HOME/.config/fish/scripts/dump-aws-credentials.fish $argv[1] > ~/.aws/credentials-$argv[1].fish
  if test -f ~/.aws/credentials-$argv[1].fish
    source ~/.aws/credentials-$argv[1].fish

    set -gx IM_AWS_ACCESS_KEY $AWS_ACCESS_KEY
    set -gx IM_AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
    set -gx IM_AWS_SESSION_TOKEN $AWS_SESSION_TOKEN
        
    echo "Switched AWS account to $AWS_PROFILE"
    return 0
  else
    echo "FATAL: assume-role failed to produce ~/.aws/credentials-$argv[1].fish"
    return 1
  end
end
