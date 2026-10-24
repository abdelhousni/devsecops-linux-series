#!/usr/bin/env bash
# Sourced by run.sh. lab_run IMAGE SCRIPT runs SCRIPT in IMAGE with the
# book's fancymonitor mounted read-only at /book. Behind an HTTPS proxy
# (HTTPS_PROXY set), the container shares the host network and gets the
# proxy settings; a CA bundle in LAB_CA_BUNDLE is installed in it first.
lab_run() {
  local image=$1 script=$2 dir lab
  dir=$(cd "$(dirname "$script")" && pwd)
  lab=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
  local args=(--rm -v "$lab/book/fancymonitor:/book:ro" -v "$dir:/example:ro")
  if [ -n "${HTTPS_PROXY:-}" ]; then
    args+=(--network host -e HTTPS_PROXY -e HTTP_PROXY -e NO_PROXY
      -e "https_proxy=$HTTPS_PROXY" -e "http_proxy=${HTTP_PROXY:-}")
  fi
  if [ -n "${LAB_CA_BUNDLE:-}" ]; then
    args+=(-v "$LAB_CA_BUNDLE:/lab-ca.crt:ro")
  fi
  docker run "${args[@]}" "$image" bash "/example/$(basename "$script")"
}
