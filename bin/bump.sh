#!/usr/bin/env bash
# Update each formula to the latest GitHub release of its upstream repository.
# The script edits url and sha256 in place. It prints one "<formula> <version>"
# line for each changed formula. It skips deprecated and disabled formulas.
# It needs gh with GH_TOKEN, curl and sha256sum.
set -euo pipefail
cd "$(dirname "$0")/.."

for f in Formula/*.rb; do
  name=$(basename "$f" .rb)
  if grep -qE '^ *(deprecate|disable)!' "$f"; then
    continue
  fi
  url=$(sed -n 's/^  url "\(.*\)"$/\1/p' "$f")
  repo=$(echo "$url" | sed -n 's#^https://github.com/\([^/]*/[^/]*\)/archive/refs/tags/.*\.tar\.gz$#\1#p')
  tag=$(echo "$url" | sed -n 's#^.*/archive/refs/tags/\(.*\)\.tar\.gz$#\1#p')
  if [ -z "$repo" ]; then
    echo "$name: skipped, url is not a GitHub tag tarball" >&2
    continue
  fi

  latest=$(gh api "repos/$repo/releases/latest" --jq .tag_name)
  # Bump only to a newer tag, never back to an older one.
  if [ "$latest" = "$tag" ] || [ "$(printf '%s\n%s\n' "$tag" "$latest" | sort -V | tail -n1)" != "$latest" ]; then
    continue
  fi

  new_url="https://github.com/$repo/archive/refs/tags/$latest.tar.gz"
  sha=$(curl -fsSL "$new_url" | sha256sum | cut -d' ' -f1)
  sed -i "s|^  url \".*\"$|  url \"$new_url\"|; s|^  sha256 \".*\"$|  sha256 \"$sha\"|" "$f"
  echo "$name ${latest#v}"
done
