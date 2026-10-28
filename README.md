# Pre-commit for Mere Mortals

Every project has a list of small things
that must never reach the repository:
lines trailing stray spaces, files that
do not end in a newline, a settings file
with a bracket missing, a note to self
that was never meant to be shared. People
mean to check for them by hand. People
forget. **Pre-commit** is a framework
that runs those checks for you, at the
one moment they cannot be forgotten:
when you type `git commit`. It reads a
list of **hooks** — small programs, each
checking or fixing one kind of thing —
from a file in your repository, runs them
over the files you are about to commit,
and stops the commit if any of them
object.

This guide explains how that works, how
to wire the first hooks into a practice
repository and watch a commit fail (on
purpose), how to run the same checks
whenever you like, how to pick which
files each hook sees, how to write a hook
of your own with nothing but a shell
script, and how to keep the whole set up
to date. The limits are stated plainly,
including the big one: pre-commit is a
reminder with teeth, not a lock — anyone
can walk around it with one flag, and
chapter 11 explains why the honest fix
for that lives on the server, not in
this tool.

There is a second thing to know before
any procedure, and chapter 1 states it
as this guide's rule: **a hook is code
that runs on your machine the moment you
commit — add only hooks from sources
you have read and trust.** Hooks are
written by other people and fetched from
the internet, and they execute with your
permissions. The lab in this guide obeyed
the rule by using only the framework's
own well-known hook collection, plus one
hook it wrote itself and printed in
full.

The lab behind this guide ran the real
thing: **pre-commit 4.7.0**, installed
with pip into a fresh virtual environment
on a small Linux machine, against a
throwaway git repository created for the
purpose. In that repository the lab
installed the standard hooks, committed
a file with trailing spaces and no final
newline and watched the commit fail while
two hooks repaired the file on the spot,
committed it cleanly the second time,
broke a YAML file and watched a checker
hook refuse it, ran every hook over the
whole tree on demand, wrote its own
ten-line shell hook — and caught that
hook flagging its own script, before
fixing the config so it could not. It
then updated an old configuration with
one command and, for the limits chapter,
walked around the whole apparatus with
`git commit --no-verify` to prove that
it could.

What the lab could not do, it did not
fake. It ran everything on one machine
and one account, so the hosted services
that will update your configuration or
run your hooks for you (pre-commit.ci
and the continuous-integration systems
of chapter 8) are taught from their
documentation and labelled as such
wherever they appear. Hooks written for
languages other than Python and shell —
formatters and linters for other
ecosystems — are likewise described
rather than demonstrated; the framework
that fetches and runs them is the same
verified machinery. `criteria.md` keeps
the full ledger of what was run and
what was only read.

## What this guide covers

- [**What pre-commit is**](what-pre-commit-is.md) —
  the mental model: checks that run
  themselves at commit time, what a hook
  is, and the trust rule that comes with
  running other people's code
- [**The moving parts**](the-moving-parts.md) —
  the config file, hook repositories,
  the environments pre-commit builds,
  git's own hook points, and the cache,
  and which part holds what
- [**Installing pre-commit**](installing-pre-commit.md) —
  the pip install and its neighbours,
  checking the result, and a starter
  config from the tool itself
- [**Your first hooks**](your-first-hooks.md) —
  a practice repository, three standard
  hooks, a commit that fails while the
  hooks fix the file, and the same
  commit passing once the fix is staged
- [**Running hooks on demand**](running-hooks-on-demand.md) —
  the whole tree at once, one hook at a
  time, staged files versus everything,
  and trying a hook before you adopt it
- [**Choosing and configuring hooks**](choosing-and-configuring-hooks.md) —
  which files a hook sees, `files`,
  `types` and `exclude`, arguments,
  stages, and hooks that ask for more
- [**Your own hooks**](your-own-hooks.md) —
  a hook written as a small shell
  script, wired in as a local hook —
  including the day it caught its own
  machinery, and the one-line fix
- [**Keeping hooks current**](keeping-hooks-current.md) —
  pinned revisions, `autoupdate`, and
  the services and CI systems that run
  hooks when a laptop forgets
- [**Recipes**](recipes.md) — a starter
  set for a Python project, one for
  documents and data files, a hook that
  refuses oversized files, and a shared
  config for a small team
- [**The neighbours**](the-neighbours.md) —
  hand-written git hooks, Husky and
  lint-staged, Lefthook, and the server
  side: what each does that pre-commit
  doesn't, and vice versa
- [**Limits**](limits.md) — one flag
  walks around it, it checks only what
  git hands it, a hook is a stranger's
  code, and a slow hook teaches people
  to bypass it
- [**Troubleshooting**](troubleshooting.md) —
  the commit that failed after the file
  was "already fixed", hooks that never
  run in a fresh clone, the hook that
  flags itself, and the slow first run
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Making commits trustworthy against a
determined committer — that is a server
job (protected branches and CI checks),
and chapter 11 explains the division of
labour. Writing formatters or linters
themselves: pre-commit runs other
people's tools, and this guide teaches
the running, the wiring and the
bookkeeping, not the internals of any
particular checker. The hosted
pre-commit.ci service is described from
its documentation, not driven. And
hooks for deliberately hiding changes
from reviewers are out entirely: the
tool's honest work is the opposite.

## How to use this guide

Read chapter 1 for the model and the
rule, and chapter 2 before installing
anything — knowing which part holds
what turns later confusion into a named
problem. Chapter 4 takes your first
hooks in the same sitting as the
install, in a practice repository you
can break freely; do not start by
wiring hooks into a repository you care
about. Chapter 7 is the one that turns
a consumer into an author — write the
small shell hook while the examples are
small enough to check by eye. The lab's
transcripts live in
`pre-commit-lab/transcripts/`; its
finished practice repository files are
`pre-commit-lab/fixture/`; its notes
are in `criteria.md`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [Git for Mere Mortals](https://paulsullivan33-dev.github.io/git-for-mere-mortals/)
- [ShellCheck for Mere Mortals](https://paulsullivan33-dev.github.io/shellcheck-for-mere-mortals/)
- [GitHub Actions for Mere Mortals](https://paulsullivan33-dev.github.io/github-actions-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/pre-commit-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/pre-commit-for-mere-mortals/blob/main/LICENSE-CODE).
