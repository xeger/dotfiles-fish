function rbenv__pwd --on-variable=PWD
  if test -f .ruby-version
    if test -z "$rbenv__initialized"; and which -s rbenv; and test -d ~/.rbenv
      echo "dotfiles: initialize rbenv"
      source (rbenv init -|psub)
      set -x rbenv_initialized 1
    end
  end
end
