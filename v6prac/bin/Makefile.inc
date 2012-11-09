BINDIR?=	/usr/local/v6eval/bin
MANDIR=	/usr/local/v6eval/man/man
l=../../lib
Cm=$l/Cm
Pz=$l/Pz
pkt=$l/pkt
Az=$l/Az
Tg=$l/Tg
DEBUG_FLAGS=-g -Wall -Woverloaded-virtual
.if exists(/usr/local/v6/lib/libinet6.a)
LDDESTDIR	+= -L/usr/local/v6/lib
LDADD		+= -linet6
.endif

.MAIN: depend all
beforedepend: cleandepend
