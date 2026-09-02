class Clusage < Formula
  desc "Terminal UI for watching Claude Code rate limit windows"
  homepage "https://github.com/wolffshots/clusage"
  url "https://github.com/wolffshots/clusage/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "3d97b91cef44ff37d0090907b0165dfdcabc54f13152c98163b49df175140b5f"
  license "MIT"
  head "https://github.com/wolffshots/clusage.git", branch: "main"

  depends_on "go" => :build

  def install
    # Match the upstream release build: strip symbols/DWARF and inject the
    # version (upstream tags with a leading "v", e.g. v0.3.0).
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # The Claude Code guard rail hook. Homebrew must not write to the user's
    # home directory, so `clusage hook install` registers this copy from here.
    # A `brew upgrade` replaces the file in place, and the path in
    # settings.json stays valid.
    pkgshare.install "hooks"
  end

  def caveats
    <<~EOS
      Store your Claude Code OAuth token in the login keychain with:
        clusage setup
      Then run `clusage` for the TUI, or `clusage usage` for one-shot output.

      On Linux, set CLAUDE_CODE_OAUTH_TOKEN instead: `clusage setup` uses the
      macOS `security` command.

      To pause Claude Code tool calls while your 5h limit is high, and stop
      them once a 7d limit is nearly spent, register the guard rail hook:
        clusage hook install
      Check it with `clusage hook status`, remove it with `clusage hook uninstall`.

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
    assert_match "unknown command",
                 shell_output("#{bin}/clusage definitely-not-a-command 2>&1", 1)

    # The guard rail script ships beside the binary, and the `hook` command
    # rejects an unknown action. Neither check runs the script or reads the
    # real settings.json, which the test sandbox blocks.
    assert_path_exists pkgshare/"hooks/clusage-guard.sh"
    assert_match "unknown hook action",
                 shell_output("#{bin}/clusage hook nope 2>&1", 1)
  end
end
