# Working in devsecops-linux-series

Companion examples for the DevSecOps for Linux (Carcano) series on
til.housni.eu (abdelhousni/til). The plan and state of the series are in
abdelhousni/til-workbench `devsecops-linux/README.md` (private) and Linear
project P-ABD-10.

- Never commit the book's code, archive or chapter files: `lab/fetch.sh`
  gets them into `lab/book/`, which is ignored. Their licence isn't settled
  (see the README), and the owner chose not to redistribute them.
- Each example is `NN-name/` with a `run.sh`, an `expected.txt`, a README,
  a row in the root README table and rows in `INDEX.md` for each technique
  and pitfall it shows. CI fails if an example directory has no row in
  `INDEX.md`.
- An example that needs a new tool or image adds it to the README's "Local
  lab" table, to `lab/images.txt` if it's an image, and to `lab/check.sh`
  in the same pull request.
- Before opening a pull request, from a fresh clone: `lab/fetch.sh`, then
  `lab/check.sh` passes and every `run.sh` matches its `expected.txt`.
- Deterministic output only: no timestamps, durations, key IDs or
  host-specific values in `expected.txt`.
- Never commit a secret. Signing keys are generated inside the container
  and thrown away with it.

## Commits

Commits are authored by the repository owner: check
`git var GIT_AUTHOR_IDENT` before the first commit and expect
`abdelhousni <23284113+abdelhousni@users.noreply.github.com>`. Credit Claude
only with a `Co-Authored-By` trailer, and don't add a `Claude-Session:`
trailer. Commit messages follow Conventional Commits, with the example
directory or `lab` as the scope.
