function atlantis
  # graphql query for the last comment on a PR
  set query_top_comment '
    query($pr: Int!) {
      repository(name:"terraform", owner: "crossnokaye") {
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

  gh api --silent "/repos/{owner}/{repo}/issues/$pr_number/comments" -f body="atlantis $argv"

  echo -n "Waiting for Atlantis to respond"
  set comment_file (mktemp)
  set done 0
  # set since (date -u +"%Y-%m-%dT%H:%M:%SZ")
  while test $done -eq 0
    #gh api "/repos/{owner}/{repo}/issues/$pr_number/comments?since=$since&per_page=2&page=1" | jq '.[1]' > $comment_file
    gh api graphql -F pr=753 -f query=$query_top_comment -q '.data.repository.pullRequest.comments.edges[0].node' > $comment_file
    set comment_author (jq -r '.author.login' < $comment_file)
    if test $comment_author = "crossnokaye-atlantis"
      set done 1
    else
      echo -n "."
      sleep 1
    end
  end
  echo

  echo
  jq -r '.body' < $comment_file
  jq -r '.body' < $comment_file | grep -Eq '(Apply|Plan) Error'
  if test $status -eq 0
    return 1
  end
  return 0
end
