function atlantis
  # graphql query for the last comment on a PR
  set query_top_comment '
    query($owner: String!, $name: String!, $pr: Int!) {
      repository(name: $name, owner: $owner) {
        pullRequest(number: $pr) {
          comments(last: 1) {
            edges {
              node {
                author {
                  login
                }
                body
              }
            }
          }
        }
      }
    }
  '

  # identify relevant PR number
  set pr_number (gh pr view --json=number --jq=.number)
  if test -z $pr_number
    echo "No open pull request(s) for current branch."
    return 1
  end

  if test (count $argv) -gt 0
    echo "+ atlantis $argv"
    gh api --silent "/repos/{owner}/{repo}/issues/$pr_number/comments" -f body="atlantis $argv"
    echo -n "Waiting for Atlantis to respond"
  else
    echo -n "Retrieving last Atlantis comment (or looping forever, your choice)"
  end

  set comment_file (mktemp)
  set done 0
  while test $done -eq 0
    # echo "----"
    # echo "gh api graphql -F owner='{owner}' -F name='{repo}' -F pr=$pr_number -f query=$query_top_comment"
    # echo "----"
    gh api graphql -F owner='{owner}' -F name='{repo}' -F pr=$pr_number -f query=$query_top_comment -q '.data.repository.pullRequest.comments.edges[0].node' > $comment_file
    set comment_author (jq -r '.author.login' < $comment_file)
    if string match -q "*atlantis*" -- $comment_author
      set done 1
    else
      echo -n "."
      sleep 5
    end
  end
  echo

  echo
  jq -r '.body' < $comment_file
  jq -r '.body' < $comment_file | grep -Eq '(Apply|Plan) Error'
  # echo "---------------------------------"
  # cat $comment_file
  # echo "---------------------------------"
  if test $status -eq 0
    return 1
  end
  return 0
end
