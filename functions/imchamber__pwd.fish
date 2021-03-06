function imchamber__pwd --on-variable=PWD
  if test -f .chamber
    if test "$AWS_ACCOUNT_ID" = "410444354559"
      if test (math $AWS_SESSION_EXPIRY - (jq -n now)) -gt 60
        imchamber
      else
        echo "dotfiles: skipping imchamber pwd hook (expired AWS credentials)"
      end
    else
      echo "dotfiles: skipping imchamber pwd hook (no AWS credentials)"
    end
  end
end
