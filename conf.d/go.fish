if test -d /usr/local/go/bin
  set -x PATH $PATH /usr/local/go/bin
end

if test -d ~/go/bin
  set -x GOPATH ~/go
  set -x PATH $PATH ~/go/bin
  launchctl setenv PATH (string join ':' $PATH) GOPATH $GOPATH
end

alias cogen 'find . -type d -name gen | xargs git checkout HEAD'
alias comocks 'find . -type d -name mocks | xargs git checkout HEAD'
