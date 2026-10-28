# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's traffic is the lab talking to itself.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** Chapter 11 names what the tool
   cannot do: hold against a committer who chooses the one-flag
   bypass, judge whether a change is right rather than merely
   tidy, run a hook's code inside any kind of sandbox, or stay
   fast enough to survive being allowed to grow slow — and the
   trust a shared config asks of everyone who clones it.
8. **The safety rule is in the text, early.** Chapter 1 and the
   README state the rule plainly — *a hook is code that runs
   on your machine the moment you commit: add only hooks from
   sources you have read and trust* — before any procedure
   depends on it, and later chapters point back to it where the
   tooling would make crossing the line easy.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is a 2-CPU, 7.7 GB Ubuntu 24.04 sandbox.
pre-commit **4.7.0** was installed with pip into a fresh virtual
environment (Python 3.12.3, git 2.43.0) and exercised against
a throwaway git repository created for this guide. All
transcripts live in `pre-commit-lab/transcripts/`; the lab's
finished practice files are `pre-commit-lab/fixture/`.

Run for real, with transcripts as evidence:

- Install and version; `pre-commit sample-config` printed and
  read; a hand-written config checked with
  `pre-commit validate-config` and armed with
  `pre-commit install` (t00).
- Hooks fetched from the genuine `pre-commit-hooks` repository
  at the pinned revision v5.0.0, environments built on first
  use (the `[INFO]` lines in t01).
- A commit that failed because two fixer hooks
  (trailing-whitespace, end-of-file-fixer) modified the file
  being committed; the repaired file staged and the same
  commit passing (t01, t02).
- A checker hook (check-yaml) refusing a malformed YAML file
  with the parser's own error, and passing after the fix
  (t03).
- `pre-commit run --all-files` over the whole tree, and a
  single named hook run on its own (t04).
- A local hook of the lab's own writing: a ten-line shell
  script wired in as `repo: local` with `language: system`,
  shown first failing on its own machinery files (they contain
  the marker it searches for), then corrected with one
  `exclude` line, then failing on a genuine marked file and
  passing the cleaned file (t05, t06).
- `pre-commit autoupdate` moving a scratch configuration's pin
  from v4.5.0 to v6.0.0 (t07).
- The limits chapter's bypass, run deliberately:
  `git commit --no-verify` committing a defective file with no
  hook output, the defect caught afterwards by
  `pre-commit run --all-files`, and the repair committed as a
  second commit (t08).

Documented only — described from the project's documentation,
not run, and the text does not claim otherwise:

- `pre-commit try-repo`, named in chapter 5: the fetch, build
  and run machinery it exercises is verified elsewhere; the
  command itself was not needed by the lab.
- Installing additional git hook stages (`pre-push`,
  `commit-msg`) and hooks that declare them; chapter 5
  describes them and stays at the default stage throughout.
- Hook collections other than `pre-commit-hooks`, and hooks
  for languages other than Python and shell — including the
  recipe in chapter 9 shown as a configuration pattern. The
  individual extra hook ids named in chapter 9 from the
  verified collection's own manifest were not each run.
- The GitHub Actions step in chapter 8 and the hosted
  pre-commit.ci service: the lab had one machine and no hosted
  repository to connect, so both are taught from their
  documentation.
- The comparison tools in chapter 10 are characterised, not
  benchmarked.
- Installing pre-commit by routes other than pip (system
  packages, pipx, Homebrew) is pointed to, not exercised; the
  pip route is the verified one.

Fixtures are this guide's own and deliberately generic: a
workshop shopping list, a two-line settings file, a draft
agenda, and a ten-line shell script, all invented for the
lab. No example is modelled on any real person, network,
service or organisation, and every repository the lab touched
was created by the lab for the purpose.
