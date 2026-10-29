# Select with HOMEBREW_TICKREST_DEV_ARCH=universal|arm|intel (default: universal).
cask "tickrest-dev" do
  selected_arch = ENV.fetch("HOMEBREW_TICKREST_DEV_ARCH", "universal")
  selected_arch = { "arm" => "arm64", "intel" => "x86_64" }.fetch(selected_arch, selected_arch)
  variants = {
    "universal" => [
      "https://github.com/fthux/tick-rest-macos-dev/releases/download/v1.0.0/TickRest-dev-1.0.0-1-universal.zip",
      "3c9e4fbb99d419f3db09629f7376fcfa5725e56652043f2e457e98312a5cd0a2",
    ],
    "arm64"     => [
      "https://github.com/fthux/tick-rest-macos-dev/releases/download/v1.0.0/TickRest-dev-1.0.0-1-arm64.zip",
      "9a7e53f29ed3b2ca45d9bc1db8fe8f7b6102beb6ad204536e257378fd050917e",
    ],
    "x86_64"    => [
      "https://github.com/fthux/tick-rest-macos-dev/releases/download/v1.0.0/TickRest-dev-1.0.0-1-x86_64.zip",
      "465b5429425ce14a56138334c957884682f175f458fa83fdba7f71633197d879",
    ],
  }
  unless variants.key?(selected_arch)
    raise ArgumentError, "HOMEBREW_TICKREST_DEV_ARCH must be universal, arm/arm64 or intel/x86_64"
  end

  download_url, checksum = variants.fetch(selected_arch)

  version "1.0.0,1"
  sha256 checksum

  url download_url
  name "Tick Rest Dev"
  desc "Menu bar app for regular eye and movement breaks"
  homepage "https://github.com/fthux/tick-rest-macos-dev"

  livecheck do
    skip "Development releases are updated manually after verifying all three release assets"
  end

  conflicts_with cask: "tickrest"
  depends_on macos: :ventura

  depends_on arch: :arm64 if selected_arch == "arm64"
  depends_on arch: :x86_64 if selected_arch == "x86_64"

  app "Tick Rest-#{selected_arch}.app", target: "Tick Rest.app"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Tick Rest.app"],
        writable_paths: ["Tick Rest.app"],
        writable_base:  :appdir
  end

  uninstall quit: "app.tickrest.desktop"
end
