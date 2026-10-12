class Himaplaya < Formula
  desc "Bubble Tea TUI for the himalaya mail client"
  homepage "https://github.com/wolffshots/himaplaya"
  url "https://github.com/wolffshots/himaplaya/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "6822cbe95fe699e52688571b0a283dbeaf4dfe935adcde2ab9a7b2c678de351d"
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
