set -l _jdk_homes /opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home /usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home

for _home in $_jdk_homes
  if test -d $_home
    set -gx JAVA_HOME $_home
    fish_add_path --path $JAVA_HOME/bin
    break
  end
end

set -e _jdk_homes
set -e _home

if test -d ~/java/apache-maven-3.9.2/bin
  fish_add_path --path ~/java/apache-maven-3.9.2/bin
end
