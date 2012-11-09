#include "perl_osc.h"

#define GPERL_C_CALL_BOOT(name)	_gperl_call_XS (aTHX_ name, cv, mark);

extern "C" XS(boot_Stack);
extern "C" XS(boot_DeflateCompressor);
extern "C" XS(boot_StateHandler);
extern "C" XS(boot_SigcompMessage);
extern "C" XS(boot_StateChanges);

extern "C" {
void
_gperl_call_XS (pTHX_ void (*subaddr) (pTHX_ CV *), CV * cv, SV ** mark)
{
	dSP;
	PUSHMARK (mark);
	(*subaddr) (aTHX_ cv);
	PUTBACK;	/* forget return values */
}
}

MODULE = osc	PACKAGE = osc

BOOT:
#include "register.xsh"
GPERL_C_CALL_BOOT (boot_Stack);
GPERL_C_CALL_BOOT (boot_DeflateCompressor);
GPERL_C_CALL_BOOT (boot_StateHandler);
GPERL_C_CALL_BOOT (boot_SigcompMessage);
GPERL_C_CALL_BOOT (boot_StateChanges);

