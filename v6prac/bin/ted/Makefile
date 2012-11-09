CFLAGS		+= -I$(Cm) -I$(Tg)
LDDESTDIR	+= -L$(Tg) -L$(Cm) 
LDADD		+= -lTg -lCm
SRCS=	ted.cc
PROG=	$(SRCS:.cc=)
NOMAN=

.include "../Makefile.inc"
.include "bsd.prog.mk"
$(PROG): $(Cm)/libCm.a $(Tg)/libTg.a
