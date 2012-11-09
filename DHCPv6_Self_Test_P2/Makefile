#
# Makefile
#
# $TAHI: dhcpv6.p2/Makefile,v 1.6 2010/03/30 07:49:57 mario Exp $
#
################################################################################

INSTALL_DIR=$(PREFIX)/ct/dhcpv6.p2/
XFILES = *.pm
FILES = 00README.ct CHANGELOG.ct COPYRIGHT index.html Makefile.inc *.def config.pl
SUBRMT_DIR = remote/

all:

install:
	install -d -o bin -g bin -m 755 $(INSTALL_DIR)
	install -c -o bin -g bin -m 555 $(XFILES) $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 $(FILES) $(INSTALL_DIR)
	install -c -o bin -g bin -m 444 Makefile.test $(INSTALL_DIR)/Makefile
	@for subdir in ${SUBDIR}; do \
		echo "===> $$subdir"; \
		(cd $$subdir; ${MAKE} $@); \
	done
	@for subdir_remote in ${SUBRMT_DIR}; do \
		echo "===> $$subdir_remote"; \
		(cd $$subdir_remote; ${MAKE} $@); \
	done

.include "Makefile.test"
.include "Makefile.inc"
.include <bsd.subdir.mk>
