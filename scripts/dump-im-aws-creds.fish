#! /usr/bin/env fish

echo "set -gx IM_AWS_ACCOUNT_NAME $argv[1]" > ~/.aws/im-credentials.fish
echo "set -gx IM_AWS_ACCESS_KEY $AWS_ACCESS_KEY_ID" >> ~/.aws/im-credentials.fish
echo "set -gx IM_AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY" >> ~/.aws/im-credentials.fish
echo "set -gx IM_AWS_SESSION_TOKEN $AWS_SESSION_TOKEN" >> ~/.aws/im-credentials.fish
