class Fftui < Formula
  desc "Terminal UI for tracking Future Forex arbitrage cycle returns"
  homepage "https://github.com/wolffshots/fftui"
  url "https://github.com/wolffshots/fftui/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "d9e328722fbc2f4133fb6a20d210d71283bfc7f18b91b2480f192e99d3c449db"
  license "MIT"
  head "https://github.com/wolffshots/fftui.git", branch: "main"

  depends_on "go" => :build

  def install
    # Match the upstream release build: strip symbols/DWARF and inject the
    # version (upstream tags with a leading "v", e.g. v0.5.0).
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      Create your config file (~/.config/fftui/config.env) with:
        fftui --init-config
      Then edit it with your credentials. See the README for all keys:
        https://github.com/wolffshots/fftui#credentials
    EOS
  end

  test do
    # `--version` prints "fftui v<version>" and exits 0 without needing any
    # FF_* config or network access, so it is safe as a smoke test.
    assert_match "fftui v#{version}", shell_output("#{bin}/fftui --version")

    # `--init-config` writes a template to $XDG_CONFIG_HOME/fftui/config.env
    # (0600). Point HOME/XDG_CONFIG_HOME at testpath so it stays sandboxed.
    ENV["HOME"] = testpath
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    system bin/"fftui", "--init-config"
    assert_path_exists testpath/".config/fftui/config.env"
  end
end
