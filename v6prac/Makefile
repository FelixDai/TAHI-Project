SUBDIR=lib bin sample script

PREFIX= /usr/local/v6eval
BINDIR?= /usr/local/v6eval/bin
DOCFILES= 00README INSTALL COPYRIGHT doc/MANUAL* doc/RELEASE* doc/README* doc/USAGE*

M4DIR= m4
PAM4DIR= pam4
DIRS=   $(PREFIX) $(PREFIX)/bin $(PREFIX)/doc $(PREFIX)/sample $(PREFIX)/etc

.MAIN: depend all pam4
pam4:
	( cp -r $(M4DIR) $(PAM4DIR) ; cd $(PAM4DIR) ; patch -p1 < pam4.diff ; make )

beforeinstall:
	for i in $(DIRS); do \
		[ -d $$i ] || mkdir $$i; \
	done

	install -c -o bin -g bin -m 444 $(DOCFILES) $(PREFIX)/doc

	( cd $(PAM4DIR) ; make install )

.include <bsd.subdir.mk>
