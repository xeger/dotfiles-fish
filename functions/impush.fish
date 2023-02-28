# AWS assume-role with fish sauce and an IM garnish.
function impush
  argparse --name=impush 'h/help' -- $argv 2> /dev/null
  or set _flag_h 1

  if test -n "$_flag_h"
    echo "Usage: impush"
    echo "TODO.."

    return 1
  end

  pushd ~/Code/appfolio/im

  cd backend/api/deploy
  set release_name (git symbolic-ref --short HEAD | sed 's/\([A-Z]\)/-\1/g;s/^-//' | tr '[:upper:]' '[:lower:]')
  bin/coreapi release delete $release_name
  bin/coreapi release create $release_name --sha=(HEAD)

  cd ../../../deploy
  set account_name $release_name
  bin/im account create $account_name --rel=$release_name

  popd
end
