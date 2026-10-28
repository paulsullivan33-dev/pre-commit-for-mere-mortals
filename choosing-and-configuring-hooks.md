# Choosing and Configuring Hooks

By the end of this chapter you can aim
a hook: decide which files it sees,
which it must never touch, what extra
instructions it runs with, and where
to find hooks worth adopting in the
first place. Everything here is an edit
to the same `.pre-commit-config.yaml`
you have been using.

## Where hooks are found

The project's site keeps a directory of
supported hooks at
[pre-commit.com/hooks.html](https://pre-commit.com/hooks.html)
— formatters, linters, and checkers for
most languages and file kinds, each
with the few lines of config it takes
to adopt it. The pattern to notice,
rather than any one entry: nearly all
of them live in their own project's
repository, published by the people who
write the tool, and your config points
at that repository with a pinned `rev`.
That arrangement is why chapter 1's
rule is practical rather than paranoid:
the address is right there in your
config, and the collection's home is
one click from it.

Adopt slowly. One hook at a time, run
over `--all-files` (chapter 5), read
what it objects to in *your* existing
files before the first commit depends
on it. A hook adopted in haste tends to
be bypassed in haste, which is worse
than no hook: chapter 11 again.

## Which files a hook sees

A hook declares the kinds of files it
applies to, and pre-commit matches your
files against that declaration before
running anything. Three config keys let
you adjust the aim for a hook, without
forking it:

- **`files`** — a regular expression
  for the paths this hook should run
  on, narrowing the hook's own idea of
  its territory. The usual use is
  pointing a checker at one part of a
  large tree: `files: ^docs/`.
- **`exclude`** — a regular expression
  for paths the hook must never touch,
  applied after `files`. Generated
  files, vendored code, and fixtures
  that are broken *on purpose* (a test
  suite often keeps an invalid file
  precisely to test against) are the
  standard citizens of this list.
- **`types`** — file kinds by what the
  file *is*, not what it is named:
  `[python]`, `[yaml]`, `[text]`, and
  their kin, as recognised by the
  file-identification library
  pre-commit carries. `types` is how
  the lab's hook in chapter 7 asks for
  "every text file", extension or none.

The lab used two of the three for real.
Its shell hook declares
`types: [text]`, and after the incident
chapter 7 tells in full, an exclude for
the hook's own machinery:

```yaml
        types: [text]
        exclude: ^(tools/no-marker\.sh|\.pre-commit-config\.yaml)$
```

Two neighbouring keys deserve a
sentence each. **`args`** passes extra
instructions to the hook's own program
— a line-length for a formatter, a
stricter mode for a checker — in the
form the underlying tool would accept
on its own command line. **`name`**
relabels a hook in pre-commit's output,
which starts to matter when the same
underlying hook runs twice with
different arguments (say, a formatter
in strict mode for one folder and
gentle mode for another, distinguished
by their `files` patterns and their
names).

## The hook that matches nothing

A hook whose patterns match no files in
a run reports `(no files to check)`
and **Skipped** — visible throughout
the lab's later transcripts, where
`check-yaml` sits out commits that
contain no YAML. Skipped is not
failure and not success; it is the hook
truthfully reporting an empty desk.
Remember the line exists, because its
absence is diagnostic too: if a hook
you expect to run never appears at all,
the config names it wrong or the stage
is wrong, which is chapter 12's
territory.

## Hooks that ask for more

Most hooks install themselves entirely
inside their environment. A few want
things from *your* system: a language
runtime of a particular kind, a system
library, a binary on your `PATH`.
Pre-commit's tells: the hook's `language`
is something like `system` (run what is
installed; bring your own) or
`docker_image` (run inside a container
image), or its documentation lists a
prerequisite install. Chapter 7's local
hook is the honest example — a shell
script with `language: system` works
because every machine in the story has
a shell. When a hook asks for more than
you are willing to guarantee on every
machine that clones the project, that
is a real cost to weigh at adoption
time, not a surprise to meet on a
colleague's laptop.

## A word on defaults

Pre-commit itself has a small number of
project-wide settings — a top-level
`exclude` that applies to every hook,
a `default_language_version` for
environments, and `fail_fast` for
stopping at the first failure instead
of reporting them all. They live at
the top of the same config file, above
`repos:`. The lab changed none of them;
the defaults (report everything, run
everything) are the right starting
point, and the project's documentation
covers the rest. Change them when you
can name the annoyance they answer —
that was the lab's test for every
setting in this chapter, and it is a
good one.

Check: you can point at any hook in
your config and say which files it will
see in the next commit, and why.
Chapter 7 stops choosing hooks and
writes one.
