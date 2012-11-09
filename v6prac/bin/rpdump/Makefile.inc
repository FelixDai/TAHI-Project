BINDIR?=	/usr/local/v6eval/bin
DEBUG_FLAGS=-g -Wall -Woverloaded-virtual

.MAIN: depend all
beforedepend: cleandepend
