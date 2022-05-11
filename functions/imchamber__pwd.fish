function imchamber__pwd --on-variable=PWD
  if test -f .chamberrc
    set -l fingerprint (md5 -q .chamberrc)
    if test -n "$AWS_ACCOUNT_ID"
      if test (math $AWS_SESSION_EXPIRY - (jq -n now)) -gt 60
        if test "$fingerprint" != "$IMCHAMBER_PWD_LAST_FINGERPRINT"
          imchamber
          set -gx IMCHAMBER_PWD_LAST_FINGERPRINT $fingerprint
        else
          echo "dotfiles: skipping imchamber pwd hook (already ran)"
        end
      else
        echo "dotfiles: skipping imchamber pwd hook (expired AWS credentials)"
      end
    else
      echo "dotfiles: skipping imchamber pwd hook (no AWS credentials)"
    end
  end
end
