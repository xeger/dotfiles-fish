# CURRENTLY: watch dir for changes and then invoke a command (in a loop)
function watch
  while true
    echo "Invoke '$argv[2..-1]'' when changes occur in '$argv[1]'"
    fswatch -1 $argv[1]
    $argv[2..-1]
  end
end



# FORMERLY: watch a container's logs across restarts
# function watch
#   set -l subject $argv[1]

#   if test -f docker-compose.yml
#     while true
#       docker-compose logs -f $subject
#       if test $status -ne 0
#         break
#       end
#       echo "Recommence watching in 10 seconds..."
#       sleep 10
#     end
#   else if test -d $subject
#     echo "TODO: watching dirs is not implemented"
#   else
#     echo "watch: $subject is neither a directory nor a docker-compose service"
#   end
# end
