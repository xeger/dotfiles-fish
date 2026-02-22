if test -d ~/.asdf
  set -x ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY latest_installed
  fish_add_path --path --prepend --move ~/.asdf/shims
  if status --is-interactive
    if test -d /opt/homebrew/opt/asdf
      source /opt/homebrew/opt/asdf/libexec/asdf.fish
      source /opt/homebrew/share/fish/vendor_completions.d/asdf.fish
    else if test -d /usr/local/opt/asdf
      source /usr/local/opt/asdf/libexec/asdf.fish
      source /usr/local/share/fish/vendor_completions.d/asdf.fish
    end
  end
end
