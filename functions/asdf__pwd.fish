function asdf__pwd --on-variable=PWD
  string match -q "*.asdf/shims*" "$PATH"; and return
  set -l top_dir (git rev-parse --show-toplevel 2> /dev/null)
  test -z "$top_dir"; and set top_dir $HOME
  set top_dir (realpath $top_dir)

  set -l dir (realpath $PWD)

  if test -f "$dir/.tool-versions"
    asdf # delegate to function
    return
  end

  while not test $dir = $top_dir
    if test -f "$dir/.tool-versions"
      asdf # delegate to function
    end
    set dir (realpath $dir/..)
  end
end
