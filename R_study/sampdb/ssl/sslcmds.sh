#!/bin/sh
# sslcmds.sh - create certificate and key files for MySQL SSL support

# Execute this script by typing "sh sslcmds.sh" at the command line.
# (If you have Expect, you can use it to answer all the questions for
# you by running "expect sslcmds.expect" at the command line.)

# OpenSSL configuration file used by following commands
CFFILE="-config ./sampdb.cnf"
# Number of days until the certs/keys expire
DAYS=3650

# create the serial and index.txt files or the signing operations will fail
echo "01" > serial
rm -f index.txt
touch index.txt
# remove old certs
rm -f [0-9][0-9].pem

cat<<EOF

--- STEP 1. ---
This step generates the Certificate Authority (CA) key and certificate
files, ca-key.pem and ca-cert.pem.

When prompted for a passphrase, supply your CA passphrase (twice).

EOF

openssl req $CFFILE \
    -new -x509 -keyout ca-key.pem -out ca-cert.pem -days $DAYS

cat<<EOF

--- STEP 2. ---
This step generates the server key and signing request files,
server-key.pem and server-req.pem.

When prompted for a passphrase, supply your server passphrase (twice).
When prompted for an Organizational Unit Name, enter "server".

EOF

openssl req $CFFILE \
    -new -keyout server-key.pem -out server-req.pem -days $DAYS

cat<<EOF

--- STEP 3. ---
This step removes the passphrase from the server key file, leaving the
original file in server-key.pem.orig.

When prompted for a passphrase, supply your server passphrase.

EOF

mv server-key.pem server-key.pem.orig
openssl rsa -in server-key.pem.orig -out server-key.pem

cat<<EOF

--- STEP 4. ---
This step signs the server certificate file, server-cert.pem.

When prompted for a passphrase, supply your CA passphrase.
When prompted whether to sign the certificate, enter "y".
When prompted whether to commit, enter "y".

EOF

openssl ca $CFFILE \
    -policy policy_anything -cert ca-cert.pem -keyfile ca-key.pem \
    -out server-cert.pem -infiles server-req.pem

cat<<EOF

--- STEP 5. ---
This step generates the client key and signing request files,
client-key.pem and client-req.pem.

When prompted for a passphrase, supply your client passphrase (twice).
When prompted for an Organizational Unit Name, enter "client".

EOF

openssl req $CFFILE \
    -new -keyout client-key.pem -out client-req.pem -days $DAYS

cat<<EOF

--- STEP 6. ---
This step removes the passphrase from the client key file, leaving the
original file in client-key.pem.orig.

When prompted for a passphrase, supply your client passphrase.

EOF

mv client-key.pem client-key.pem.orig
openssl rsa -in client-key.pem.orig -out client-key.pem

cat<<EOF

--- STEP 7. ---
This step signs the client certificate file, client-cert.pem.

When prompted for a passphrase, supply your CA passphrase.
When prompted whether to sign the certificate, enter "y".
When prompted whether to commit, enter "y".

EOF

openssl ca $CFFILE \
    -policy policy_anything -cert ca-cert.pem -keyfile ca-key.pem \
    -out client-cert.pem -infiles client-req.pem

cat<<EOF

--- STEP 8. ---
This step verifies the certificate files.

Expected output:
server-cert.pem: OK
client-cert.pem: OK

Actual output:
EOF

openssl verify -CAfile ca-cert.pem server-cert.pem client-cert.pem
