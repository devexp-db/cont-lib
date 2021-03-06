#!/bin/bash

# TODO: support API for executable help scripts
cat {{ macros.contdocdir }}/*.txt 2>/dev/null

cat <<EOF

======================
General container help
======================

Run 'docker run THIS_IMAGE container-usage' to get this help.

Run 'docker run -ti THIS_IMAGE bash' to obtain interactive shell.

Run 'docker exec CONTAINERID bash' to access already running container.

You may try '-e CONT_DEBUG=VAL' with VAL up to 3 to get more verbose debugging
info.
EOF
