#!/bin/bash

restic \
    --repo ./snapshots \
    --password-file conf/restic/restic_password \
        snapshots

restic \
    --repo ./snapshots \
    --password-file conf/restic/restic_password \
        ls latest

restic \
    --repo ./snapshots \
    --password-file conf/restic/restic_password \
        restore latest \
            --target ./currentresources
