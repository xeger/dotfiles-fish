function cover
  ginkgo -r -randomizeAllSpecs -randomizeSuites -cover

  rm -f merged.coverprofile
  gocovmerge (find . -iname '*.coverprofile') > merged.coverprofile
  go tool cover -html=merged.coverprofile
end
