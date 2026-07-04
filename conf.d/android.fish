set -l _android_sdk_roots /opt/homebrew/share/android-commandlinetools /usr/local/share/android-commandlinetools ~/Library/Android/sdk

for _root in $_android_sdk_roots
  if test -d $_root
    set -gx ANDROID_HOME $_root
    set -gx ANDROID_SDK_ROOT $_root
    fish_add_path --path $ANDROID_HOME/platform-tools
    fish_add_path --path $ANDROID_HOME/cmdline-tools/latest/bin
    break
  end
end

set -e _android_sdk_roots
set -e _root
