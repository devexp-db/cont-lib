#!/bin/bash

. {{ macros.pkgdatadir }}/cont-lib.sh

cont_debug "command: $*"

__cont_source_scripts "{{ macros.contentry }}"

test -z "$*" && set -- bash
exec "$@"
