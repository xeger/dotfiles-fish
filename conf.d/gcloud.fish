if [ -f '/Users/tony/.local/google-cloud-sdk/path.fish.inc' ]
  if type source > /dev/null
    source '/Users/tony/.local/google-cloud-sdk/path.fish.inc'
  else
    . '/Users/tony/.local/google-cloud-sdk/path.fish.inc'
  end
end
