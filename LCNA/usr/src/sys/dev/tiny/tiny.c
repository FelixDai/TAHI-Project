/*
 * Copyright (C) 2002 Yokogawa Electric Corporation , 
 * INTAP(Interoperability Technology Association for Information 
 * Processing, Japan) , IPA (Information-technology Promotion Agency,Japan)
 * All rights reserved.
 * 
 * 
 * 
 * Redistribution and use of this software in source and binary forms, with 
 * or without modification, are permitted provided that the following 
 * conditions and disclaimer are agreed and accepted by the user:
 * 
 * 1. Redistributions of source code must retain the above copyright 
 * notice, this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright 
 * notice, this list of conditions and the following disclaimer in the 
 * documentation and/or other materials provided with the distribution.
 * 
 * 3. Neither the names of the copyrighters, the name of the project which 
 * is related to this software (hereinafter referred to as "project") nor 
 * the names of the contributors may be used to endorse or promote products 
 * derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND 
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING 
 * BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
 * FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE 
 * COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT,STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * $Id: tiny.c,v 1.1 2002/05/29 13:30:29 fujita Exp $
 */

#include "tiny.h"
#if 0
#include <sys/tinyio.h>
#endif
#include <sys/param.h>
#include <sys/systm.h>
#include <sys/conf.h>
#include <sys/kernel.h>
#include <sys/types.h>
#include <sys/device.h>
#include <sys/uio.h>
#include <sys/malloc.h>
#include <sys/errno.h>
#include <tinyipv6/tiny_types.h>
#include <tinyipv6/sysdep_types.h>
#include <tinyipv6/tiny_conf.h>
#include <tinyipv6/tiny_buf.h>
#include <tinyipv6/tiny_in6.h>
#include <tinyipv6/tiny_nd6.h>
#include <tinyipv6/tiny_netif.h>
#include <tinyipv6/tiny_ipsecdb.h>
#include <tinyipv6/tiny_utils.h>
#include <tinyipv6/sysdep_l4.h>
#include <dev/tiny/tiny_var.h>


cdev_decl(tiny);


/* 
 * device  specific Misc defines 
 */
#define UNIT(dev) minor(dev)	/* assume one minor number per unit */


/*
 * One of these per allocated device
 */
struct tiny_softc {
	struct device	sc_dev;
	int busy;
};

static struct tiny_softc *tinysc[NTINY];


/* 
 * Macro to check that the unit number is valid
 * Often this isn't needed as once the open() is performed,
 * the unit number is pretty much safe.. The exception would be if we
 * implemented devices that could "go away". in which case all these routines
 * would be wise to check the number, DIAGNOSTIC or not.
 */
#define CHECKUNIT(RETVAL)	\
	do { /* the do-while is a safe way to do this grouping */ \
		if (unit > NTINY) {	\
			printf(__FUNCTION__ ":bad unit %d\n", unit); \
			return (RETVAL); \
		} \
		if (sc == NULL) { \
			printf(__FUNCTION__ ": unit %d not attached\n", unit); \
			return (RETVAL); \
		} \
	} while (0)

#define DIAGNOSTIC	/* XXX */
#ifdef	DIAGNOSTIC
#define	CHECKUNIT_DIAG(RETVAL) CHECKUNIT(RETVAL)
#else	/* DIAGNOSTIC */
#define	CHECKUNIT_DIAG(RETVAL)
#endif 	/* DIAGNOSTIC */


int
tinyioctl(dev_t dev, u_long cmd, caddr_t data, int fflag, struct proc *p)
{
	int unit = UNIT(dev);
	struct tiny_softc *sc = tinysc[unit];

	CHECKUNIT_DIAG(ENXIO);
    
	switch (cmd) {
	case TINY_RESET:
		switch (unit) {
		case TINY_NEIGHBOR_CACHE:
			tiny_nd6_nbrcache_list_init();
			break;
		case TINY_IPSEC_DB:
			tiny_ipsecdb_init();
			break;
		case TINY_DEFROUTER_LIST:
			tiny_nd6_defrouter_list_init();
			break;
		case TINY_PREFIX_LIST:
			tiny_nd6_prefix_list_init();
			break;
		case TINY_BUFFER_STATUS:
			/* dangerous */
			break;
		default:
			return ENXIO;
			break;
		}
		break;
	case TINY_GHOSTVARS:
		{
			struct tiny_hostvars *hv = (struct tiny_hostvars *)data;
			tiny_get_hostvars(hv);
		}			
		break;
	case TINY_SHOSTVARS:
		{
			struct tiny_hostvars *hv = (struct tiny_hostvars *)data;
			tiny_set_hostvars(hv);
		}
		break;
	case TINY_GSOCKOPTS:
		{
			struct tiny_sockopts *opt = (struct tiny_sockopts *)data;
			tiny_getsockopt(opt->so, opt->code, opt->arg);
		}
		break;
	case TINY_SSOCKOPTS:
		{
			struct tiny_sockopts *opt = (struct tiny_sockopts *)data;
			tiny_setsockopt(opt->so, opt->code, opt->arg);
		}
		break;
	default:
		return ENXIO;
	}
	return (0);
}
/*
 * You also need read, write, open, close routines.
 * This should get you started
 */
