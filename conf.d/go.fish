fish_add_path --path /usr/local/go/bin

if test -d ~/go/bin
  set -gx GOPATH ~/go
  fish_add_path --path ~/go/bin
  launchctl setenv PATH (string join ':' $PATH) GOPATH $GOPATH
end

alias cogen 'find . -type d -name gen | xargs git checkout HEAD'
alias comocks 'find . -type d -name mocks | xargs git checkout HEAD'
