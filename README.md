# homebrew-tap

A [Homebrew](https://brew.sh) tap for [wolffshots](https://github.com/wolffshots) tools.

## fftui

A terminal UI for tracking Future Forex arbitrage cycle returns.

### Install

```sh
brew install wolffshots/tap/fftui
```

Or tap first, then install:

```sh
brew tap wolffshots/tap
brew install fftui
```

The formula builds `fftui` from source at its tagged release, so it works on
**macOS** (Intel and Apple Silicon) and **Linux**. A Go toolchain is pulled in
automatically as a build-time dependency.

### Configuration

`fftui` is configured via `FF_*` environment variables (and command-line
flags). See the [fftui repository](https://github.com/wolffshots/fftui) for the
full configuration and usage documentation.

### Upgrade

```sh
brew update
brew upgrade fftui
```

Current release:
[![latest release](https://img.shields.io/github/v/release/wolffshots/fftui?label=latest)](https://github.com/wolffshots/fftui/releases/latest)

Since v0.13.0 the fixed per-cycle fee is dated to the Capitec SWIFT/admin fee
cut (R500 to R350) that takes effect on **1 October 2026**. Cycles starting on
or after that date model R380 per cycle instead of R530. Earlier cycles keep
the R530 they were billed.

## clusage

A terminal UI for watching Claude Code rate limit windows.

### Install

```sh
brew install wolffshots/tap/clusage
```

Or tap first, then install:

```sh
brew tap wolffshots/tap
brew install clusage
```

The formula builds `clusage` from source at its tagged release, so it works on
**macOS** (Intel and Apple Silicon) and **Linux**. A Go toolchain is pulled in
automatically as a build-time dependency.

### Configuration

Store your Claude Code OAuth token once with `clusage setup`, which writes it
to the login keychain. On Linux, set `CLAUDE_CODE_OAUTH_TOKEN` instead. Settings
live in `~/.config/clusage/config.json`. See the
[clusage repository](https://github.com/wolffshots/clusage) for the full
configuration and usage documentation.

### Upgrade

```sh
brew update
brew upgrade clusage
```
