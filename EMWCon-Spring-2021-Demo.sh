#!/bin/bash
source ./cli/lib/utils.sh

clear
printf "\n\e[1mEMWCon-Spring-2021-Demo\e[0m"
promptToContinue

clear;
./report-status.sh
promptToContinue