# What Pre-commit Is

You are about to commit a change. The
change is good, but the files carry the
usual small litter: a line ending in
stray spaces, a text file with no
newline at the end, a configuration file
you edited in a hurry and never
re-read. None of it matters today. All
of it matters in six months, when a diff
is noisy, a parser chokes, or a
colleague wonders which change was real.
**Pre-commit is a program that checks
for that litter at the moment of the
commit, every time, so you do not have
to remember to.**

Git itself offers the hook point: a
script named `pre-commit` inside
`.git/hooks/` runs just before each
commit is recorded, and if it exits
with an error, the commit stops.
Hand-writing that script is possible
and people did it for years. What they
got was a private script, in a folder
git never shares, that every new clone
of the repository lacked. Pre-commit —
the framework, at
[pre-commit.com](https://pre-commit.com)
— exists to fix exactly those three
weaknesses. It keeps the list of checks
in a file that lives *in* the
repository, `.pre-commit-config.yaml`,
fetches the checks from published
collections, builds whatever each check
needs to run, and installs git's hook
for you. Clone the repository, run one
command, and the checks are armed.

Each individual check is a **hook**: a
small program with one job. Some hooks
**check** — they read files and report
problems, changing nothing. Some hooks
**fix** — they rewrite the file into
the shape it should have been, and
report that they did. Chapter 4 shows
both kinds in one commit.

## Why anyone would do this

Four honest reasons account for nearly
every use:

- **Memory, outsourced.** The check
  runs because the commit ran. It does
  not depend on you remembering a style
  rule at 11 pm before a deadline.
- **Feedback at the cheapest moment.**
  A missing newline is a two-second fix
  while the file is open in front of
  you. Found in review, or in CI after
  a push, it costs a round trip and
  everyone's attention.
- **One list for the whole team.** The
  config file is committed like any
  other file. When it changes, everyone
  who pulls gets the new checks; the
  argument about which checks is held
  once, in the open, in a pull request.
- **The fix is done for you.** Half
  the value is in the fixer hooks: they
  do not scold you about trailing
  whitespace, they remove it, and all
  that is left for you is to stage the
  repaired file and commit again.

## The rule, stated before everything else

A hook is a program, and pre-commit
downloads hook programs from the
internet and runs them with your
account's full permissions, on every
commit. That is a great deal of trust
to hand a stranger's repository. So
this guide has one rule, and it is not
fine print:

> **Add only hooks from sources you
> have read and trust — a hook runs on
> your machine, as you, the moment you
> commit.**

Reading a hook collection before you
adopt it does not mean auditing every
line like a security review. It means
knowing whose it is (the framework's
own `pre-commit-hooks` collection is
the usual starting point), preferring
collections that are widely used and
actively kept, pinning their revisions
(chapter 8), and being suspicious of a
configuration file that arrives from
nowhere asking you to install a dozen
unfamiliar hooks at once. Chapter 11
returns to the trust question in full,
including the sharp case: a malicious
or careless hook can do anything your
account can do, and pre-commit has no
sandbox to stop it. The lab in this
guide used the framework's own
collection and one hook it wrote
itself, printed in full in chapter 7.

## A familiar shape

Pre-commit has a small cast, and
chapter 2 introduces it properly: the
**config file** in your repository, the
**hook repositories** it points at
(ordinary git repositories full of
hooks), the **environments** pre-commit
builds so each hook's own language and
libraries are present, **git's hook**
itself (one small generated script),
and a **cache** in your home folder
where the built environments wait to be
reused.

A first taste, after installing
(chapter 3):

```bash
pre-commit sample-config > .pre-commit-config.yaml
pre-commit install
git commit -m "Tidy the workshop notes"
```

The first command writes a starter
config — chapter 3 shows its output.
The second arms git's hook. From then
on, every commit runs the list.

Check: the starter config already names
the hooks this guide spends chapter 4
on — `trailing-whitespace`,
`end-of-file-fixer` and `check-yaml`
all appear in `sample-config`'s output,
because they are the checks nearly
every repository wants.

## Who it is for

The solo programmer tired of their own
litter. The small team whose reviews
keep drowning in whitespace diffs. The
maintainer who wants "please run the
checks" to be a machine's sentence, not
theirs. The common thread is a
repository, a list of small promises
about its files, and a wish that the
promises kept themselves.

## What it is not

Pre-commit is not a security boundary:
`git commit --no-verify` walks straight
around it, by design, and chapter 11 is
plain about when that matters. It is
not a test suite: it looks at files,
not behaviour, and a commit can pass
every hook and still be wrong in every
way that counts. It is not a formatter
or a linter itself: it is the
stage manager that fetches them, builds
them and runs them in order. And it is
not a substitute for CI — it is CI's
cheerful first draft, running early on
one machine; the same checks deserve a
second, unbypassable run on the server,
which chapter 8 describes.
