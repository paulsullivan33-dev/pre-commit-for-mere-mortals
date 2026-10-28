# The Moving Parts

By the end of this chapter you can look
at any pre-commit setup and say which
part holds what: where the list of
checks lives, where the checks
themselves come from, what runs them,
and where their machinery is stored.
Five parts account for everything the
later chapters do.

## The config file

`.pre-commit-config.yaml` sits at the
top of your repository, committed like
any other file. It is a list of hook
repositories, and under each, the hooks
to take from it:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
```

Three facts in six lines. The
**repo** is an ordinary git repository
that publishes hooks. The **rev** pins
exactly which version of it you get — a
tag or a commit hash, never a moving
branch, so every machine runs the same
code (chapter 8 is about keeping that
pin current on purpose, not by
accident). The **id** names one hook
inside that repository, as declared in
the repository's own manifest file,
`.pre-commit-hooks.yaml`.

Because the config is committed, it
travels with the code: a new clone has
the list, though not yet the machinery
(chapter 12 covers the fresh-clone
trap). Because it is an ordinary file,
changing the project's checks is an
ordinary, reviewable edit.

## The hook repositories

A hook repository is just a git
repository whose manifest describes its
hooks: each hook's id, the command to
run, the language it is written in, and
which kinds of files it applies to. The
framework's own collection,
`pre-commit-hooks`, holds the generic
housekeeping checks this guide starts
with. Beyond it, most well-known
formatters and linters publish their
own hook repositories — that is how a
Python formatter, a shell script
checker or a Terraform tool all end up
in the same config file, each fetched
from its own home.

Chapter 1's rule applies with full
force here: a hook repository is code
you will run. Its address sits in your
config in plain sight; read what you
are pointing at.

## The environments

Hooks are written in many languages,
and your machine may have none of the
right ones installed. Pre-commit's
answer is to build, for each hook
repository at a given revision, an
**environment**: a private little
installation — a Python virtual
environment, a Node package, a compiled
binary, as the hook's language requires
— kept out of your way and out of your
project. You never activate these
environments or tidy them by hand; they
are pre-commit's scaffolding.

The consequence a reader can feel: the
**first** run of a new hook is slow,
because the environment is being built,
and every run after is fast, because it
is reused. The lab's first commit shows
the building happening:

```text
[INFO] Initializing environment for https://github.com/pre-commit/pre-commit-hooks.
[INFO] Installing environment for https://github.com/pre-commit/pre-commit-hooks.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
```

That is transcript
`pre-commit-lab/transcripts/t01-first-commit-fails.txt`.
The same commit's hooks took seconds
once the environment existed (compare
`t02-second-commit-passes.txt`).

## Git's hook, and the installer

Git runs scripts it finds in
`.git/hooks/`. The one that matters
here is named `pre-commit`: git runs it
just before recording a commit, and a
non-zero exit stops the commit.
`pre-commit install` writes that script
for you — a small generated shim whose
whole job is to hand over to the real
pre-commit program. The lab's transcript
`t00-install-and-config.txt` shows the
confirmation:

```text
$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
```

Two things follow from the arrangement.
The shim lives in `.git/`, which git
never clones or shares — so installing
is a per-clone step, once per machine
per repository. And because git is the
one running it, anything git can be
talked out of, the hook can be talked
out of too: `git commit --no-verify`
skips `.git/hooks/pre-commit` entirely.
Chapter 11 takes that seriously.

## The cache

Built environments and fetched
repositories wait in a cache in your
home folder — `~/.cache/pre-commit` on
Linux — keyed by repository and
revision. It is why the second project
using the same hook collection starts
fast, and why `pre-commit gc` exists:
to clear out environments no config
points at any more. The cache is a
convenience, never evidence; deleting
it costs one slow run, nothing else.

## How a commit flows through the parts

Put together, one `git commit` does
this:

1. Git finishes staging and runs
   `.git/hooks/pre-commit`.
2. The shim starts pre-commit, which
   reads `.pre-commit-config.yaml`.
3. For each hook, in order, pre-commit
   works out which of the **staged**
   files the hook applies to, and runs
   it — from the cache, or after
   building what is missing.
4. Each hook answers: pass, fail, or
   "fail, and I changed the files".
5. Any failure stops the commit. Fixes
   a hook made sit in your working
   tree, waiting for you to stage them
   and commit again.

Step 3 hides the one behaviour that
surprises every newcomer: by default,
hooks see the staged snapshot of your
files, not whatever half-finished state
the working tree is in — and if you
have unstaged changes to the same file,
pre-commit stashes them away for the
run and restores them after. Chapter 5
unpacks what that means in practice.

Check: after reading this chapter, the
transcript `t01` should hold no
mysteries — the `[INFO]` lines are the
environments being built, the hook
lines are step 4's answers, and the
commit stopping is step 5.
