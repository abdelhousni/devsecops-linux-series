# 01: build, sign and install fancymonitor's RPMs

The book builds fancymonitor up in chapters 14 to 17 and signs its packages
in chapter 22. This example runs those `make` targets from the book's
`main` branch in an Oracle Linux 9 container, the distribution the book's
Vagrantfile uses:

1. `make -C src test`: pytest on the XML, JSON and YAML loaders.
2. `make rpm` with `RELEASE=0.0.1`: an sdist, then `rpmbuild` with the
   spec that splits the project into a library package
   (`python3-carcano-fancymonitor`) and an application package
   (`carcano-fancymonitor`), plus a source package.
3. `make sign` with a throwaway GPG key, then `rpm -K` on each package.
4. `dnf install` of both binary packages, and the files the application
   package installs.

```sh
lab/fetch.sh
01-rpm-build-and-sign/run.sh | diff 01-rpm-build-and-sign/expected.txt -
```

The 4 xfailed tests are marked as expected failures: they load an XML
file whose XSD path doesn't exist, one that breaks its XSD, a malformed
one, and a YAML file with an out-of-range `trigger_every`, and loading
each one fails.

The book runs these steps on a Vagrant VM; here they run in a container.
