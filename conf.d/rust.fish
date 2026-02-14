# shrink rust installs with `asdf install rust` (and similar commands)
set -x RUST_WITHOUT "rust-docs"

if test -f "$HOME/.cargo/env.fish"
  source "$HOME/.cargo/env.fish"
else if test -d ~/.cargo/bin
  set -x PATH $PATH ~/.cargo/bin
end
