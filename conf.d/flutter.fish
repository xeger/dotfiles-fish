if test -d ~/.local/flutter/bin
  fish_add_path --path ~/.local/flutter/bin
end

# Chrome for `flutter run -d chrome` (no stable Chrome installed; use Canary).
set -l _chrome_canary "/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary"
if test -x "$_chrome_canary"
  set -gx CHROME_EXECUTABLE "$_chrome_canary"
end
