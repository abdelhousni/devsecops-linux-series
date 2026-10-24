#!/usr/bin/env bash
# Gets the book's lab archive, checks it, and unpacks it into lab/book/.
# The archive is the book's material, so this repository doesn't carry it:
# it comes from the Apress release, or from a copy you already downloaded.
#   lab/fetch.sh                      download it from the release
#   lab/fetch.sh ~/devsecops-pillars.tar.gz   use a local copy
set -euo pipefail
cd "$(dirname "$0")"
url=https://github.com/user-attachments/files/29066084/devsecops-pillars.tar.gz
sha256=9d7f3adac681b3048b2e1b75a8d641759d912f0f704bb2edf2cfbc60013bfb34

archive=${1:-devsecops-pillars.tar.gz}
if [ ! -f "$archive" ]; then
  echo "Downloading $url"
  curl -fsSL -o "$archive" "$url"
fi
echo "$sha256  $archive" | sha256sum -c --quiet - || {
  echo "$archive is not the archive this repository was tested with" >&2
  exit 1
}
# Refuse absolute paths and .. before unpacking anything.
if tar tzf "$archive" | grep -qE '^/|(^|/)\.\.(/|$)'; then
  echo "$archive has unsafe paths" >&2
  exit 1
fi
rm -rf book
mkdir book
tar xzf "$archive" -C book --no-same-owner 2>/dev/null
git -c safe.directory='*' -C book/fancymonitor branch --format='%(refname:short)' | wc -l \
  | xargs printf 'Unpacked into lab/book/: fancymonitor with %s branches\n'
