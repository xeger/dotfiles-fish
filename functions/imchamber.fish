function imchamber
  argparse --name=imchamber 'h/help' 'f/file' -- $argv 2> /dev/null
  or set _flag_h 1

  set -l argcount (count $argv)
  set -l legacy_format false
  set -l services ""

  if test $argcount -eq 0; and test -f .chamberrc
    set services (cat .chamberrc)
  else if test $argcount -eq 0; and test -f .chamber
    set legacy_format true
    set services (cat .chamber)
  else if test $argcount -gt 0
    for service in $argv
      set -a services "env $service"
    end
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

  if test $legacy_format = true
    echo "imchamber: using legacy .chamber file"
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
  else
    for cmd in $services
      echo "imchamber: $cmd"
      if string match -qr '^env' $cmd
        set -l cmd_suffix (string sub -s5 $cmd)
        set -l secrets_json (chamber export --format=json $cmd_suffix)
        set -l secrets_names (echo $secrets_json | jq -r 'keys | .[]')
        for name in $secrets_names
          set -gx (echo $name | tr a-z A-Z)  (echo $secrets_json | jq -r .$name)
        end
      else
        set -l entire_cmd "chamber $cmd"
        eval $entire_cmd
      end
    end
  end
end
