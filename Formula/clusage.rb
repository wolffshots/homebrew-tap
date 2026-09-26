class Clusage < Formula
  desc "Terminal UI for watching Claude Code rate limit windows"
  homepage "https://github.com/wolffshots/clusage"
  url "https://github.com/wolffshots/clusage/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "86197e3c0c104cbfdd56dd834c6dd017384faa3ac9e0ce589b603bb3d0144d93"
  license "MIT"
  head "https://github.com/wolffshots/clusage.git", branch: "main"

  depends_on "go" => :build

  def install
    # Match the upstream release build: strip symbols/DWARF and inject the
    # version (upstream tags with a leading "v", e.g. v0.3.0).
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # The legacy guard rail script. The hook now runs as `clusage hook run`,
    # and this wrapper keeps older settings.json entries working until the
    # user reruns `clusage hook install`.
    pkgshare.install "hooks"
  end

  def caveats
    <<~EOS
      clusage needs a source. Set "source" in ~/.config/clusage/config.json to
      statusline (recommended), usage, probe or auto. There is no default.

      Upgrading from 1.x: set "source" before anything else. Until it is set,
      `clusage usage` fails, and the guard rail hook denies every tool call.
      1.x always sent a probe call. Set "source": "probe" to keep that.

      For statusline, point the Claude Code status line at clusage:
        clusage help statusline
      For usage, probe or auto, log in with `claude`. clusage reads that login:
        clusage help setup

      Then run `clusage` for the TUI, or `clusage usage` for one-shot output.
      `clusage help` lists every command.

      To pause Claude Code tool calls while your 5h limit is high, and stop
      them once a 7d limit is nearly spent, register the guard rail hook:
        clusage hook install
      Check it with `clusage hook status`, remove it with `clusage hook uninstall`.
      Upgrading from 2.2 or older: rerun `clusage hook install`, so settings.json
      runs the binary and not the old script.

      Config lives at ~/.config/clusage/config.json. Set `fetch_cron` there to
      refresh automatically while the TUI is open. See:
        https://github.com/wolffshots/clusage#scheduled-fetches

      If a reading fails, run `clusage doctor` for a diagnosis with suggestions.
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

    # Help prints without a config, a token or a TTY.
    assert_match "Getting started", shell_output("#{bin}/clusage help")

    # The legacy wrapper script ships beside the binary, and the `hook` command
    # rejects an unknown action. Neither check runs the hook or reads the real
    # settings.json, which the test sandbox blocks.
    assert_path_exists pkgshare/"hooks/clusage-guard.sh"
    assert_match "unknown hook action",
                 shell_output("#{bin}/clusage hook nope 2>&1", 1)
  end
end
