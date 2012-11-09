CFLAGS    += -Werror
LDDESTDIR += -L/usr/lib
LDADD     += -lpcap
SRCS       = rpdump.c ip.c ipv6.c tcp.c udp.c ether.c ripng.c bgp.c\
		timestamp.c addr.c usage.c rip.c
PROG       = rpdump
NOMAN      =

.include "bsd.prog.mk"
.include "Makefile.inc"
