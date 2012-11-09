#
# Makefile
#
# $TAHI: ct/Makefile,v 1.21 2004/03/30 07:22:52  $
#

INSTALL_DIR=$(PREFIX)/ct-sip-ipv6-b2bua
CRFILES= COPYRIGHT

all:

afterinstall:
	install -d -o bin -g bin -m 755 $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 $(CRFILES) $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 index.html $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 Makefile.inc $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 Makefile.test $(INSTALL_DIR)/Makefile
	install -c -o bin -g bin -m 444 SIP_IPv6_ReferenceManual.pdf $(INSTALL_DIR)

.include "Makefile.test"
.include "Makefile.inc"

