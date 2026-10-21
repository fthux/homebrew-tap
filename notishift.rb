class Notishift < Formula
  desc "Native macOS menu bar app for repositioning notification banners"
  homepage "https://github.com/fthux/NotiShift"
  url "https://github.com/fthux/NotiShift/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e683ce68ad5f6d3393751222ba285ef2eef5b90c2f260cf239be8c5aa20c8c14"
  license "AGPL-3.0-or-later"

  depends_on :macos

  def install
    system "make", "build"

    libexec.install "dist/Noti Shift.app"

    (bin/"notishift").write <<~SH
      #!/bin/sh
      exec /usr/bin/open "#{libexec}/Noti Shift.app"
    SH
  end

  def caveats
    <<~EOS
      Run Noti Shift with:
        notishift

      On first launch, Noti Shift may ask to move itself to /Applications.
      You still need to grant Accessibility permission in System Settings.
    EOS
  end

  test do
    assert_path_exists libexec/"Noti Shift.app"
    assert_path_exists libexec/"Noti Shift.app/Contents/MacOS/NotiShift"
  end
end
