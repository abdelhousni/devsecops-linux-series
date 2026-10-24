# DevSecOps for Linux, applied

Companion examples for the TIL series on Marco Antonio Carcano's
*[DevSecOps and DevOps for Linux: The Foundations](https://link.springer.com/book/9798868820762)*
(Apress) at [til.housni.eu](https://til.housni.eu/). The series works
through the book and applies it to the tools we run: GitLab CE instead of
Gitea, Podman next to Docker, Artifactory next to Pulp 3.

This repository doesn't contain the book's code. The book's project,
*fancymonitor*, and its feature branches come from the lab archive that
Apress publishes with the
[book's companion repository](https://github.com/Apress/DevSecOps-for-Linux);
[`lab/fetch.sh`](lab/fetch.sh) downloads it, checks it and unpacks it into
`lab/book/`, which git ignores. Everything here runs against that copy.

[`INDEX.md`](INDEX.md) lists the examples by the problem they solve.

## Examples

| Example | Book | What it shows |
|---|---|---|
| [`01-rpm-build-and-sign`](01-rpm-build-and-sign/) | ch14–17, 22 | The book's `make test`, `make rpm` and `make sign` in an Oracle Linux 9 container, then `rpm -K` and `dnf install` |

Each example has a `run.sh` and an `expected.txt`; CI runs every `run.sh`
and fails if its output differs.

## Local lab

What the examples need, and how to set it up on your own machine. This is
the setup the examples were tested with, on 24 October 2026.

| What | Version tested | Needed by | How |
|---|---|---|---|
| Docker Engine | 29.9.2 | every example | your distribution's Docker Engine packages, daemon running |
| curl, git, sha256sum, tar | any recent | `lab/fetch.sh`, `lab/check.sh` | your distribution's packages |
| `docker.io/library/oraclelinux:9` | Oracle Linux 9.8, `sha256:09159fa3ed53…` | 01 | pulled by `docker run` |
| The book's lab archive | `devsecops-pillars.tar.gz`, SHA-256 `9d7f3adac681…13bfb34` | every example | `lab/fetch.sh` |

Inside the Oracle Linux 9.8 container, example 01 installs rpm-build and
rpm-sign 4.16.1.3, GnuPG 2.3.3, make 4.3, Python 3.9.25 with lxml 4.6.5,
PyYAML 5.4.1, pytest 6.2.2, setuptools 53.0.0 and wheel 0.36.2 from the
distribution, and `build` 1.2.2.post1 from PyPI. `python3-wheel` is in the
CodeReady Builder repository, which the example enables.

```sh
lab/fetch.sh                 # or: lab/fetch.sh ~/Downloads/devsecops-pillars.tar.gz
lab/check.sh
01-rpm-build-and-sign/run.sh | diff 01-rpm-build-and-sign/expected.txt -
```

- **The archive** is the one the book's latest release links to. `fetch.sh`
  refuses any other file, so an updated archive shows up as a checksum
  error rather than as different output.
- **Behind an HTTPS proxy**, set `HTTPS_PROXY` and the containers share the
  host network and get the proxy settings; set `LAB_CA_BUNDLE` to a CA
  file if the proxy re-signs TLS, and it's installed in the container
  first.
- **Signing uses a throwaway key** generated inside the container, under
  the name the book's Makefile expects (`build@carcano.corp`). It expires
  after a day and disappears with the container.

## Credit and licence

fancymonitor, its branches and the book's chapter files are Marco Antonio
Carcano's, published by Apress; get them from Apress. fancymonitor's
`pyproject.toml` and RPM spec declare LGPLv3+, the companion repository's
CONTRIBUTING.md mentions an MIT licence file that isn't there, and its
`licenses/` folder holds Apache-2.0 and GPL-2.0 texts. Because that isn't
settled, this repository doesn't redistribute any of it.
