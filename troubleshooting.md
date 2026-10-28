# Troubleshooting

The failures this guide's lab met, and
the ones every pre-commit user meets
soon after, each with the check that
names it. Worked from the top, most
"pre-commit is broken" reports end at
one of the first three.

## "The hooks never run here"

The commit succeeds instantly, with no
hook output at all. Almost always, the
repository was never armed: the config
exists, but `pre-commit install` was
not run in *this* clone — `.git/hooks/`
is per-clone and never travels
(chapter 2). Check:

```bash
ls .git/hooks/pre-commit
pre-commit install
```

If the file is missing, the install is
the whole fix. The same symptom has
one impostor worth knowing: committing
with `--no-verify` anywhere in the
command — an alias or a GUI checkbox —
skips the hook on purpose (chapter 11).

## "It failed, but the file looks fine"

It *is* fine — now. A fixer hook
repaired it during the failed run and
left the repair in your working tree,
which is why the commit failed and the
file looks innocent. The fix is not
broken; it is *unstaged*. This is
chapter 4's central rhythm:

```bash
git diff          # admire the repair
git add <file>    # stage it
git commit        # again
```

If `git diff` shows changes you did
*not* make and do not want, that is a
different and serious report: read
chapter 11's trust section, and check
which hook in the config made them.

## "It says my YAML config is broken"

Three different files can be the
culprit, and the error names which.
Your *data* file failing `check-yaml`
is chapter 4's checker doing its job —
the parser's message gives the line. A
broken `.pre-commit-config.yaml` fails
differently, with pre-commit itself
complaining before any hook runs; that
is what `pre-commit validate-config`
(chapter 3) exists to catch while you
are still editing, not committing. And
a hook *repository's* manifest can be
at fault after an `autoupdate` —
restore the previous `rev` (the update
was its own commit, per chapter 8) and
the old behaviour returns whole.

## "The hook flags its own files"

Your marker hook matches its script, a
template checker objects to the
template, a checker dislikes the
example files kept to test it. The lab
met the pure form in chapter 7: a hook
that searches for a word must itself
contain the word. The cure is aim, not
surrender — the `exclude` pattern of
chapter 6, scoped as narrowly as the
problem allows. If you find yourself
excluding a hook from most of the
tree, the honest reading is that the
hook is aimed wrong, not that the tree
is.

## "The first run takes forever"

Environments being built (chapter 2),
once per hook repository per revision
per machine. It is supposed to happen
exactly once — after the first install,
after each `autoupdate`, after wiping
the cache. If *every* run is slow, the
questions change: is the cache being
kept (a home folder that is wiped
between sessions, a CI runner with no
cache step)? Is one hook rebuilding
because its `rev` is a branch that
moves, rather than a pinned tag? Is a
single hook simply heavy — chapter 5's
single-hook run will tell you which,
and chapter 11 says where heavy hooks
belong.

## "A hook passes for me and fails for them"

Differences between machines, in the
usual order. Different pins: someone's
config is older — `git pull` before
theorising. Different environments:
someone's cache holds a build from a
broken day — `pre-commit clean` clears
the cache, and the next run rebuilds
honestly. Different reach: one of you
ran hooks on staged files, the other
on `--all-files`, and the tree had
pre-existing litter (chapter 5).
Different system entirely: a
`language: system` hook is only as
portable as the tool it names, which
chapter 6 warned about at adoption
time.

## "pre-commit: command not found", after it worked yesterday

The shell forgot where the program
lives — usually because it was
installed into a virtual environment
that is not active in this terminal, or
with `pip --user` into a folder that
left the `PATH`. The diagnostic is
chapter 3's check, `pre-commit
--version`, plus `which python` and
`pip show pre-commit` to find where it
went. The durable fix is to install
pre-commit the way you install other
standing tools (pipx, a system package,
Homebrew) rather than inside one
project's environment — the tool
supervises all your repositories, and
its home should not depend on any one
of them.
