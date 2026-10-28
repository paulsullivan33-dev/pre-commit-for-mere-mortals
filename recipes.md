# Recipes

Four configurations worth copying,
each a small variation on machinery the
earlier chapters verified. The first
two are assembled from the hook
collection this guide ran throughout;
the third adds one more hook from that
same collection; the fourth is about
people, not hooks. Anything from
outside the verified collection is
named as a documented pattern rather
than a transcript.

## A starter set for almost any repository

The lab's three, plus the fourth hook
from `sample-config` (chapter 3) —
the set the framework itself suggests:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
```

Why these four travel well together:
they apply to nearly every file a
repository holds, they are never wrong
about what they fix, and they take
seconds. Repositories earn more
specific hooks — formatters, linters,
type checkers for their language — one
at a time, per chapter 6's advice, on
top of this floor rather than instead
of it.

## A documents and data project

For a repository that is mostly writing
and configuration — documentation,
notes, data files — lean on the
collection's other housekeeping hooks,
each an id in the same `hooks:` list:

- **`check-json`** and
  **`check-toml`** beside `check-yaml`:
  the same "is this file even
  well-formed" promise for the other
  two formats every project collects.
- **`end-of-file-fixer`** and
  **`trailing-whitespace`** as before —
  documents are where stray whitespace
  does its worst damage to diffs.
- **`mixed-line-ending`**: reports (and
  with `--fix=lf`, settles) files that
  mix Windows and Unix line endings,
  the quiet saboteur of shared writing.
- **`check-merge-conflict`**: refuses a
  commit that still contains the
  `<<<<<<<` markers of an unfinished
  merge — a mistake everyone makes
  exactly once per career, if the hook
  lets them.

These are presented as configuration,
from the collection's own manifest; the
lab ran the collection's machinery end
to end but did not exercise each of
these ids individually, and the
distinction matters to this series even
when the pattern is identical.

## A hook with a size limit

`check-added-large-files` deserves its
own paragraph because its useful form
takes an argument (chapter 6's
`args`). By default it refuses any new
file over 500 KB — a binary, a video,
a database dump committed by accident
is nearly impossible to remove from
history cleanly, so the refusal is
worth its occasional false alarm:

```yaml
      - id: check-added-large-files
        args: [--maxkb=2000]
```

Set the limit to what your project can
defend in a sentence ("nothing over
2 MB; media lives in releases"), not to
whatever silences the first complaint —
a limit raised at every objection is a
limit that does not exist.

## A shared config for a small team

The mechanics are nothing: the config
is a committed file, so the sharing is
automatic. The recipe is the etiquette
around it:

1. **Introduce hooks in a pull request
   of their own**, whose description
   says which checks are arriving and
   what they will do to existing files
   (run `--all-files` first, and either
   fix the tree in the same request or
   say plainly that the first week will
   be noisy).
2. **One hook at a time, a week apart,**
   for a team new to the machinery.
   Five new gatekeepers on one Monday
   produces five bypass habits by
   Friday.
3. **Keep the set fast.** Every second
   a hook run takes is paid at every
   commit by every person. A slow check
   belongs in pre-push or CI (chapters
   5 and 8), not in the commit path.
4. **Write the bypass rule down.**
   `--no-verify` exists for genuine
   emergencies; a team that says so —
   and says what counts as one — keeps
   the flag rare and honest. Chapter 11
   has the reasoning.

## A language project's shape, in outline

A code project adds its language's
formatter and linter as their own
`repo:` entries — a Python project, for
example, adopts a formatter's official
hook repository and pins it like any
other:

```yaml
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.0.0   # stand-in: pin the current release tag
    hooks:
      - id: ruff
      - id: ruff-format
```

That snippet is a documented pattern —
the lab's verified work is the
framework itself, not any one language's
tooling, and the revision shown is a
stand-in: look up the collection's
current release and pin that, never a
version copied from a book (this one
included). The shape is the
recipe: framework hooks first, your
language's own collections next, each
read before it is trusted (chapter 1),
each adopted one at a time (chapter 6).

Check: each recipe should be adoptable
by pasting it into a practice
repository's config and running
`pre-commit run --all-files` — the
framework does the rest, and the output
tells you what the new rules think of
your files before any commit depends
on them.
