SUBDIR=script include
PREFIX= /usr/local/v6eval
DOCFILES=00README.ike CHANGELOG.ike COPYRIGHT.ike INSTALL.ike
DIRS1= $(PREFIX)
DIRS2= $(PREFIX)/doc/
.MAIN: depend all
beforeinstall:
	install -d -o bin -g bin -m 755 $(DIRS1)
	install -d -o bin -g bin -m 755 $(DIRS2)
	install -c -o bin -g bin -m 444 $(DOCFILES) $(DIRS2)
.include <bsd.subdir.mk>
