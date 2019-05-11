#! /usr/bin/env fish

echo "set -gx AWS_PROFILE $argv[1]" 
echo "set -gx AWS_ACCESS_KEY $AWS_ACCESS_KEY_ID"
echo "set -gx AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY"
echo "set -gx AWS_SESSION_TOKEN $AWS_SESSION_TOKEN"
