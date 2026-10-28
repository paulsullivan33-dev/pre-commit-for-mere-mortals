# Keeping Hooks Current

By the end of this chapter your pinned
hook revisions can be brought current
with one command — deliberately, in a
commit you review — and you know the
two safety nets that catch what local
hooks cannot: the same checks running
in CI, and a hosted service that does
the updating for you. The lab verified
the command; the nets are described
from their documentation, and labelled
as such.

## Why pins, and why they go stale

Chapter 2 introduced the `rev` pin: the
exact revision of each hook repository
that your config fetches. Pins are what
make your checks repeatable — the same
hook code on your machine, a
colleague's, and the CI server — and
they freeze you, deliberately, at the
day you pinned. Hook collections keep
moving: bugs are fixed, checkers learn
new rules, occasionally a hook's
behaviour changes enough to matter. A
pin is therefore a decision you revisit
on purpose, rather than a state you
drift in by accident.

## autoupdate: the deliberate revisit

```bash
pre-commit autoupdate
```

Pre-commit visits each repository in
your config, finds its newest release
tag, and rewrites the `rev` lines to
match. The lab ran it in a scratch
repository pinned to an older release
of the standard collection (transcript
`pre-commit-lab/transcripts/t07-autoupdate.txt`):

```text
$ grep rev: .pre-commit-config.yaml
    rev: v4.5.0

$ pre-commit autoupdate
[https://github.com/pre-commit/pre-commit-hooks] updating v4.5.0 -> v6.0.0
(exit code: 0)

$ grep rev: .pre-commit-config.yaml
    rev: v6.0.0
```

Three habits make this command a
servant rather than a surprise:

- **Run it yourself, on a branch, and
  read the diff.** The update is an
  ordinary edit to one file. Review it
  like one.
- **Follow it immediately with
  `pre-commit run --all-files`.** New
  hook versions may object to files the
  old ones accepted. Meeting those
  objections in the update commit — not
  scattered through the week's real
  work — is the entire point of doing
  updates deliberately.
- **Commit the update on its own.** A
  config-only commit that says "update
  hooks" is easy to revert whole if the
  new version misbehaves, which a
  mixed commit never is.

Options exist for the cautious:
`--bleeding-edge` takes the very latest
commit instead of the newest tag, and
`--freeze` replaces a tag with the
exact commit hash it points at, for
projects that want their pins to be
unmovable even in principle. The lab
used neither; the defaults are the
common path.

## The net that cannot be bypassed: CI

Everything so far runs on the
committer's machine, at the committer's
mercy — and chapter 11 will show the
one flag that skips it all. The server
side of the story is to run the same
config where no one can opt out: your
continuous integration system executes
`pre-commit run --all-files` on every
proposed change, and the change does
not land while the run is red. The
config file is the same; the verdict
is suddenly enforceable. A GitHub
Actions version looks like this — given
from the project's documentation, not
run by the lab, and labelled as such
wherever this guide shows it:

```yaml
- uses: actions/checkout@v4
- uses: actions/setup-python@v5
- uses: pre-commit/action@v3.0.1
```

That official action is a thin wrapper
around installing pre-commit and
running exactly the command of
chapter 5. (The *GitHub Actions for
Mere Mortals* guide in this series
covers the surrounding machinery: what
a workflow is, when it runs, and how
its verdict guards a branch.) The
division of labour to aim for: local
hooks for speed and kindness — the
author hears first, in seconds — and
CI for authority.

## The hosted option: pre-commit.ci

For projects hosted on GitHub, the
pre-commit project also runs a hosted
service, **pre-commit.ci**, described
here from its documentation and not
run by the lab. Connected to a
repository, it runs the hooks on every
pull request, can push the fixers'
repairs back as a commit of its own
("auto-fixes"), and opens update pull
requests on a schedule — `autoupdate`
as a standing appointment rather than
a remembered chore. It answers the two
chores of this chapter, at the price of
giving a service write access to your
repository: a trust decision in the
same family as chapter 1's rule, to be
made with open eyes and the service's
own documentation in hand.

## What "current" is worth

A closing calibration. Hook updates
are housekeeping, not progress: a
project with year-old pins and checks
that run is in far better shape than a
project with this week's pins and a
team trained to bypass them. Update on
a rhythm you can keep — the lab's
suggestion is with other routine
maintenance, in its own commit, with
chapter 5's full run straight after —
and let the pins do their quiet work
in between.

Check: in a scratch copy of your
config, `pre-commit autoupdate` should
rewrite a `rev` and report the move,
and `pre-commit run --all-files`
afterwards should tell you what the new
versions think of your tree. Chapter 9
collects the patterns worth copying.
