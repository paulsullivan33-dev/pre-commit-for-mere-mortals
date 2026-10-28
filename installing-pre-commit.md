# Installing Pre-commit

By the end of this chapter pre-commit
is installed on your machine, the
install is proven with its own version
command, and you have seen the starter
configuration the tool writes for
itself. The next chapter puts that
configuration to work.

## What you need first

Two things: **git** (pre-commit is a
framework around git's hook points, and
it fetches hook repositories with git)
and, for the pip route below,
**Python 3** with pip. Most hook
collections need nothing else from you
— their own languages are pre-commit's
problem, handled by the environments of
chapter 2. A few hooks are exceptions
and say so in their own documentation;
chapter 6's "hooks that ask for more"
explains how that surfaces.

## The pip install

The route this guide's lab used, and
the one the project puts first:

```bash
pip install pre-commit
```

The lab installed into a fresh Python
virtual environment on a small Linux
machine, which keeps the tool's own
dependencies out of everything else on
the machine; installing into your usual
Python, with your system's package
manager, or with a tool like pipx or
Homebrew on macOS are all supported
neighbours of the same idea, described
in the project's documentation. The
result differs in where the program
lives, not in what it does.

Check the install with the version
command — the lab's transcript
`pre-commit-lab/transcripts/t00-install-and-config.txt`
opens with it:

```text
$ pre-commit --version
pre-commit 4.7.0
```

The exact number will differ; what
matters is that the command answers.
Every later chapter assumes this one
does.

## A starter config, written by the tool

Pre-commit will draft its own first
configuration. Run, in the top folder
of a git repository:

```bash
pre-commit sample-config
```

It prints a complete, working config to
the screen (the lab ran it and kept the
output):

```yaml
# See https://pre-commit.com for more information
# See https://pre-commit.com/hooks.html for more hooks
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v3.2.0
    hooks:
    -   id: trailing-whitespace
    -   id: end-of-file-fixer
    -   id: check-yaml
    -   id: check-added-large-files
```

Save it as the file
`.pre-commit-config.yaml`:

```bash
pre-commit sample-config > .pre-commit-config.yaml
```

Two observations worth making now.
First, the collection it points at is
`pre-commit-hooks`, the framework's own
repository of generic housekeeping
hooks — the most-read, most-used hook
source there is, and the one chapter 1's
rule would have you start with. Second,
the pinned `rev` in the sample is
whatever it was when your pre-commit
was released; chapter 8's `autoupdate`
brings such pins current deliberately.
The lab's own config (chapter 4) starts
from this sample, pins `v5.0.0`, and
keeps three of its four hooks.

## Checking a config before it runs

A config file with a typo in it fails
at the worst moment — mid-commit, with
an error about YAML you did not know
you had written. Pre-commit ships a
checker for the file itself:

```bash
pre-commit validate-config .pre-commit-config.yaml
```

The lab's transcript `t00` shows it
answering with silence, which for this
command is success: the config is
valid. Run it whenever you edit the
config by hand; chapter 12 lists the
confusing errors it saves you from.

## What you have not done yet

Installing pre-commit does not arm any
repository. Nothing runs at commit time
until, inside a specific repository,
two things exist: the config file, and
the one-time act of chapter 4's
`pre-commit install`, which writes
git's hook for that clone. This is
deliberate — a tool you installed for
one project must not silently supervise
every other repository on the machine —
and it is the whole explanation for
chapter 12's most common complaint,
"the hooks never run here".

Check: you should now be able to run
`pre-commit --version` and
`pre-commit sample-config` and get
answers like the lab's. Chapter 4
creates the practice repository, arms
it, and breaks a file in it on purpose.
