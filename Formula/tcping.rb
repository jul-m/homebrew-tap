# frozen_string_literal: true

# tcping Homebrew Formula
#
# Installs the tcping command for macOS, written in Objective-C.
# Source: https://github.com/paradiseduo/tcping
#
class Tcping < Formula
  desc 'tcping command, written with Objective-C, on macOS, ping over a tcp connection'
  homepage 'https://github.com/paradiseduo/tcping'
  url 'https://github.com/paradiseduo/tcping/releases/download/3.7/tcping.zip'
  sha256 'ecc2c87539379b94edd9ebaaf60bba8ef04276842594f88d7436287f6f394d28'
  version '3.7'
  license 'MIT'
  conflicts_with 'tcping', because: 'same executable name'

  def install
    bin.install 'tcping'
  end

  test do
    system "#{bin}/tcping", '--help'
  end
end
