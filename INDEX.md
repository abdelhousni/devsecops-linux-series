# Technique index

The [README](README.md) lists the examples by entry. This page lists them by
the problem they solve, so you can find "how do I…" without opening each
one. Every path is relative to the repository root.

## The lab

| To… | Use | Where |
|---|---|---|
| Use the book's code without redistributing it | download the release archive, check its SHA-256, refuse absolute and `..` paths, unpack into an ignored directory | `lab/fetch.sh` |
| Check the machine before running anything | `lab/check.sh` | `lab/check.sh` |
| Run a container behind an HTTPS proxy that re-signs TLS | `--network host`, the proxy variables, and the proxy's CA installed with `update-ca-trust` first | `lab/container.sh`, `01-rpm-build-and-sign/in-container.sh` |

## Packaging

| To… | Use | Where |
|---|---|---|
| Build an RPM from a Python project's sdist | `make rpm`: `python3 -m build --sdist`, then `rpmbuild -ba --define "_version ${RELEASE}"` | `01-rpm-build-and-sign/in-container.sh` |
| Install `python3-wheel` on EL9 | enable CodeReady Builder (`--enablerepo=ol9_codeready_builder` on Oracle Linux) | `01-rpm-build-and-sign/in-container.sh` |
| Sign RPMs without a prompt | `%_gpg_name` and `--pinentry-mode loopback` in `~/.rpmmacros`, then `rpm --addsign` (the book's `make sign`) | `01-rpm-build-and-sign/in-container.sh` |
| Create a signing key non-interactively | `gpg --batch --passphrase '' --quick-gen-key NAME rsa3072 sign 1d` | `01-rpm-build-and-sign/in-container.sh` |
| Check an RPM's signature | `rpm --import` the public key, then `rpm -K`: `digests signatures OK` | `01-rpm-build-and-sign/expected.txt` |

## Testing patterns

| To… | Use | Where |
|---|---|---|
| Compare pytest output across runs | keep the summary line and strip the ` in 0.22s` duration | `01-rpm-build-and-sign/in-container.sh` |
| Keep a run's output stable | sort file lists, print file names without paths, send installer output to `/dev/null` | `01-rpm-build-and-sign/in-container.sh` |

## Pitfalls

| Pitfall | What happens | Where |
|---|---|---|
| `pip3 install --root-user-action=ignore` on EL9 | OL9's pip 21.3.1 doesn't know the option and exits 2, before any output | `01-rpm-build-and-sign/in-container.sh` |
| `make release` (run by `make dist`) | rewrites the version in `src/pyproject.toml` in place, so the working tree changes; the example builds from a fresh clone | `01-rpm-build-and-sign/in-container.sh` |
