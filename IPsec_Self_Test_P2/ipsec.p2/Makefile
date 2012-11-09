#
# $Name: V6PC_P2_IPsec_1_10_0 $
#
# $TAHI: ct/ipsec.p2/Makefile,v 1.2 2007/03/09 10:48:05 akisada Exp $
#
INSTALL_DIR=$(PREFIX)/ct/ipsec.p2
XFILES = *.seq *.pm
FILES = *.def INDEX* *.html 00README .footer *.tmpl

all:

install:
	install -d -o bin -g bin -m 755 $(INSTALL_DIR)
	install -c -o bin -g bin -m 555 $(XFILES) $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 $(FILES) $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 Makefile.test $(INSTALL_DIR)/Makefile

.include "Makefile.test"
