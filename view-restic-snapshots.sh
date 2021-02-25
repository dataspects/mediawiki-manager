#!/bin/bash

sudo restic \
    --repo restic_data/ \
    --password-file mediawiki_root/restic_password \
        ls latest | grep backup.sql