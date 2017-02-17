function vendor
  if test -d vendor/$argv[1]
    echo "Already vendored:"
    ls -lad vendor/$1
    echo Nothing to do
    return 1
  else if test -d ~/Code/$argv[1]
    echo "Symlinking $argv[1] under vendor"
    ln -s ~/Code/$argv[1] vendor/$argv[1]
    if test -d vendor/$argv[1]/vendor
      echo "Removing vendor subdir of $argv[1]"
      rm -Rf vendor/$argv[1]/vendor
    end
  end
end
