class Coverfill < Formula
  desc "Make CrossPoint e-reader sleep covers fill the screen with mirrored edges"
  homepage "https://github.com/wolffshots/crosspoint-coverfill"
  url "https://github.com/wolffshots/crosspoint-coverfill/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "55743296b1b22dbc35998515dc816910d1d4c3b8cc9c0b45914e60108ec97e58"
  license "MIT"
  head "https://github.com/wolffshots/crosspoint-coverfill.git", branch: "main"

  depends_on "go" => :build

  def install
    # Match the upstream release build: strip symbols/DWARF and inject the
    # version (upstream tags with a leading "v", e.g. v0.1.0).
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      Start File Transfer on the e-reader, then do a dry run with the address it shows:
        coverfill -host <address> -n
    EOS
  end

  test do
    # `-version` prints "coverfill v<version>" and exits 0 without network access.
    assert_match "coverfill v#{version}", shell_output("#{bin}/coverfill -version")
  end
end
