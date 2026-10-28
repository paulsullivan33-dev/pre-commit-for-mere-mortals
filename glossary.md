# Glossary

The terms, collected in one place, in
the plain language the guide used for
them.

**Hook.** One small program with one
checking or fixing job — the unit
pre-commit runs. Also, by git's older
usage, the script in `.git/hooks/` that
git itself runs; chapter 2 separates
the two meanings.

**Checker.** A hook that reads files
and reports problems, changing nothing.
Its failure comes with an explanation
and work for you.

**Fixer.** A hook that rewrites files
into the shape they should have. Its
failure comes with the repair already
made in your working tree, waiting to
be staged.

**Config (`.pre-commit-config.yaml`).**
The committed file at the top of a
repository listing which hook
repositories to fetch and which hooks
to take from each.

**Hook repository.** A git repository
that publishes hooks, described by its
`.pre-commit-hooks.yaml` manifest.

**rev.** The pinned revision — a
release tag or commit hash — of a hook
repository in the config. Pins make
every machine run the same hook code.

**Environment.** The private little
installation pre-commit builds so a
hook's own language and libraries exist
(chapter 2). Built once, reused until
the pin moves.

**Cache.** The folder in your home
(`~/.cache/pre-commit` on Linux)
holding fetched repositories and built
environments between runs.

**Staged.** Files (or parts of files)
placed in git's index with `git add`,
being what the next commit will
contain. By default, hooks check the
staged snapshot.

**Stage (hook stage).** Which of git's
hook points a run belongs to —
`pre-commit` by default; also
`commit-msg`, `pre-push`, and others
(chapter 5).

**Local hook.** A hook defined inside
the config itself, under
`repo: local`, whose code lives in the
project rather than a fetched
repository.

**`language: system`.** A hook (often
local) run with whatever the machine
already provides — no environment
built, so its needs are the machine's
to supply.

**`files` / `exclude` / `types`.** The
config keys that aim a hook: a path
pattern to include, a path pattern to
never touch, and the kinds of file it
applies to (chapter 6).

**`--all-files`.** The reach of
`pre-commit run` extended from the
staged files to every matching file in
the repository (chapter 5).

**autoupdate.** The command that moves
each `rev` pin to its repository's
newest release tag, as an edit you
review and commit (chapter 8).

**`--no-verify`.** The `git commit`
flag that skips the pre-commit hook
entirely — the bypass of chapter 11:
rare, visible, and followed by a
clean-up run.

**pre-commit.ci.** The project's hosted
service, which runs a repository's
hooks on pull requests and keeps its
pins updated, described in chapter 8
from its documentation.
