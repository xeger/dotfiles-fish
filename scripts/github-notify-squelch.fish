#! /usr/bin/env fish

gh api /notifications --jq 'map(select(.unread == true and .repository.owner.login == "crossnokaye")) | .[].id' | xargs -I {} gh api --verbose --method DELETE /notifications/threads/{}
