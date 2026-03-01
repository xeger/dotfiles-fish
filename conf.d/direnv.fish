if status --is-interactive; and which direnv > /dev/null 2> /dev/null
  direnv hook fish | source
end
