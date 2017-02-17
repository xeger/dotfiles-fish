function unvendor
  if test -s vendor/$argv[1]
    echo "Remove symlink:"
    echo -n '  '; ls -Pld vendor/$argv[1]
    rm vendor/$argv[1]
    echo "Gopath copy will prevail:"
    echo -n '  '; ls -Pld ~/Code/$argv[1]
    return 0
  else if test -d vendor/$argv[1]/.git; and test ! -d ~/Code/$argv[1]
    echo "Move vendored Git repository to gopath:"
    echo -n '  '; ls -Pld vendor/$argv[1]
    mv vendor/$argv[1] ~/Code/$argv[1]
    echo "New location:"
    echo -n '  '; ls -Pld ~/Code/$argv[1]
    return 0
  else if test -d vendor/$argv[1]; and test ! -d ~/Code/$argv[1]; and test -d ~/Code/$argv[1]
    echo "Destroy vendored subdir"
    echo -n '  '; ls -Pld vendor/$argv[1]
    rm -Rf vendor/$argv[1]
    echo "Gopath copy will prevail:"
    echo -n '  '; ls -Pld ~/Code/$argv[1]
    return 0
  else
    echo "Cannot safely unvendor due to source/dest conflict:"
    echo -n '  '; ls -Pld vendor/$argv[1]
    echo -n '  '; ls -Pld ~/Code/$argv[1]
    return 1
  end
end
