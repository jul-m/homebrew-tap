# step-kms-plugin Homebrew Formula
#
# Installs the step-kms-plugin binary (KMS plugin for the step CLI).
# Source: https://github.com/smallstep/step-kms-plugin
#
class StepKmsPlugin < Formula
  desc "Plugin for the step CLI to use cloud KMS and hardware keys"
  homepage "https://github.com/smallstep/step-kms-plugin"
  version "0.17.0"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/smallstep/step-kms-plugin/releases/download/v0.17.0/step-kms-plugin_0.17.0_darwin_amd64.tar.gz"
      sha256 "a53d782bd34c540789a263aad64c032e28cc38763d314e43953760578384aefe"
    end
    on_arm do
      url "https://github.com/smallstep/step-kms-plugin/releases/download/v0.17.0/step-kms-plugin_0.17.0_darwin_arm64.tar.gz"
      sha256 "31611a54fb92c7c092e3ac19295c3911e5c2bbebbf5f6405f2eb3fcbeff6b643"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/smallstep/step-kms-plugin/releases/download/v0.17.0/step-kms-plugin_0.17.0_linux_amd64.tar.gz"
      sha256 "dd4df0ceabeaa59c4375bf11df51b59688635076ae1e5c463618c7d43fcbe7b3"
    end
    on_arm do
      url "https://github.com/smallstep/step-kms-plugin/releases/download/v0.17.0/step-kms-plugin_0.17.0_linux_arm64.tar.gz"
      sha256 "d6a6e1b50ce8a569606cd1f33c48c67a13d5dddaddb578989fd70a3540d8ebf0"
    end
  end

  def install
    bin.install "step-kms-plugin"
    bash_completion.install "completions/bash_completion" => "step-kms-plugin"
    zsh_completion.install "completions/zsh_completion" => "_step-kms-plugin"
    fish_completion.install "completions/fish_completion" => "step-kms-plugin.fish"
    pwsh_completion.install "completions/powershell_completion" => "_step-kms-plugin.ps1"
  end

  test do
    system bin/"step-kms-plugin", "--help"
  end
end
