# The Neighbours

Pre-commit is not the only way to make
checks run at commit time, and this
chapter is the honest comparison: what
each neighbour does, what it does that
pre-commit doesn't, and what pre-commit
does that it doesn't. The neighbours
are characterised from their own
documentation, not benchmarked; the
lab's verified ground is pre-commit
itself.

## Hand-written git hooks

The original: a shell script you write
yourself at `.git/hooks/pre-commit`.
**What it does better:** nothing stands
between you and the mechanism — no
install, no framework, no YAML — and
for one machine and one private
repository, it may be all you need.
**What pre-commit does better:**
everything about sharing and upkeep.
The hand-written script lives in
`.git/`, which is never cloned, so each
new clone starts unguarded until its
owner copies the script in; there is no
list of checks to review, no
environments, no updating. Most
projects that begin here end by
reinventing pre-commit one feature at a
time. (A middle path exists — committing
a `hooks/` folder and pointing git at
it with `core.hooksPath` — which solves
the sharing and keeps the hand-written
simplicity; it is a reasonable choice
for a small, shell-fluent team.)

## Husky and lint-staged

The JavaScript ecosystem's answer, in
two parts: **Husky** manages git hooks
for a Node project (installed through
npm, hooks kept as small scripts in a
`.husky/` folder in the repository),
and **lint-staged** runs commands
against just the staged files, which is
the reach chapter 5 described.
**What they do better:** for a project
that is already npm-shaped, they are
native — no Python anywhere, setup in
the same breath as the rest of the
project's tooling, and a config that
lives in `package.json`. **What
pre-commit does better:** it is
language-neutral in both directions —
it supervises a repository that is
part Python, part shell, part Terraform
with one list — and its hook ecosystem
is published collections with pinned
revisions and built environments,
where the Husky pattern typically runs
whatever the project's own
`node_modules` happens to hold.

## Lefthook

A single fast binary (written in Go)
that manages git hooks from one YAML
file, `lefthook.yml`, and runs hooks in
parallel where it can. **What it does
better:** speed and simplicity of
installation — one binary, no runtime
to install, and parallel execution that
shows on large hook sets. **What
pre-commit does better:** the same
language-neutral supervision, plus the
environment-building at its heart:
Lefthook runs commands your machine
already has, so the guarantee that a
colleague's machine runs the *same*
formatter version comes from somewhere
else in your stack, where pre-commit
builds that guarantee in. For a team
whose tooling is already uniform,
Lefthook's trade is a good one.

## The server side: CI and protected branches

Not a competitor but the other half of
the design, and the neighbour that
matters most. **What it does better:**
it cannot be bypassed. A required CI
check, or a protected branch that
refuses unreviewed pushes, holds
against `--no-verify`, against a
contributor who never installed the
hooks, against every accident of a
local machine. **What pre-commit does
better:** it speaks first and kindly —
in the author's own terminal, in
seconds, while the fix is still cheap —
where CI speaks later, in a web page,
after a push. Chapter 8 showed the same
config serving both posts. A project
with only the server half has correct
but resented checks; a project with
only the local half has cheerful but
optional ones.

## Editor and IDE checks

Most editors will run a formatter on
save and underline a broken config file
as you type. That is not a neighbour so
much as a different sense: it sees one
person's one file, at typing speed, and
it vanishes the moment the file is
edited anywhere else. Teams still want
it — the earlier a human hears, the
cheaper the fix — but it enforces
nothing, shares nothing, and leaves no
trace in the repository. Use it as the
innermost of the three rings: editor
while typing, pre-commit while
committing, CI while merging.

Check: for any project you know, you
should now be able to say which of
these is standing guard at the commit,
which at the merge, and whether the gap
between them is a choice or an
accident. Chapter 11 turns to what the
guard you have chosen cannot do.
