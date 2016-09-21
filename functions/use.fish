function use
  if test "$argv[1]" = ""
    rbenv versions
  else if rbenv versions | grep -q $argv[1]
    set -gx RBENV_VERSION $argv[1]
    rbenv version
  else
    echo "use: no rbenv version $argv[1]"
    return 1
  end
end
