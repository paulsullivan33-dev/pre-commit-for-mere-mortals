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
