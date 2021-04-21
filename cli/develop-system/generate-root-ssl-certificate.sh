#!/bin/bash

source ./envs/my-new-system.env

####################################

# https://letsencrypt.org/docs/certificates-for-localhost/

# CreateCampEMWCon2021: proper SSL for mwmITLocal, mwmITIntra, mwmITCloud

openssl req -x509 -out localhost.crt -keyout localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")