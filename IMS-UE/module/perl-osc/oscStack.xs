#include "perl_osc.h"

MODULE = Stack		PACKAGE = osc::Stack	

Stack *
Stack::new(StateHandler *stateHandler)
    CODE:
	RETVAL = new Stack(*stateHandler);
	ST(0) = sv_newmortal();
	sv_setref_pv( ST(0), CLASS, (void*)RETVAL );

void
Stack::DESTROY()

void
Stack::addCompressor(DeflateCompressor *compressor)


SV *
Stack::compressMessage(char *data, size_t size, int id, bool reliableTransport = false)
    PREINIT:
	SigcompMessage *sm;
    CODE:
	sm = THIS->compressMessage(data, size, id, reliableTransport);
	RETVAL = newSV (0);
	sv_setref_pv (RETVAL, "osc::SigcompMessage", (void *) sm);
    OUTPUT:
	RETVAL

int
Stack::uncompressMessage(char *input, size_t inputSize,SV *output, size_t outputSize, SV *sc)
    PREINIT:
	StateChanges *stateChange=NULL;
	char *temp;
    CODE:
	temp = (char*)calloc(1,outputSize);
	RETVAL = THIS->uncompressMessage(input,inputSize,(void*)temp,outputSize,stateChange);
	sv_setref_pv(sc, "osc::StateChanges", (void *)stateChange);
	if(0<RETVAL) sv_setpvn(output, (char*)temp, RETVAL);
	free(temp);
    OUTPUT:
	RETVAL

void
Stack::provideCompartmentId(StateChanges *sc,SV *id)
    PREINIT:
	int temp=0;
    CODE:
	temp=SvIV(id);
	THIS->provideCompartmentId(sc,&temp,sizeof(int));
	sv_setiv(id, (IV)temp);

SV *
Stack::getNack()
    PREINIT:
	SigcompMessage *sm;
    CODE:
	sm = THIS->getNack();
	RETVAL = newSV (0);
	sv_setref_pv (RETVAL, "osc::SigcompMessage", (void *) sm);
    OUTPUT:
	RETVAL


int
Stack::getStatus();
