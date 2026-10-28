# Limits

What pre-commit cannot do, and what it
must not be asked to do — the chapter
the rest of the guide has been
promising.

## One flag walks around it

`git commit --no-verify` skips git's
pre-commit hook entirely. Not a flaw in
pre-commit: a decision in git, older
than pre-commit, that the person at the
keyboard outranks their own machinery.
The lab demonstrated it on its own
repository (transcript
`pre-commit-lab/transcripts/t08-no-verify.txt`):
a line trailing spaces and a file
missing its final newline went straight
into history,

```text
$ git commit --no-verify -m "Add a spare stool (in a hurry)"
[main df64386] Add a spare stool (in a hurry)
```

with no hook output at all — and were
only caught afterwards, by running
`pre-commit run --all-files` over the
tree and committing the repair as a
second, sheepish commit. Two lessons
live there. The local hook is a
reminder with teeth, and the teeth are
yours; a project that needs the checks
to *hold* must run them again where the
committer cannot opt out — CI and
protected branches, chapters 8 and 10.
And the bypass is sometimes the right
call (a broken hook should not strand
an urgent fix), which is exactly why
its use should be rare, visible, and
followed by the clean-up run.

## It checks files, not truth

Hooks see the files being committed —
their bytes and their names — and
nothing else. They cannot know whether
the code works, whether the numbers in
the spreadsheet are right, whether the
sentence in the document is true. A
commit can pass every hook in this
guide and be wrong in every way that
matters; the hooks certify the
*shape* of the change, never its
*sense*. Testing, review, and thought
remain unautomated, and a green hook
run should never be quoted as if it
implied any of them.

Two consequences of "files only" are
worth naming. Hooks see the **staged**
snapshot, so a file half-edited in your
working tree is checked as staged, not
as it currently looks (chapter 5) — a
check can pass on a version you then
change before pushing. And checks that
depend on relationships *between*
files, or on the whole project building,
fit the model badly: they are slow, they
fail for reasons far from the change,
and they belong in pre-push or CI.

## A hook is a stranger's code

Chapter 1's rule returns here as a
limit, because it is one: pre-commit
has **no sandbox**. When a hook runs,
it runs as you, with your files, your
network, and your credentials in reach.
The framework's part of the bargain is
transparency — the config names every
repository it fetches, the revisions
are pinned, the code is there to read.
Your part is the reading, in proportion
to the trust: the framework's own
collection and the official collections
of tools you already use are one thing;
a config pasted from a stranger, or a
hook repository nobody seems to
maintain, is another. The sharp case is
the shared config itself: cloning a
repository and running `pre-commit
install` (or a helpful setup script
that does it for you) arms whatever
that repository's config points at.
Read the config of a freshly cloned
project before arming it, the way you
would read a script before running it —
because that is what it is.

## Slow hooks teach bypassing

The most practical limit is
behavioural. The commit path is the
most-touched doorway in a developer's
day, and every second a hook set spends
there is paid at every commit, by
every committer. A hook set that takes
a minute will be bypassed by Friday,
not out of malice but out of arithmetic
— and a bypassed check is worse than an
absent one, because the config still
*looks* like protection. The defences
are all in earlier chapters: keep the
commit set small and fast (chapter 9),
send slow checks to pre-push or CI
(chapters 5 and 8), and treat a
colleague's `--no-verify` as a bug
report about the hook set before
treating it as a character flaw.

## What it cannot see coming

Finally, the plain edges of the
mechanism. It guards commits, not other
doors: files that arrive by merge, by
a colleague's push, or by an editor
that writes straight to a shared tree
meet the checks only at CI. It speaks
for the machines that installed it —
a fresh clone is unguarded until
someone runs the one command of
chapter 4, which is why chapter 8's
server run is not optional decoration
for a team. And its verdicts are only
as good as the hooks: a formatter with
a bug will faithfully mangle, a checker
with a blind spot will faithfully pass,
and pre-commit will report both with
the same confident formatting. The
framework is a stage manager, not an
oracle — the quality on stage is still
the acts' own.