int
tinyopen(dev_t dev, int oflags, int devtype, struct proc *p)
{
	int unit = UNIT(dev);
	struct tiny_softc *sc = tinysc[unit];
	
	CHECKUNIT(ENXIO);

	/* 
	 * Do processing
	 */
	if (sc->busy != 0) {
		return (EBUSY);
	}
	sc->busy = 1;
	return (0);
}

int
tinyclose(dev_t dev, int fflag, int devtype, struct proc *p)
{
	int unit = UNIT(dev);
	struct tiny_softc *sc = tinysc[unit];
	
	CHECKUNIT_DIAG(ENXIO);

	/* 
	 * Do processing
	 */
	sc->busy = 0;
	return (0);
}

int
tinyread(dev_t dev, struct uio *uio, int ioflag)
{
	int unit = UNIT(dev);
	struct tiny_softc *sc = tinysc[unit];
	int rv = 0;
	static char buf[sizeof(struct tiny_ipsec_repository)];
	int size;
	int len;
	
	CHECKUNIT_DIAG(ENXIO);

	/* 
	 * Do processing
	 */
	switch (unit) {
	case TINY_NEIGHBOR_CACHE:
		len = tiny_nd6_print_ndcache_list(buf, sizeof(buf));
		size = TINY_MIN(len, uio->uio_resid);
		rv = uiomove(buf, size, uio);
		break;
	case TINY_IPSEC_DB:
		size = tiny_ipsecdb_read(buf, sizeof(buf));
		if (size != sizeof(buf)) {
			rv = EIO;
		}
		else {
			size = TINY_MIN(sizeof(buf), uio->uio_resid);
			rv = uiomove(buf, size, uio);
		}
		break;
	case TINY_DEFROUTER_LIST:
		len = tiny_nd6_print_defrouter_list(buf, sizeof(buf));
		size = TINY_MIN(len, uio->uio_resid);
		rv = uiomove(buf, size, uio);
		break;
	case TINY_PREFIX_LIST:
		len = tiny_nd6_print_prefix_list(buf, sizeof(buf));
		size = TINY_MIN(len, uio->uio_resid);
		rv = uiomove(buf, size, uio);
		break;
	case TINY_IF_ADDRESS:
		len = tiny_print_physif_addrlist(buf, sizeof(buf));
		size = TINY_MIN(len, uio->uio_resid);
		rv = uiomove(buf, TINY_MIN(size, uio->uio_resid), uio);
		break;
	case TINY_BUFFER_STATUS:
		len = tiny_print_buffer_status(buf, sizeof(buf));
		size = TINY_MIN(len, uio->uio_resid);
		rv = uiomove(buf, TINY_MIN(size, uio->uio_resid), uio);
		break;
	default:
		rv = EIO;
		break;
	}

	return rv;
}

int
tinywrite(dev_t dev, struct uio *uio, int ioflag)
{
	int unit = UNIT(dev);
	struct tiny_softc *sc = tinysc[unit];
	int rv = 0;
	int size;
	char buf[sizeof(struct tiny_ipsec_repository)];
	
	CHECKUNIT_DIAG(ENXIO);

	/* 
	 * Do processing
	 */
	switch (unit) {
	case TINY_IPSEC_DB:
		size = TINY_MIN((int)sizeof(buf), uio->uio_resid);
		rv = uiomove(buf, size, uio);
		size = tiny_ipsecdb_write(buf, sizeof(buf));
		if (size != sizeof(buf)) {
			printf("invalid data size(%d)\n", size);
			rv = EIO;
		}
		break;
	default:
		rv = EIO;
		break;
	}

	return rv;
}

/*
 * Now  for some driver initialisation.
 * Occurs ONCE during boot (very early).
 */
static void             
tiny_drvinit(void *unused)
{
	dev_t dev;
	int	unit;
	int maj;

	/* search device major number from cdevsw */
	for (maj = 0; maj < nchrdev; maj ++) {
		if (cdevsw[maj].d_open == tinyopen) {
			break;
		}
	}

	for (unit = 0; unit < NTINY; unit ++) {
		struct tiny_softc *sc;
		tinysc[unit] = malloc(sizeof(*sc), M_DEVBUF, M_NOWAIT);
		sc = tinysc[unit];
		if (sc == NULL) {
			printf("unable to allocate softc\n");
			return;
		}
		bzero(sc, sizeof(*sc));
		sc->sc_dev.dv_unit = unit;
		dev = makedev(maj, sc->sc_dev.dv_unit);
	}
}

void tinyattach(dev_t dev);
void
tinyattach(dev_t dev)
{
	printf("tinyattach()\n");
	tiny_drvinit(NULL);
}



/*
Local Variables:
mode: C++
tab-width: 4
c-basic-offset: 4
End:
*/
