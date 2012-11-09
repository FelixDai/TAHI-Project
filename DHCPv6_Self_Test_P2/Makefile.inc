.ifdef V6EVALROOT
PREFIX?=$(V6EVALROOT)
.else
PREFIX?=/usr/local/v6eval
.endif

.ifndef AUTORUN
AUTORUN = $(PREFIX)/bin/autorun
.endif

.ifndef SUBDIR
SUBDIR=	rfc3315 \
	rfc3646 \
	rfc3736 \
	rfc3633 \
	rfc3633_rfc3646
.endif

