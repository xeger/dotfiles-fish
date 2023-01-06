function imchamber__pwd --on-variable=PWD
  if test -f .chamberrc
    imchamber
  end
end
