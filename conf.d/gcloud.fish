if [ -f '/Users/tony/google-cloud-sdk/path.fish.inc' ]
  if type source > /dev/null
    source '/Users/tony/google-cloud-sdk/path.fish.inc'
  else
    . '/Users/tony/google-cloud-sdk/path.fish.inc'
  end
end
