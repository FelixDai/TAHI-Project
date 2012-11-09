#
# Makefile
#
# $TAHI: ct/Makefile,v 1.21 2002/11/19 07:22:52 akisada Exp $
#

INSTALL_DIR=$(PREFIX)/ct-mipv6
CRFILES= COPYRIGHT

all:

afterinstall:
	install -d -o bin -g bin -m 755 $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 $(CRFILES) $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 index.html $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 Makefile.inc $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 Makefile.test $(INSTALL_DIR)/Makefile

.include "Makefile.test"
.include "Makefile.inc"

SUBDIR+=images
