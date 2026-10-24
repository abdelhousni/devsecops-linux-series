#!/usr/bin/env bash
# ok and ko always succeed, so "test && ok || ko" never runs both.
# shellcheck disable=SC2015
# Reports what the examples need and whether this machine has it. Run it from
# anywhere, before the first run.sh. It changes nothing.
set -uo pipefail
cd "$(dirname "$0")" || exit 1
missing=0
ok() { printf '  ok       %s\n' "$1"; }
ko() { printf '  MISSING  %s: %s\n' "$1" "$2"; missing=1; }

echo "Tools:"
if command -v docker >/dev/null && docker info >/dev/null 2>&1; then
  ok "Docker Engine $(docker version --format '{{.Server.Version}}')"
else
  ko "Docker Engine, running" "install Docker Engine and start the daemon"
fi
for t in curl git sha256sum tar; do
  command -v $t >/dev/null && ok "$t" || ko "$t" "install your distribution's $t package"
done

echo "Images (run.sh pulls them if missing):"
while read -r i; do
  docker image inspect "$i" >/dev/null 2>&1 && ok "$i" || ko "$i" "docker pull $i"
done < <(grep -v '^#' images.txt | grep .)

echo "The book's lab archive (lab/fetch.sh unpacks it):"
branches=$(git -c safe.directory='*' -C book/fancymonitor branch --format='%(refname:short)' 2>/dev/null | wc -l)
[ "$branches" -eq 12 ] && ok "lab/book/fancymonitor, main and 11 feature branches" \
  || ko "lab/book/fancymonitor" "lab/fetch.sh"
exit "$missing"
