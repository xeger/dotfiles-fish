function trav
  # Use working branch if no branch name provided
  if test (count $argv) -gt 0
    set branch $argv[1]
  else
    set branch (git symbolic-ref HEAD 2>/dev/null | sed -e 's:refs/heads/::')
  end

  # Use PWD if no repo names provided
  if test (count $argv) -gt 1
    set repos $argv[2..-1]
  else
    set repos (basename $PWD)
    pushd ..
  end

  for subdir in $repos
    cd $subdir
    printf '%20.20s - ' $subdir
    set output (travis history -i -l 1 -b $branch)
    echo $output
    if echo $output | grep -qv 'passed'
      travis open (echo $output | cut -d'#' -f2 | cut -d' ' -f1)
    end
    cd ..
  end

  if test (count $argv) -lt 2
    popd
  end
end
