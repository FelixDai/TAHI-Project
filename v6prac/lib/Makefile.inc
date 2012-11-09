install:
Cm=../Cm
Pz=../Pz
NOPROFILE=true
DEBUG_FLAGS=-g -DYYDEBUG -Wall -Woverloaded-virtual
YFLAGS  = -dv
.y.cc:
	${YACC} ${YFLAGS} ${.IMPSRC}
	mv y.tab.c $@
	if cmp -s y.tab.h $*.h; then rm y.tab.h; \
	else mv y.tab.h $*.h; fi
	if test -f y.output ; then mv y.output $*.rule ; fi

CXXFLAGS+=	-I/usr/local/include

.if defined(YSRCS)
CLEANFILES	+= $(YSRCS:.y=.h) $(YSRCS:.y=.cc) $(YSRCS:.y=.rule)
.endif
.MAIN: depend all
beforedepend: cleandepend
