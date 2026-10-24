#!/usr/bin/env bash
# Runs inside Oracle Linux 9: the book's make targets, from fancymonitor's
# main branch, as far as a signed RPM installed with dnf.
set -euo pipefail
if [ -f /lab-ca.crt ]; then
  cp /lab-ca.crt /etc/pki/ca-trust/source/anchors/ && update-ca-trust
fi
# python3-wheel is in CodeReady Builder, not BaseOS or AppStream.
dnf -q -y --enablerepo=ol9_codeready_builder install \
  git make rpm-build rpm-sign gnupg2 python3-pip python3-setuptools \
  python3-wheel python3-lxml python3-pyyaml python3-pytest >/dev/null 2>&1
pip3 -q install build==1.2.2.post1 >/dev/null 2>&1

git -c safe.directory='*' clone -q /book /work
cd /work
export RELEASE=0.0.1

echo "== make test"
make -C src test 2>&1 | grep -E '^=+ .*(passed|failed)' | sed -E 's/ in [0-9.]+s / /'

echo "== make rpm"
make rpm >/dev/null 2>&1
find ~/rpmbuild/RPMS ~/rpmbuild/SRPMS -name '*.rpm' -printf '%f\n' | sort

echo "== make sign"
# A throwaway key without a passphrase, under the name the Makefile expects.
gpg --batch --quiet --passphrase '' --quick-gen-key build@carcano.corp rsa3072 sign 1d 2>/dev/null
make sign >/dev/null 2>&1
gpg --armor --export build@carcano.corp > /tmp/build.asc
rpm --import /tmp/build.asc
find ~/rpmbuild/RPMS ~/rpmbuild/SRPMS -name '*.rpm' | sort | while read -r f; do
  rpm -K "$f" | sed 's|.*/||'
done

echo "== dnf install"
dnf -q -y install ~/rpmbuild/RPMS/noarch/*.rpm >/dev/null 2>&1
rpm -qa --qf '%{NAME}-%{VERSION}-%{RELEASE}\n' '*fancymonitor*' | sort
rpm -ql carcano-fancymonitor
