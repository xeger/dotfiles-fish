######## basic Unix stuff: editor, terminal, etc

setenv EDITOR vi

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

setenv GOPATH ~/go
setenv PATH $PATH ~/go/bin
launchctl setenv PATH $PATH
launchctl setenv GOPATH $GOPATH

######## ruby

set PATH $HOME/.rbenv/bin $PATH
. (rbenv init -|psub)

alias bx 'bundle exec'
alias r 'bundle exec rake'

######## docker

alias dc   'docker-compose'
alias dcb  'docker-compose build'
alias dcr  'docker-compose run'
alias dgc  'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc spotify/docker-gc'
alias di   'docker inspect'
alias dim  'docker images'
alias dn   'docker network'
alias dps  'docker ps --format '\''table {{.ID | printf "%12.12s"}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'\'''
alias drm  'docker rm -f'
alias drmi 'docker rmi'
alias dv   'docker volume'
alias dst  'docker stack'
alias ds   'docker service'
alias dsi  'docker service inspect --pretty'

######## git

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
