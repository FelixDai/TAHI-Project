#include "perl_osc.h"

MODULE = DeflateCompressor		PACKAGE = osc::DeflateCompressor

DeflateCompressor *
DeflateCompressor::new(StateHandler *stateHandler)
    CODE:
	RETVAL = new DeflateCompressor(*stateHandler);
	ST(0) = sv_newmortal();
	sv_setref_pv( ST(0), CLASS, (void*)RETVAL );



