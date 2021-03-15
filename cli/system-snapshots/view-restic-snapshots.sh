#!/bin/bash

sudo restic \
    --repo restic-backup-repository/ \
    --password-file conf/restic/restic_password \
        snapshots