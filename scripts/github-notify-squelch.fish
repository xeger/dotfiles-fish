#! /usr/bin/env fish

# <?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
#   <dict>
#     <key>Label</key>
#     <string>com.tony.github-notify-squelch</string>
#     <key>ProgramArguments</key>
#     <array>
#       <string>/opt/homebrew/bin/fish</string>
#       <string>/Users/tony/.config/fish/scripts/github-notify-squelch.fish</string>
#     </array>
#     <key>StartInterval</key>
#     <integer>14400</integer>
#     <key>RunAtLoad</key>
#     <true />
#   </dict>
# </plist>

# launchctl load ~/Library/LaunchAgents/net.xeger.github-notify-squelch.plist
# launchctl unload ~/Library/LaunchAgents/net.xeger.github-notify-squelch.plist
# log show --predicate 'subsystem contains "com.tony.github-notify-squelch"'

gh api /notifications --jq 'map(select(.unread == true and .repository.owner.login == "crossnokaye")) | .[].id' | xargs -I {} gh api --verbose --method DELETE /notifications/threads/{}
