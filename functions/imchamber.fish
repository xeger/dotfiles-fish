function imchamber
  argparse --name=imchamber 'h/help' 'f/file' -- $argv 2> /dev/null
  or set _flag_h 1

  set -l argcount (count $argv)
  set -l services ""
  if test $argcount -eq 0; and test -f .chamber
    set services (cat .chamber)
  else if test $argcount -gt 0
    set services $argv
  end

  if test -n "$_flag_h"; or test -z "$services"
    echo "Usage: imchamber [--file] <service> [service2 ...]"
    echo "  - or, write .chamber to PWD containing service names, one per line"
    echo ""
    echo "Exports secrets from the designated chamber service(s) to your shell environment."
    echo ""
    echo "Flags:"
    echo "  file - overwrite .env.local with secrets"
    return 1
  end

  if test -n "$_flag_f"
    rm -f .env.local
    touch .env.local
  end

  for service in $services
    if test -n "$service"
      if test -n "$_flag_f"
        echo "imchamber: adding $service to your .env.local"
        chamber export --format=dotenv $service >> .env.local
      else
        echo "imchamber: exporting $service to your shell"
        set -l secrets_json (chamber export --format=json $service)
        set -l secrets_names (echo $secrets_json | jq -r 'keys | .[]')
        for name in $secrets_names
          set -gx (echo $name | tr a-z A-Z)  (echo $secrets_json | jq -r .$name)
        end
      end
    end
  end
end
