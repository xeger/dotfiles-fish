function imbless
  set -l service $argv[1]
  if test -z "$service"; and test -f .chamber
    set service (cat .chamber)
  end

  if test -z "$service"
    echo "Usage: imbless <service_name>"
    echo "  - or, write .chamber to PWD containing service name"
    return 1
  end

  chamber export --format=dotenv $service > .env.local
end
