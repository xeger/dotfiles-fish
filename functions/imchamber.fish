function imchamber
  argparse --name=imchamber 'h/help' 'e/env' -- $argv 2> /dev/null
  or set _flag_h 1

  if test -z "$argv[1]"; and test -f .chamber
    set service (cat .chamber)
  else if test -n "$argv[1]"
    set service $argv[1]
  end

  if test -n "$_flag_h"; or test -z "$service"
    echo "Usage: imchamber [--env] <service_name>"
    echo "  - or, write .chamber to PWD containing service_name"
    echo "Flags:"
    echo "  env - export secrets to shell environment, not to .env.local"
    return 1
  end

  if test -n "$_flag_e"
      set -l secrets_json (chamber export --format=json $service)
      set -l secrets_names (echo $secrets_json | jq -r 'keys | .[]')
      for name in $secrets_names
        set -gx (echo $name | tr a-z A-Z)  (echo $secrets_json | jq -r .$name)
      end
  else
    chamber export --format=dotenv $service > .env.local
  end
end
