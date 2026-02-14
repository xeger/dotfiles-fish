if [ ! -f "$HOME/.gitignore_global" ]
  touch $HOME/.gitignore_global
  echo ".DS_Store" >> $HOME/.gitignore_global
end

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
alias sapply='git stash apply'
alias sclear='git stash clear'
alias sdrop='git stash drop'
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
