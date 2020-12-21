#!/usr/bin/env sh
# Run once, hold otherwise
if [ -f "already_ran" ]; then
    echo "Already ran the Entrypoint once. Holding indefinitely for debugging."
    /bin/bash -i
    exit
fi
touch already_ran
exec "$@"