# Your First Hooks

By the end of this chapter you have a
practice repository whose commits are
checked by three real hooks. You will
watch a commit fail while two hooks
repair the file it was committing,
stage the repair, and watch the same
commit pass — the whole rhythm of
working with pre-commit, in one
sitting. Everything here happens in a
throwaway repository; make your own
alongside, and break it freely.

## The practice repository

Create a folder, make it a git
repository, and give git a name to
commit under (the lab used a plainly
fictional one):

```bash
git init -b main lab-repo
cd lab-repo
git config user.name "Lab Reader"
git config user.email "reader@example.invalid"
```

Write the config from chapter 3,
trimmed to three hooks — two fixers
and a checker — at the pinned revision
the lab used:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
```

Now arm the repository, and check the
config as chapter 3 taught. The lab's
transcript
`pre-commit-lab/transcripts/t00-install-and-config.txt`
kept all three steps:

```text
$ pre-commit validate-config .pre-commit-config.yaml
(no output: the config is valid)

$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
```

## A file with two things wrong with it

Make a file the way people actually
make files — in a hurry. `notes.txt`
below ends two lines in stray spaces
and has no newline at its end (the
`cat -A` view shows line-ends as `$`,
so trailing spaces are visible as
space before the `$`, and the missing
final newline as no `$` at the very
end):

```text
$ cat -A notes.txt
Shopping list for the workshop   $
- pencils  $
- graph paper
```

Add a well-formed `settings.yaml`
beside it, stage everything, and
commit:

```bash
git add .
git commit -m "Add workshop notes"
```

## The commit that fails by succeeding at its job

The lab's transcript `t01-first-commit-fails.txt`
shows what happens. First, the one-time
cost of chapter 2's environments being
built — expect this pause on any
machine's first run, and never again
for this hook collection at this
revision:

```text
[INFO] Initializing environment for https://github.com/pre-commit/pre-commit-hooks.
[INFO] Installing environment for https://github.com/pre-commit/pre-commit-hooks.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
```

Then the verdicts:

```text
trim trailing whitespace.................................................Failed
- hook id: trailing-whitespace
- exit code: 1
- files were modified by this hook

Fixing notes.txt

fix end of files.........................................................Failed
- hook id: end-of-file-fixer
- exit code: 1
- files were modified by this hook

Fixing notes.txt

check yaml...............................................................Passed
```

Read it slowly, because it is the whole
tool in one screen:

- The commit **did not happen**. Git
  stops it when the hook run fails.
- Both fixer hooks report **Failed** —
  and both *fixed the file anyway*.
  "Files were modified by this hook" is
  the fixer saying: the version you
  staged was not acceptable, here is
  the acceptable version, in your
  working tree. A fixer that changes
  nothing reports Passed instead.
- `check-yaml` **Passed**: it is a
  checker, it modifies nothing, and
  `settings.yaml` was well-formed.

## Stage the fix, commit again

The repaired file is already on disk —
the same `cat -A` now shows the spaces
gone and the final `$` present.
Nothing about the content changed; only
its shape did. Stage it and repeat the
commit:

```text
$ git add notes.txt
$ git commit -m "Add workshop notes"
trim trailing whitespace.................................................Passed
fix end of files.........................................................Passed
check yaml...............................................................Passed
[main (root-commit) e7b2e51] Add workshop notes
```

(Transcript `t02-second-commit-passes.txt`.)
That two-step — commit, be handed a
repair, stage, commit — is not a
failure of the tool or of you. It is
the tool's normal gait, and after a day
it feels like a spell-checker
underlining as you type. Chapter 5
shows how `pre-commit run` lets you
take the first step without attempting
a commit at all.

## A checker failing, for contrast

Fixer failures come with repairs.
Checker failures come with an
explanation and work for you to do.
The lab broke `settings.yaml` by
deleting a closing bracket, and
committed:

```text
check yaml...............................................................Failed
- hook id: check-yaml
- exit code: 1

while parsing a flow sequence
  in "settings.yaml", line 2, column 12
expected ',' or ']', but got ':'
  in "settings.yaml", line 3, column 9
```

That error is the YAML parser's own,
delivered by the hook, with the file
and the line named. Nothing was
modified — there is no automatic repair
for a file whose *meaning* is broken.
Restore the bracket, stage, commit, and
all three hooks pass (transcript
`t03-check-yaml-fails.txt`).

Check: your repository should now hold
two commits, and breaking either file
on purpose should reproduce the matching
failure. Hold on to this repository —
chapters 5 to 8 keep working in it. Its
finished state, as the lab left it, is
kept in `pre-commit-lab/fixture/`.
