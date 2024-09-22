function localdev
  set has_registry (ctlptl get registries --output template --template '{{len .items}}' --field-selector 'name==ctlptl-registry')
  set has_cluster (ctlptl get clusters --output template --template '{{len .items}}' --field-selector 'name==kind-kind')

  switch $argv[1]
    case 'up'
      if test $has_registry -eq 0
        ctlptl create registry ctlptl-registry --port=5005
      end
      if test $has_cluster -eq 0
        ctlptl create cluster kind --registry=ctlptl-registry
      end
      kubectl config use-context kind-kind
    case 'down'
      if test $has_registry -eq 1
        ctlptl delete registry ctlptl-registry
      end
      if test $has_cluster -eq 1
        ctlptl delete cluster kind-kind
      end
    case '*'
      echo "Usage: localdev up|down"
      return 1
  end
end
