class Fftui < Formula
  desc "Terminal UI for tracking Future Forex arbitrage cycle returns"
  homepage "https://github.com/wolffshots/fftui"
  url "https://github.com/wolffshots/fftui/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "038226f98faa2c671b0b6c3e11e329ccffce221026d59f70e6db98e4bbf9e7b1"
  # Upstream ships no LICENSE file, so no `license` field is set.
  head "https://github.com/wolffshots/fftui.git", branch: "main"

  depends_on "go" => :build

  def install
    # Match the upstream release build: strip symbols/DWARF and inject the
    # version (upstream tags with a leading "v", e.g. v0.5.0).
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    # `--version` prints "fftui v<version>" and exits 0 without needing any
    # FF_* config or network access, so it is safe as a smoke test.
    assert_match "fftui v#{version}", shell_output("#{bin}/fftui --version")
  end
end
