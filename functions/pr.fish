# Trigger Claude to open a pull request, optionally as draft, targeting
# either an explicit branch argument or the repo's default branch.
function pr
  argparse 'd/draft' -- $argv; or return

  set -l dest $argv[1]

  if test -z "$dest"
    set dest (git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
  end

  if test -z "$dest"
    set dest (git remote show origin 2>/dev/null | sed -n '/HEAD branch/s/.*: //p' | head -1)
  end

  if test -z "$dest"
    set dest main
  end

  set -l draft_word ""
  if set -q _flag_draft
    set draft_word "draft "
  end

  set -l prompt "Open a "$draft_word"pull request to the "$dest" branch."
  claude --model=opus "$prompt"
end
