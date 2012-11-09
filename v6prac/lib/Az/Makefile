LIB= Az
YSRCS=	AzParse.y SaParse.y
SRCS= \
	$(YSRCS:.y=.cc) AzToken.cc AzLexer.cc PeNode.cc AzPcap.cc \
	PvXOctets.cc DmNetdb.cc SaLexer.cc SaToken.cc AzSA.cc

CFLAGS	+= -I. -I$(Cm) -I$(Pz) 

.include "bsd.lib.mk"
