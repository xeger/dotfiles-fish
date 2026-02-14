######## basic Unix stuff: editor, terminal, etc

set -gx EDITOR vi
set -gx XDG_CONFIG_HOME ~/.config

# clean start (avoid Visual Studio Code bugs w/ path duplication)
if test -f /etc/paths
  set -x PATH (cat /etc/paths | tr '\n' ':' | sed -Ee '$ s/:+$//')
end

######## xdg binaries

if test -d ~/.local/bin
  set -x PATH $PATH ~/.local/bin
end

######## general-purpose aliases

alias psx 'pstree -U -g 2 %self'
alias lsx 'tree -A -C -L 2'

######## prompt

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

######## local config that should not be committed to git

if [ -f ~/.config/fish/local.fish ]
  source ~/.config/fish/local.fish
end
