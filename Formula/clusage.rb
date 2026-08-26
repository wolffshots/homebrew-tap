class Clusage < Formula
  desc "Terminal UI for watching Claude Code rate limit windows"
  homepage "https://github.com/wolffshots/clusage"
  url "https://github.com/wolffshots/clusage/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "57f3cacb9d68fd68009d9ff7fe4e9fab48f08dbf2c54c27ebf8d03b6f3817164"
  license "MIT"
  head "https://github.com/wolffshots/clusage.git", branch: "main"

  depends_on "go" => :build

  def install
    # Match the upstream release build: strip symbols/DWARF and inject the
    # version (upstream tags with a leading "v", e.g. v0.3.0).
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      Store your Claude Code OAuth token in the login keychain with:
        clusage setup
      Then run `clusage` for the TUI, or `clusage usage` for one-shot output.

      On Linux, set CLAUDE_CODE_OAUTH_TOKEN instead: `clusage setup` uses the
      macOS `security` command.

      Config lives at ~/.config/clusage/config.json. Set `fetch_cron` there to
      refresh automatically while the TUI is open. See:
        https://github.com/wolffshots/clusage#scheduled-fetches
    EOS
  end

  test do
    # `--version` prints "clusage v<version>" and exits 0 without needing a
    # token, a config file, or network access, so it is safe as a smoke test.
    assert_match "clusage v#{version}", shell_output("#{bin}/clusage --version")

    # An unknown command lists the real commands and exits 1. This exercises
    # the dispatch without opening the TUI, which needs a TTY the sandbox does
    # not have, and without `usage`, which would try to reach the API.
    assert_match "want: tui, setup, usage",
                 shell_output("#{bin}/clusage definitely-not-a-command 2>&1", 1)
  end
end
