function turbo 
  set -x BUNDLE_GEMFILE Gemfile.turbo
  eval bundle exec $argv
  set -e BUNDLE_GEMFILE
end

