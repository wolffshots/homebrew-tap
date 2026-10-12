class Himaplaya < Formula
  desc "Bubble Tea TUI for the himalaya mail client"
  homepage "https://github.com/wolffshots/himaplaya"
  url "https://github.com/wolffshots/himaplaya/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4c4a4fce9265a12ad1a6a2a30926bce174bbd3ccba3578954b055075d8cb5592"
  license "MIT"
  head "https://github.com/wolffshots/himaplaya.git", branch: "main"

  depends_on "go" => :build
  depends_on "himalaya"

  def install
    # Match the upstream release build: strip symbols/DWARF and inject the
    # version (upstream tags with a leading "v", e.g. v0.1.0).
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      himaplaya reads mail through himalaya, which needs a configured account.
      Set one up with:
        himalaya configure
      Then check that the account shows in:
        himalaya account list
    EOS
  end

  test do
    # `--version` prints "himaplaya v<version>" and exits 0 without a TTY,
    # a himalaya account or network access.
    assert_match "himaplaya v#{version}", shell_output("#{bin}/himaplaya --version")
  end
end
