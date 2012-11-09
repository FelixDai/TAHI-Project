#ifndef _PERL_OSC_H_
#define _PERL_OSC_H_

#define DEBUG

#include <osc/Types.h>
#include <osc/SigcompMessage.h>
#include <osc/DeflateCompressor.h>
#include <osc/StateHandler.h>
#include <osc/StateChanges.h>
#include <osc/Stack.h>

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

using namespace osc;

#endif
