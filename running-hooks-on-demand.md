# Running Hooks on Demand

By the end of this chapter you can run
your checks whenever you like — not
only when a commit forces the question.
The command is `pre-commit run`, and
learning its three main shapes (the
staged files, the whole tree, one named
hook) is most of using pre-commit day
to day.

## Why run hooks without committing

Three everyday reasons. You are about
to commit and would rather meet the
failures now, in a command you chose,
than inside the commit itself. You have
just changed the config and want to
know what the new rules say about the
whole repository, including files
nobody has touched in a year. Or a
commit was forced through in a hurry —
chapter 11's `--no-verify` — and you
want to find out afterwards what it
smuggled in. All three are the same
command with different reach.

## The whole tree: --all-files

```bash
pre-commit run --all-files
```

Every hook runs against every file it
applies to, committed or not. The lab
ran it on the practice repository after
chapter 4's commits (transcript
`pre-commit-lab/transcripts/t04-run-on-demand.txt`):

```text
$ pre-commit run --all-files
trim trailing whitespace.................................................Passed
fix end of files.........................................................Passed
check yaml...............................................................Passed
(exit code: 0)
```

Two things to notice. Fixer hooks still
fix: a run that finds litter rewrites
the files in your working tree and
reports Failed, exactly as in a commit,
except nothing was being committed —
you simply have repairs to review, and
the exit code tells scripts and CI
systems (chapter 8) that the tree was
not clean. And a fully passing run
exits 0, which is what makes the same
command usable as a gate in automated
checks.

## One hook at a time

Name a hook's id to run only it:

```bash
pre-commit run trailing-whitespace --all-files
```

```text
$ pre-commit run trailing-whitespace --all-files
trim trailing whitespace.................................................Passed
```

Useful when one hook is the slow one,
the new one, or the one whose verdict
you are arguing with. Combined with a
file list instead of `--all-files` —
`pre-commit run check-yaml --files settings.yaml`
— it answers the narrow question "what
does this hook say about this file?"
without touching anything else.

## The default reach: staged files

With no reach named, `pre-commit run`
does what a commit would do: it runs
the hooks over your **staged** files.
That is the shape to reach for in the
middle of work — stage what you have,
run the checks, meet the failures,
stage the repairs — so the commit that
follows is a formality. It is worth
knowing that this is also the answer to
a common confusion: run with nothing
staged, and hooks report
`(no files to check) Skipped`, which is
not them ignoring you; it is them
truthfully reporting an empty desk.
The lab's transcripts show that line
wherever a hook's file types did not
match the files in a commit.

A related truth from chapter 2: during
a commit, hooks see the staged
snapshot. If the same file also has
unstaged edits, pre-commit puts the
unstaged part aside for the run and
restores it after, so a hook can never
"fix" work you had not offered it. When
a repair surprises you, this mechanism
— not the hook — is usually the author
of the surprise.

## Trying a hook before adopting it

Committing to a hook (forgive the pun)
is a config edit, and config edits
deserve a trial first. `pre-commit
try-repo` builds a hook collection from
a repository — or a folder on your own
disk — and runs it once, without
touching your config:

```bash
pre-commit try-repo https://github.com/pre-commit/pre-commit-hooks check-yaml --all-files
```

The lab did not need it (its hooks
came from the same collection it
adopted), so this command is given
from the project's documentation rather
than a transcript; the machinery it
exercises — fetch, build an
environment, run — is the one chapters
2 and 4 verified. Chapter 7 uses the
same try-it-first spirit on a hook
written at home.

## Stages, briefly

Git has more hook points than
`pre-commit`: there is also
`prepare-commit-msg`, `commit-msg`,
`post-commit`, and the server-flavoured
`pre-push`, among others. Pre-commit
can install and feed several of them —
`pre-commit install --install-hooks -t pre-push`
is the shape — and a hook can declare
which stages it belongs to. The two
that earn their keep most often are
**commit-msg** hooks, which check the
commit *message* (the only thing the
ordinary run never sees), and
**pre-push** hooks, the natural home
for checks too slow for every commit,
like a full test suite. This guide's
lab stayed at the default stage, and
says so; the mechanics of installing
another stage are the same `install`
command with different flags, described
in the project's documentation.

Check: in your practice repository,
`pre-commit run --all-files` passes
cleanly, and naming any single hook id
runs just that line. Chapter 6 turns
to the config itself: which files each
hook sees, and how to adjust its aim.
