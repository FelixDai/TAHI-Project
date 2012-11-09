CFLAGS		+= -I$(Cm) -I$(Pz) -I$(Az)  -I/usr/local/include
LDDESTDIR	+= -L$(Az) -L$(Pz) -L$(Cm)  -L/usr/local/lib
LDADD		+= -lAz -lPz -lCm -lpcap -lcrypto
SRCS=	pa.cc
PROG=	$(SRCS:.cc=)
NOMAN=

.include "../Makefile.inc"
.include "bsd.prog.mk"
$(PROG): $(Cm)/libCm.a $(Pz)/libPz.a $(Az)/libAz.a
