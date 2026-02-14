# only works with Ruby 2.7+ (not OS X builtin Ruby, which is slated for removal)
set -x RUBYOPT "-W:no-deprecated"

# disable ri and rdoc during gem install
if ! test -f ~/.gemrc
  echo 'gem: --no-document' >> ~/.gemrc
end
