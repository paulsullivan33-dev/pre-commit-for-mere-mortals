# Your Own Hooks

By the end of this chapter you have
written a working hook: a small shell
script that rejects any text file
containing a marker you choose, wired
into the practice repository as a
**local hook**. Along the way it will
do something no published hook in this
guide managed — it will catch its own
machinery — and you will fix that with
one line of config. Both events are in
the lab's transcripts; neither was
staged.

## Why write one at all

Published hooks cover the world's
generic problems. Every project also
has one or two private ones: the word
that must never ship, the placeholder
that means "not finished", the file
that must always travel with another
file. These checks are usually three
lines of shell and an opinion, and
pre-commit will gladly run them beside
the famous collections, under the same
rules.

The lab's private problem, invented for
the purpose: drafts collect the marker
`DO-NOT-COMMIT` while prices are still
being checked, and the marker must
never reach the repository. The check:
search each text file for the marker,
and fail, naming the file, if found.

## The script

Hooks receive the filenames they are
to check as command-line arguments,
and answer with their exit code: zero
for pass, anything else for fail. That
is the whole contract. The lab's
script, kept in the repository at
`tools/no-marker.sh` and made
executable:

```bash
#!/bin/sh
# no-marker.sh -- fail if any file handed to us contains DO-NOT-COMMIT.
status=0
for f in "$@"; do
    if grep -q 'DO-NOT-COMMIT' "$f"; then
        echo "$f: contains DO-NOT-COMMIT"
        status=1
    fi
done
exit $status
```

Nothing here is pre-commit-specific —
it is a shell script that could be run
by hand — and that is the point. (The
*ShellCheck for Mere Mortals* guide in
this series is the natural companion
for writing such scripts well.)

## The wiring

Local hooks live in the same config,
under a repository named `local`, which
tells pre-commit "the code is here, do
not fetch anything":

```yaml
  - repo: local
    hooks:
      - id: no-marker
        name: no DO-NOT-COMMIT markers
        entry: tools/no-marker.sh
        language: system
        types: [text]
```

The new vocabulary: **`entry`** is the
command pre-commit runs, with the
matched filenames appended.
**`language: system`** means "run it
with whatever the machine provides" —
no environment is built, so the script's
needs (here, a shell and `grep`) are
the machine's to supply, exactly as
chapter 6 warned. **`types: [text]`**
aims it at every text file, named or
not. Other languages exist for local
hooks — `script`, and full environments
for a hook written in Python or Node
with its own dependencies — and the
project's documentation covers them;
the lab verified the system route and
says so.

Stage the script and the config, and
commit — expecting a small ceremony,
since the hook's first official act is
to inspect the commit that creates it:

## The hook catches itself

```text
$ git commit -m "Add a local hook that rejects DO-NOT-COMMIT markers"
trim trailing whitespace.................................................Passed
fix end of files.........................................................Passed
check yaml...............................................................Passed
no DO-NOT-COMMIT markers.................................................Failed
- hook id: no-marker
- exit code: 1

.pre-commit-config.yaml: contains DO-NOT-COMMIT
tools/no-marker.sh: contains DO-NOT-COMMIT
```

(Transcript `t05-local-hook-catches-itself.txt`.)
The hook is *right*. Both files do
contain the marker — the script must
name it to search for it, and the
config must name it to describe the
hook. A check that matches its own
machinery can never pass, and every
project that writes a marker-style hook
meets some version of this in its first
week.

The honest fix is not to weaken the
check but to exempt the two files whose
job is to mention the marker — chapter
6's `exclude`, added to this hook only:

```yaml
        exclude: ^(tools/no-marker\.sh|\.pre-commit-config\.yaml)$
```

With that line staged, the same commit
passes. In the transcript
(`t06-local-hook-at-work.txt`) the new
hook reports `(no files to check)
Skipped` on its own creating commit —
with both machinery files excluded, it
had no files left to inspect, which is
the exclude working, not the hook
sleeping.

## The hook at work

Now the job it was hired for. A draft
agenda still carrying its marker:

```text
$ git commit -m "Draft agenda"   (marker still in the file)
...
no DO-NOT-COMMIT markers.................................................Failed
- hook id: no-marker
- exit code: 1

agenda.txt: contains DO-NOT-COMMIT
```

Replace the marker with the confirmed
text, stage, and the identical commit
passes all four hooks. (Also transcript
`t06`.) The marker has been converted
from a hope — "someone will grep before
committing" — into a mechanism.

Check: your local hook should fail on a
file containing your marker and pass
the same file cleaned, and creating
the hook itself should reproduce the
self-catch and its one-line cure. The
finished config and script, exactly as
the lab left them, are in
`pre-commit-lab/fixture/` — compare
yours against them. Chapter 8 turns
from writing checks to keeping them
current.
