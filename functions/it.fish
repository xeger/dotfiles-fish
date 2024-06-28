function it
  if test "$argv[1]" = "env"
    source (_it_cli env $argv[2] $argv[3])
  else
  _it_cli $argv
  end
end
i
