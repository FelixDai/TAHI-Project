#include "perl_osc.h"

MODULE = StateHandler		PACKAGE = osc::StateHandler

StateHandler *
StateHandler::new(size_t maxStateSpaceInBytes=8192,size_t maximum_cyclesPerBit=64,size_t maxDecompressionSpaceInBytes=8192,unsigned short sigcompVersion=0x02)

void
StateHandler::DESTROY()

void
StateHandler::useSipDictionary()

bool
StateHandler::hasSipDictionary()

int
StateHandler::getStateMemorySize()
