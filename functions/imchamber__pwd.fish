function imchamber__pwd --on-variable=PWD
  if test -f .chamber
    if test "$AWS_ACCOUNT_ID" = "410444354559"
      imchamber
    else
      echo "imchamber: skipping chdir hook (no AWS credentials)"
    end
  end
end
