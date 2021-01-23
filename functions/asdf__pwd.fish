function asdf__pwd --on-variable=PWD
  if test -f .tool-versions
    if test -z "$asdf__initialized"; and which -s asdf
      echo "dotfiles: initialize asdf"
      if which -s brew
        set -x ASDF_DIR (brew --prefix asdf)
      end
      if test -f /usr/local/share/fish/vendor_completions.d/asdf.fish
        source /usr/local/share/fish/vendor_completions.d/asdf.fish
      end
      set -x PATH $PATH ~/.asdf/shims
      set -g asdf_initialized 1
    end
  end
end
