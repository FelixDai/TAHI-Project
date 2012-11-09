#include "perl_osc.h"

MODULE = SigcompMessage		PACKAGE = osc::SigcompMessage

SigcompMessage *
SigcompMessage::new(char *msg,int length)
    CODE:
	RETVAL = new SigcompMessage((osc::byte_t*)msg,length);
	ST(0) = sv_newmortal();
	sv_setref_pv( ST(0), CLASS, (void*)RETVAL );

char*
SigcompMessage::getDatagramMessage()
    PREINIT:
	int leng;
    CODE:
	leng = THIS->getDatagramLength();
	RETVAL = (char *)(THIS->getDatagramMessage());
	sv_setpvn(TARG, RETVAL,leng); XSprePUSH; PUSHTARG;

int
SigcompMessage::getDatagramLength()

bool
SigcompMessage::isValid()

bool
SigcompMessage::isNack()

int
SigcompMessage::getNackReason()

int
SigcompMessage::getStatus()

char *
SigcompMessage::getReturnedFeedback()
    PREINIT:
	int leng;
    CODE:
	leng = THIS->getReturnedFeedbackLength();
	RETVAL = (char *)(THIS->getReturnedFeedback());
	sv_setpvn(TARG, RETVAL,leng); XSprePUSH; PUSHTARG;

void
SigcompMessage::dump()
    CODE:
	THIS->dump(std::cout,4);



