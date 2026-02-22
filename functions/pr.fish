# Trigger Claude to open a pull request, optionally as draft, targeting
# either an explicit branch argument or the repo's default branch.
# If a PR already exists, opens it in the browser instead.
# Use --freshen/-f to ask Claude to critique and update an existing PR's description.
function pr
  argparse 'd/draft' 'f/freshen' -- $argv; or return

  # Check for an existing PR silently
  set -l existing_pr (gh pr view --json url --jq '.url' 2>/dev/null)

  if test -n "$existing_pr"
    if set -q _flag_freshen
      claude --model=opus "Review the current pull request and update its title and description to better reflect the changes. Critique the existing description for clarity, completeness, and accuracy, then rewrite it."
    else
      gh pr view --web
    end
    return
  end

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
  claude -p --model=opus "$prompt"
end
