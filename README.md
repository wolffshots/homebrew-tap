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
