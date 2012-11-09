#!/bin/sh

BINDIR=/usr/local/v6eval/bin
ETCDIR=/usr/local/v6eval/etc
$BINDIR/pam4 $ETCDIR/macro.h - | $BINDIR/pa $1
