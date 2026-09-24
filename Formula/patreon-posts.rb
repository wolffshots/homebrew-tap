class PatreonPosts < Formula
  desc "Terminal UI for browsing Patreon posts and extracting YouTube links"
  homepage "https://github.com/wolffshots/patreon-posts"
  url "https://github.com/wolffshots/patreon-posts/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "be1a91ae8ae871d328d361a3e6e217cac12ec67bcc085a52805e1e2217e7b325"
  license "MIT"
  head "https://github.com/wolffshots/patreon-posts.git", branch: "main"

  depends_on "go" => :build

  def install
    # Match the upstream release build: strip symbols/DWARF and inject the
    # version (upstream tags with a leading "v", e.g. v0.1.1).
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      Create ~/.patreon-posts.json with your Patreon cookies and campaigns.
      To read the session from a Firefox-family browser on every run instead
      of pasting cookies, set "cookie_source". See:
        https://github.com/wolffshots/patreon-posts#configuration

      Then run `patreon-posts` for the TUI, or `patreon-posts --extract-links`
      to print YouTube links from every configured campaign.
    EOS
  end

  test do
    # `--version` prints "patreon-posts v<version>" and exits 0 without a
    # config, a database or network access, so it is safe as a smoke test.
    assert_match "patreon-posts v#{version}", shell_output("#{bin}/patreon-posts --version")

    # With no campaigns configured, `--extract-links` exits 1 before any
    # request. It has loaded the config and created the SQLite cache by then,
    # which exercises both without a TTY or network. HOME keeps it in testpath.
    ENV["HOME"] = testpath
    assert_match "no campaigns configured",
                 shell_output("#{bin}/patreon-posts --extract-links 2>&1", 1)
    assert_path_exists testpath/".patreon-posts.db"
  end
end
