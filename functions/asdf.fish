function asdf
  set -l real_asdf (which asdf)
  if test -z "$real_asdf"
    echo "dotfiles: asdf not installed or not in path"
    return 1
  end
  if not string match -q "*.asdf/shims*" "$PATH"
    echo "dotfiles: initialize asdf"
    if which -s brew
      set -gx ASDF_DIR (brew --prefix asdf)
    end
    if test -f /usr/local/share/fish/vendor_completions.d/asdf.fish
      source /usr/local/share/fish/vendor_completions.d/asdf.fish
    end
    set -x PATH $PATH ~/.asdf/shims
  end
  if test -n "$argv"
    $real_asdf $argv
  end
end
