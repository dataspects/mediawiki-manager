#!/bin/bash

source ./envs/my-new-system.env
source ./cli/lib/utils.sh

sqlite3 mwm.sqlite "DELETE FROM extensions"