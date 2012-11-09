#!/bin/sh

PA_OUT="$1.txt" ; exprot PA_OUT
PASH="/usr/local/v6eval/bin/pa.sh" ; export PASH
FLOW="/usr/local/v6eval/bin/flow" ; export FLOW
PADIVIDE="/usr/local/v6eval/bin/padivide" ; export PADIVIDE

$PASH $1> $PA_OUT << EOF
dump on
detail on
eall
EOF

$FLOW -c define.txt -p -n -h $PA_OUT
$PADIVIDE $PA_OUT
