######## basic Unix stuff: editor, terminal, etc

set -x EDITOR vi

# clean start (avoid Visual Studio Code bugs w/ path duplication)
if test -f /etc/paths
  set -x PATH (cat /etc/paths | tr '\n' ':' | sed -Ee '$ s/:+$//')
end

alias psx 'pstree -U -g 2 %self'
alias lsx 'tree -A -C -L 2'

######## ssh

if test -n "$SSH_AUTH_SOCK"
  set -l private_keys (grep -El 'BEGIN [A-Z]* ?PRIVATE KEY' ~/.ssh/*)
  if test $status = 0; and test -n "$private_keys"
    ssh-add $private_keys 2> /dev/null
    if test $status != 0
      echo "Could not add private SSH keys to agent"
      echo "Please run this command by hand:"
      echo "ssh-add $private_keys"
    end
  end
end

######## google go

if test -d ~/go/bin
  set -x GOPATH ~/go
  set -x PATH $PATH ~/go/bin
  launchctl setenv PATH (string join ':' $PATH) GOPATH $GOPATH
end

######## python

if test -d $HOME/Library/Python/3.9/bin # on Mac OS X
  set -x PATH $PATH $HOME/Library/Python/3.9/bin
end

######## ruby

# only works with Ruby 2.7 (not OS X builtin Ruby, blech)
set -x RUBYOPT "-W:no-deprecated"
#set -x RUBYOPT "-W0"

# seems to be actively harmful under Mojave w/ ruby 2.3.x
# does not harm Ruby 2.5
#if test -d /usr/local/opt/openssl
#  set -x RUBY_CFLAGS -I/usr/local/opt/openssl/include -L/usr/local/opt/openssl/lib
#end

######## docker

alias darch 'docker inspect -f "{{.Architecture}}"'
alias dc    'docker-compose'
alias dcb   'docker-compose build'
alias dcr   'docker-compose run'
alias di    'docker inspect'
alias dim   'docker images'
alias dn    'docker network'
alias dps   'docker ps'
alias drm   'docker rm -f'
alias drmi  'docker rmi'
alias dv    'docker volume'
alias dst   'docker stack'
alias ds    'docker service'
alias dsi   'docker service inspect --pretty'
alias dtty  'nc -U ~/Library/Containers/com.docker.docker/Data/debug-shell.sock'


######## Kubernetes
alias kc   'kubectl'

######## google cloud SDK

if [ -f '/Users/tony/google-cloud-sdk/path.fish.inc' ]
  if type source > /dev/null
    source '/Users/tony/google-cloud-sdk/path.fish.inc'
  else
    . '/Users/tony/google-cloud-sdk/path.fish.inc'
  end
end

######## git

alias fetch='git fetch'
alias gb='git branch'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --topo-order --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glp='git log --topo-order --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%G?:%an>%Creset" --abbrev-commit'
alias gss='git status'
alias gsw='git show'
alias sclear='git stash clear'
alias slist='git stash list'
alias spush='git stash save'
alias spop='git stash pop'

# git prompt lifted from http://goo.gl/Wq5lb7
set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡ '
set __fish_git_prompt_char_stagedstate '📌 '
set __fish_git_prompt_char_untrackedfiles '💩 '
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '⋙'
set __fish_git_prompt_char_upstream_behind '⋘'

function fish_prompt
  set last_status $status

  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  set danger ''
  set here (basename $PWD)
  if git add -n ../$here 2>&1 | grep -q 'are ignored'
    set danger ' ⚠️ ️'
  end

  printf '%s%s ' $danger (__fish_git_prompt)

  set_color normal
end

######## terraform

alias tf='terraform'

######## local config that should not be committed to git

if [ -f ~/.config/fish/local.fish ]
  source ~/.config/fish/local.fish
end

######## tool version managers (even for non-interactive shells!)

if test -d ~/.asdf
  set -x PATH ~/.asdf/shims $PATH
  if status --is-interactive
    if test -f /usr/local/share/fish/vendor_completions.d/asdf.fish
      source /usr/local/share/fish/vendor_completions.d/asdf.fish
    end
  end
end

######## VS Code

string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)
