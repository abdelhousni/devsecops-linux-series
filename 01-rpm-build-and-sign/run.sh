#!/usr/bin/env bash
# Builds, signs and installs fancymonitor's RPMs in Oracle Linux 9 with the
# book's Makefiles. Needs lab/fetch.sh first.
set -euo pipefail
cd "$(dirname "$0")"
# shellcheck source=SCRIPTDIR/../lab/container.sh
. ../lab/container.sh
lab_run docker.io/library/oraclelinux:9 in-container.sh
