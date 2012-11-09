CFLAGS		+= -I$(Pflow) -I/usr/local/include
LDDESTDIR	+= -L$(Pflow) -L/usr/local/lib
LDADD		+= -lPflow
SRCS=	flow.c
PROG=	$(SRCS:.c=)
NOMAN=

.include "../Makefile.inc"
.include "bsd.prog.mk"

$(PROG): $(Pflow)/libPflow.a
