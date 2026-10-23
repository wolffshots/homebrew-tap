class Ndcli < Formula
  desc "Command-line client for the NoteDiscovery REST API"
  homepage "https://github.com/wolffshots/ndcli"
  url "https://github.com/wolffshots/ndcli/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "287cb8b4be67afe319f05fbb76ebda84be164f7c64d6db696bcd4415ba1b0662"
  license "MIT"
  head "https://github.com/wolffshots/ndcli.git", branch: "main"

  depends_on "go" => :build

  def install
    # Match the upstream release build: strip symbols/DWARF and inject the
    # version (upstream tags with a leading "v", e.g. v0.1.0).
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      Set NOTEDISCOVERY_URL to the base URL of your NoteDiscovery server.
      The default is http://localhost:8000. Then check the connection with:
        ndcli health
    EOS
  end

  test do
    # `--version` prints "ndcli v<version>" and exits 0 without network access.
    assert_match "ndcli v#{version}", shell_output("#{bin}/ndcli --version")
  end
end
