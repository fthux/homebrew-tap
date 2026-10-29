# Select with HOMEBREW_TICKREST_DEV_ARCH=universal|arm|intel (default: universal).
cask "tickrest-dev" do
  selected_arch = ENV.fetch("HOMEBREW_TICKREST_DEV_ARCH", "universal")
  selected_arch = { "arm" => "arm64", "intel" => "x86_64" }.fetch(selected_arch, selected_arch)
  variants = {
    "universal" => [
      "https://github.com/fthux/tick-rest-macos-dev/releases/download/v1.0.1/TickRest-dev-1.0.1-1-universal.zip",
      "64543fa150fd5da631126133a04f9a1d1ef7fe4138f4718acf5a811b4334461f",
    ],
    "arm64"     => [
      "https://github.com/fthux/tick-rest-macos-dev/releases/download/v1.0.1/TickRest-dev-1.0.1-1-arm64.zip",
      "922ee64dc11c3a3b5a8717b66ba719c06e309daad017a5b306bf3daf401bed33",
    ],
    "x86_64"    => [
      "https://github.com/fthux/tick-rest-macos-dev/releases/download/v1.0.1/TickRest-dev-1.0.1-1-x86_64.zip",
      "492b2db052956b4be18265bb1ef76bc4cea1949a2b3d53c0520f4a84fae6b408",
    ],
  }
  unless variants.key?(selected_arch)
    raise ArgumentError, "HOMEBREW_TICKREST_DEV_ARCH must be universal, arm/arm64 or intel/x86_64"
  end

  download_url, checksum = variants.fetch(selected_arch)

  version "1.0.1,1"
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
