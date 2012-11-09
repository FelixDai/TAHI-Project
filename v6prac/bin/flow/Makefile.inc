BINDIR     ?= /usr/local/v6eval/bin
l           = ../../../lib
Pflow       = $l/Pflow
DEBUG_FLAGS = -g -Wall -Woverloaded-virtual

.if exists(/usr/local/v6/lib/libinet6.a)
LDDESTDIR  += -L/usr/local/v6/lib
LDADD      += -linet6
.endif

.MAIN: depend all
beforedepend: cleandepend
