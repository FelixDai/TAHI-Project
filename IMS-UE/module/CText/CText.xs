#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <stdio.h>
#include <stdlib.h>
#include <sys/param.h>
#include <sys/disklabel.h>

#include <ufs/ufs/dinode.h>
#include <ufs/ffs/fs.h>
#include <libufs.h>
#include <stdint.h>

#include <openssl/hmac.h>
#include <openssl/md5.h>
#include <openssl/sha.h>

#define	afs	disk.d_fs
#define	acg	disk.d_cg

typedef unsigned char u8;

static int hex2num(char c)
{
	if (c >= '0' && c <= '9')
		return c - '0';
	if (c >= 'a' && c <= 'f')
		return c - 'a' + 10;
	if (c >= 'A' && c <= 'F')
		return c - 'A' + 10;
	return -1;
}
static int hex2byte(const char *hex)
{
	int a, b;
	a = hex2num(*hex++);
	if (a < 0)
		return -1;
	b = hex2num(*hex++);
	if (b < 0)
		return -1;
	return (a << 4) | b;
}
static int hexstr2bin(const char *hex, u8 *buf, size_t len)
{
	size_t i;
	int a;
	const char *ipos = hex;
	u8 *opos = buf;

	for (i = 0; i < len; i++) {
		a = hex2byte(ipos);
		if (a < 0)
			return -1;
		*opos++ = a;
		ipos += 2;
	}
	return 0;
}
static int bin2hexstr(u8 *buf, char *hex, size_t len )
{
    int i;
    for(i=0;i<len;i++){
	sprintf(hex,"%02x",*buf);
	buf++;
	hex+=2;
    }
    *hex=0;
}


/*--------------------------- prototypes --------------------------*/

void static MilenageF1In ( u8 op[16], u8 k[16], u8 rand[16], u8 sqn[6], u8 amf[2], u8 mac_a[8] );
void static MilenageF2345In ( u8 op[16], u8 k[16], u8 rand[16], u8 res[8], u8 ck[16], u8 ik[16], u8 ak[6] );
void static MilenageF1starIn( u8 op[16], u8 k[16], u8 rand[16], u8 sqn[6], u8 amf[2], u8 mac_s[8] );
void static MilenageF5starIn( u8 op[16], u8 k[16], u8 rand[16], u8 ak[6] );
void static ComputeOPcIn( u8 op[16], u8 op_c[16] );
void static MilenageXORIn( u8 v1[], u8 v2[], u8 v3[], int size );
void static RijndaelKeySchedule( u8 key[16] );
void static RijndaelEncrypt( u8 input[16], u8 output[16] );

void static MilenageF1In ( u8 op[16], u8 k[16], u8 rand[16], u8 sqn[6], u8 amf[2], u8 mac[8] )
{
    u8 op_c[16];
    u8 temp[16];
    u8 in1[16];
    u8 out1[16];
    u8 rijndaelInput[16];
    u8 i;
    
    RijndaelKeySchedule( k );
    
    ComputeOPcIn( op, op_c );
    
    for (i=0; i<16; i++)
	rijndaelInput[i] = rand[i] ^ op_c[i];
    RijndaelEncrypt( rijndaelInput, temp );
    
    for (i=0; i<6; i++)
    {
	in1[i]    = sqn[i];
	in1[i+8]  = sqn[i];
    }
    for (i=0; i<2; i++)
    {
	in1[i+6]  = amf[i];
	in1[i+14] = amf[i];
    }
    
    /* XOR op_c and in1, rotate by r1=64, and XOR *
	* on the constant c1 (which is all zeroes)   */
	
	for (i=0; i<16; i++)
	rijndaelInput[(i+8) % 16] = in1[i] ^ op_c[i];
    
    /* XOR on the value temp computed before */
	
	for (i=0; i<16; i++)
	rijndaelInput[i] ^= temp[i];
    
    RijndaelEncrypt( rijndaelInput, out1 );
    for (i=0; i<16; i++)
	out1[i] ^= op_c[i];
    
    for (i=0; i<8; i++)
	mac[i] = out1[i];
    
    return;
} 

void static MilenageF2345In ( u8 op[16], u8 k[16], u8 rand[16], u8 res[8], u8 ck[16], u8 ik[16], u8 ak[6] )
{
  u8 op_c[16];
  u8 temp[16];
  u8 out[16];
  u8 rijndaelInput[16];
  u8 i;

  RijndaelKeySchedule( k );

  ComputeOPcIn( op, op_c );

  for (i=0; i<16; i++)
    rijndaelInput[i] = rand[i] ^ op_c[i];
  RijndaelEncrypt( rijndaelInput, temp );

  /* To obtain output block OUT2: XOR OPc and TEMP,    *
   * rotate by r2=0, and XOR on the constant c2 (which *
   * is all zeroes except that the last bit is 1).     */

  for (i=0; i<16; i++)
    rijndaelInput[i] = temp[i] ^ op_c[i];
  rijndaelInput[15] ^= 1;

  RijndaelEncrypt( rijndaelInput, out );
  for (i=0; i<16; i++)
    out[i] ^= op_c[i];

  for (i=0; i<8; i++)
    res[i] = out[i+8];
  for (i=0; i<6; i++)
    ak[i]  = out[i];

  /* To obtain output block OUT3: XOR OPc and TEMP,        *
   * rotate by r3=32, and XOR on the constant c3 (which    *
   * is all zeroes except that the next to last bit is 1). */

  for (i=0; i<16; i++)
    rijndaelInput[(i+12) % 16] = temp[i] ^ op_c[i];
  rijndaelInput[15] ^= 2;

  RijndaelEncrypt( rijndaelInput, out );
  for (i=0; i<16; i++)
    out[i] ^= op_c[i];

  for (i=0; i<16; i++)
    ck[i] = out[i];

  /* To obtain output block OUT4: XOR OPc and TEMP,         *
   * rotate by r4=64, and XOR on the constant c4 (which     *
   * is all zeroes except that the 2nd from last bit is 1). */

  for (i=0; i<16; i++)
    rijndaelInput[(i+8) % 16] = temp[i] ^ op_c[i];
  rijndaelInput[15] ^= 4;

  RijndaelEncrypt( rijndaelInput, out );
  for (i=0; i<16; i++)
    out[i] ^= op_c[i];

  for (i=0; i<16; i++)
    ik[i] = out[i];

  return;
} 

void static MilenageF1starIn( u8 op[16], u8 k[16], u8 rand[16], u8 sqn[6], u8 amf[2], u8 mac_s[8] )
{
  u8 op_c[16];
  u8 temp[16];
  u8 in1[16];
  u8 out1[16];
  u8 rijndaelInput[16];
  u8 i;

  RijndaelKeySchedule( k );

  ComputeOPcIn( op, op_c );

  for (i=0; i<16; i++)
    rijndaelInput[i] = rand[i] ^ op_c[i];
  RijndaelEncrypt( rijndaelInput, temp );

  for (i=0; i<6; i++)
  {
    in1[i]    = sqn[i];
    in1[i+8]  = sqn[i];
  }
  for (i=0; i<2; i++)
  {
    in1[i+6]  = amf[i];
    in1[i+14] = amf[i];
  }

  /* XOR op_c and in1, rotate by r1=64, and XOR *
   * on the constant c1 (which is all zeroes)   */

  for (i=0; i<16; i++)
    rijndaelInput[(i+8) % 16] = in1[i] ^ op_c[i];

  /* XOR on the value temp computed before */

  for (i=0; i<16; i++)
    rijndaelInput[i] ^= temp[i];
  
  RijndaelEncrypt( rijndaelInput, out1 );
  for (i=0; i<16; i++)
    out1[i] ^= op_c[i];

  for (i=0; i<8; i++)
    mac_s[i] = out1[i+8];

  return;
}

void static MilenageF5starIn( u8 op[16], u8 k[16], u8 rand[16], u8 ak[6] )
{
  u8 op_c[16];
  u8 temp[16];
  u8 out[16];
  u8 rijndaelInput[16];
  u8 i;

  RijndaelKeySchedule( k );

  ComputeOPcIn( op, op_c );

  for (i=0; i<16; i++)
    rijndaelInput[i] = rand[i] ^ op_c[i];
  RijndaelEncrypt( rijndaelInput, temp );

  /* To obtain output block OUT5: XOR OPc and TEMP,         *
   * rotate by r5=96, and XOR on the constant c5 (which     *
   * is all zeroes except that the 3rd from last bit is 1). */

  for (i=0; i<16; i++)
    rijndaelInput[(i+4) % 16] = temp[i] ^ op_c[i];
  rijndaelInput[15] ^= 8;

  RijndaelEncrypt( rijndaelInput, out );
  for (i=0; i<16; i++)
    out[i] ^= op_c[i];

  for (i=0; i<6; i++)
    ak[i] = out[i];

  return;
} 

void static ComputeOPcIn( u8 op[16], u8 op_c[16] )
{
  u8 i;
  
  RijndaelEncrypt( op, op_c );
  for (i=0; i<16; i++)
    op_c[i] ^= op[i];

  return;
} /* end of function ComputeOPc */


/* SQN = (SQN ^ AK) */
void static MilenageXORIn( u8 v1[], u8 v2[], u8 v3[], int size )
{
  u8 i;

  for (i = 0; i < size; i++)
      v3[i] = v1[i] ^ v2[i];

  return;
} 



/*-------------------- Rijndael round subkeys ---------------------*/
u8 roundKeys[11][4][4];

/*--------------------- Rijndael S box table ----------------------*/
u8 S[256] = {
 99,124,119,123,242,107,111,197, 48,  1,103, 43,254,215,171,118,
202,130,201,125,250, 89, 71,240,173,212,162,175,156,164,114,192,
183,253,147, 38, 54, 63,247,204, 52,165,229,241,113,216, 49, 21,
  4,199, 35,195, 24,150,  5,154,  7, 18,128,226,235, 39,178,117,
  9,131, 44, 26, 27,110, 90,160, 82, 59,214,179, 41,227, 47,132,
 83,209,  0,237, 32,252,177, 91,106,203,190, 57, 74, 76, 88,207,
208,239,170,251, 67, 77, 51,133, 69,249,  2,127, 80, 60,159,168,
 81,163, 64,143,146,157, 56,245,188,182,218, 33, 16,255,243,210,
205, 12, 19,236, 95,151, 68, 23,196,167,126, 61,100, 93, 25,115,
 96,129, 79,220, 34, 42,144,136, 70,238,184, 20,222, 94, 11,219,
224, 50, 58, 10, 73,  6, 36, 92,194,211,172, 98,145,149,228,121,
231,200, 55,109,141,213, 78,169,108, 86,244,234,101,122,174,  8,
186,120, 37, 46, 28,166,180,198,232,221,116, 31, 75,189,139,138,
112, 62,181,102, 72,  3,246, 14, 97, 53, 87,185,134,193, 29,158,
225,248,152, 17,105,217,142,148,155, 30,135,233,206, 85, 40,223,
140,161,137, 13,191,230, 66,104, 65,153, 45, 15,176, 84,187, 22,
};

/*------- This array does the multiplication by x in GF(2^8) ------*/
u8 Xtime[256] = {
  0,  2,  4,  6,  8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30,
 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62,
 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94,
 96, 98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,
128,130,132,134,136,138,140,142,144,146,148,150,152,154,156,158,
160,162,164,166,168,170,172,174,176,178,180,182,184,186,188,190,
192,194,196,198,200,202,204,206,208,210,212,214,216,218,220,222,
224,226,228,230,232,234,236,238,240,242,244,246,248,250,252,254,
 27, 25, 31, 29, 19, 17, 23, 21, 11,  9, 15, 13,  3,  1,  7,  5,
 59, 57, 63, 61, 51, 49, 55, 53, 43, 41, 47, 45, 35, 33, 39, 37,
 91, 89, 95, 93, 83, 81, 87, 85, 75, 73, 79, 77, 67, 65, 71, 69,
123,121,127,125,115,113,119,117,107,105,111,109, 99, 97,103,101,
155,153,159,157,147,145,151,149,139,137,143,141,131,129,135,133,
187,185,191,189,179,177,183,181,171,169,175,173,163,161,167,165,
219,217,223,221,211,209,215,213,203,201,207,205,195,193,199,197,
251,249,255,253,243,241,247,245,235,233,239,237,227,225,231,229
};


/*-------------------------------------------------------------------
 *  Rijndael key schedule function.  Takes 16-byte key and creates 
 *  all Rijndael's internal subkeys ready for encryption.
 *-----------------------------------------------------------------*/

void static RijndaelKeySchedule( u8 key[16] )
{
  u8 roundConst;
  int i, j;

  /* first round key equals key */
  for (i=0; i<16; i++)
    roundKeys[0][i & 0x03][i>>2] = key[i];

  roundConst = 1;

  /* now calculate round keys */
  for (i=1; i<11; i++)
  {
    roundKeys[i][0][0] = S[roundKeys[i-1][1][3]]
                         ^ roundKeys[i-1][0][0] ^ roundConst;
    roundKeys[i][1][0] = S[roundKeys[i-1][2][3]]
                         ^ roundKeys[i-1][1][0];
    roundKeys[i][2][0] = S[roundKeys[i-1][3][3]]
                         ^ roundKeys[i-1][2][0];
    roundKeys[i][3][0] = S[roundKeys[i-1][0][3]]
                         ^ roundKeys[i-1][3][0];

    for (j=0; j<4; j++)
    {
      roundKeys[i][j][1] = roundKeys[i-1][j][1] ^ roundKeys[i][j][0];
      roundKeys[i][j][2] = roundKeys[i-1][j][2] ^ roundKeys[i][j][1];
      roundKeys[i][j][3] = roundKeys[i-1][j][3] ^ roundKeys[i][j][2];
    }

    /* update round constant */
    roundConst = Xtime[roundConst];
  }

  return;
} /* end of function RijndaelKeySchedule */


/* Round key addition function */
void KeyAdd(u8 state[4][4], u8 roundKeys[11][4][4], int round)
{
  int i, j;

  for (i=0; i<4; i++)
    for (j=0; j<4; j++)
      state[i][j] ^= roundKeys[round][i][j];

  return;
}


/* Byte substitution transformation */
int ByteSub(u8 state[4][4])
{
  int i, j;

  for (i=0; i<4; i++)
    for (j=0; j<4; j++)
      state[i][j] = S[state[i][j]];
  
  return 0;
}


/* Row shift transformation */
void ShiftRow(u8 state[4][4])
{
  u8 temp;

  /* left rotate row 1 by 1 */
  temp = state[1][0];
  state[1][0] = state[1][1];
  state[1][1] = state[1][2];
  state[1][2] = state[1][3];
  state[1][3] = temp;

  /* left rotate row 2 by 2 */
  temp = state[2][0];
  state[2][0] = state[2][2];
  state[2][2] = temp;
  temp = state[2][1];
  state[2][1] = state[2][3];
  state[2][3] = temp;

  /* left rotate row 3 by 3 */
  temp = state[3][0];
  state[3][0] = state[3][3];
  state[3][3] = state[3][2];
  state[3][2] = state[3][1];
  state[3][1] = temp;

  return;
}


/* MixColumn transformation*/
void MixColumn(u8 state[4][4])
{
  u8 temp, tmp, tmp0;
  int i;

  /* do one column at a time */
  for (i=0; i<4;i++)
  {
    temp = state[0][i] ^ state[1][i] ^ state[2][i] ^ state[3][i];
    tmp0 = state[0][i];

    /* Xtime array does multiply by x in GF2^8 */
    tmp = Xtime[state[0][i] ^ state[1][i]];
    state[0][i] ^= temp ^ tmp;

    tmp = Xtime[state[1][i] ^ state[2][i]];
    state[1][i] ^= temp ^ tmp;

    tmp = Xtime[state[2][i] ^ state[3][i]];
    state[2][i] ^= temp ^ tmp;

    tmp = Xtime[state[3][i] ^ tmp0];
    state[3][i] ^= temp ^ tmp;
  }

  return;
}


/*-------------------------------------------------------------------
 *  Rijndael encryption function.  Takes 16-byte input and creates 
 *  16-byte output (using round keys already derived from 16-byte 
 *  key).
 *-----------------------------------------------------------------*/

void static RijndaelEncrypt( u8 input[16], u8 output[16] )
{
  u8 state[4][4];
  int i, r;

  /* initialise state array from input byte string */
  for (i=0; i<16; i++)
    state[i & 0x3][i>>2] = input[i];

  /* add first round_key */
  KeyAdd(state, roundKeys, 0);
  
  /* do lots of full rounds */
  for (r=1; r<=9; r++)
  {
    ByteSub(state);
    ShiftRow(state);
    MixColumn(state);
    KeyAdd(state, roundKeys, r);
  }

  /* final round */
  ByteSub(state);
  ShiftRow(state);
  KeyAdd(state, roundKeys, r);

  /* produce output byte string from state array */
  for (i=0; i<16; i++)
  {
    output[i] = state[i & 0x3][i>>2];
  }

  return;
} /* end of function RijndaelEncrypt */



/*-------------------------------------------------------------------
 *                      Rijndael Implementation
 *-------------------------------------------------------------------
 *
 *  A sample 32-bit orientated implementation of Rijndael, the
 *  suggested kernel for the example 3GPP authentication and key
 *  agreement functions.
 *
 *  This implementation draws on the description in section 5.2 of
 *  the AES proposal and also on the implementation by
 *  Dr B. R. Gladman <brg@gladman.uk.net> 9th October 2000.
 *  It uses a number of large (4k) lookup tables to implement the
 *  algorithm in an efficient manner.
 *
 *  Note: in this implementation the State is stored in four 32-bit
 *  words, one per column of the State, with the top byte of the
 *  column being the _least_ significant byte of the word.
 *
*-----------------------------------------------------------------*/

// #define LITTLE_ENDIAN	/* For INTEL architecture */

/* Circular byte rotates of 32 bit values */

#define rot1(x) ((x <<  8) | (x >> 24))
#define rot2(x) ((x << 16) | (x >> 16))
#define rot3(x) ((x << 24) | (x >>  8))

/* Extract a byte from a 32-bit u32 */

#define byte0(x)    ((u8)(x))
#define byte1(x)    ((u8)(x >>  8))
#define byte2(x)    ((u8)(x >> 16))
#define byte3(x)    ((u8)(x >> 24))


/* Put or get a 32 bit u32 (v) in machine order from a byte	*
 * address in (x)                                           */

#ifdef  LITTLE_ENDIAN

#define u32_in(x)     (*(u32*)(x))
#define u32_out(x,y)  (*(u32*)(x) = y)

#else

/* Invert byte order in a 32 bit variable */

__inline u32 byte_swap(const u32 x)
{
    return rot1(x) & 0x00ff00ff | rot3(x) & 0xff00ff00;
}
__inline u32 u32_in(const u8 x[])
{
  return byte_swap(*(u32*)x);
};
__inline void u32_out(u8 x[], const u32 v) 
{
  *(u32*)x = byte_swap(v);
};

#endif

int GetFileSsytemID(const char *devname, char *id, char *reverse)
{
  struct uufsd disk;
  time_t  fstime;
  int64_t  fssize;
  int32_t  fsflags;
  int ret = 0;
  
  if (ufs_disk_fillout(&disk, devname) == -1) {
    return 1;
  }
  else{
    switch (disk.d_ufs) {
    case 2:
      fssize = afs.fs_size;
      fstime = afs.fs_time;
      /*
	printf("magic\t%x (UFS2)\ttime\t%s",   afs.fs_magic, ctime(&fstime));
	printf("superblock location\t%jd\tid\t[ %x %x ]\n",   (intmax_t)afs.fs_sblockloc, afs.fs_id[0], afs.fs_id[1]);
	printf("ncg\t%d\tsize\t%jd\tblocks\t%jd\n",   afs.fs_ncg, (intmax_t)fssize, (intmax_t)afs.fs_dsize);
	sv_setiv(magic,afs.fs_magic);
      */
      sprintf(id,"%x:%x",afs.fs_id[0],afs.fs_id[1]);
      sprintf(reverse,"%x:%x",~afs.fs_id[1],~afs.fs_id[0]);
      break;
      
    case 1:
      fssize = afs.fs_old_size;
      fstime = afs.fs_old_time;
      /*
	printf("magic\t%x (UFS1)\ttime\t%s",   afs.fs_magic, ctime(&fstime));
	printf("id\t[ %x %x ]\n",              afs.fs_id[0], afs.fs_id[1]);
	printf("ncg\t%d\tsize\t%jd\tblocks\t%jd\n",   afs.fs_ncg, (intmax_t)fssize, (intmax_t)afs.fs_dsize);
	sv_setiv(magic,afs.fs_magic);
      */
      sprintf(id,"%x:%x",afs.fs_id[0],afs.fs_id[1]);
      sprintf(reverse,"%x:%x",~afs.fs_id[1],~afs.fs_id[0]);
      break;
      
    default:
      ret = 2;
    }
    ufs_disk_close(&disk);
  }
  return ret;
}

MODULE = CText		PACKAGE = CText

PROTOTYPES: ENABLE

int 
ProductCheck(devname,id)
 const char *devname
 const char *id

 CODE:
 {
   /* status  0:ok 1:id-invalid  2:id-can't-get  3:id-empty */
     char idstr[128],reverse[128];
     int status;
     idstr[0]=0;
     status = GetFileSsytemID(devname,idstr,reverse);
     if(status){
       status = 2;
     }
     else if(!idstr[0] || idstr[0]==':'){
       status = 3;
     }
     else{
       status = strcasecmp(id,reverse) ? 1 : 0;
     }
     RETVAL = status;
 }
 OUTPUT:
    RETVAL


int 
GetATPTCode(devname,id1,id2,id3)
 const char *devname
 SV *id1
 SV *id2
 SV *id3
 
 CODE:
 {
     char idstr[128], reverse[128];
     int ret = 0;
     
     ret = GetFileSsytemID(devname,idstr,reverse);
     if(!ret){
	 sv_setpvn(id1, idstr, strlen(idstr));
	 sv_setpvn(id2, reverse, strlen(reverse));
	 sv_setpvn(id3, idstr, strlen(idstr));
     }
     RETVAL = ret;
 }
 OUTPUT:
    id1
    id2
    id3
    RETVAL


void 
HMAC_SHA1(key,data,hash)
 const char *key
 const char *data
 SV *hash

 CODE:
 {
   int i;
   unsigned char *md;
   char digest[SHA_DIGEST_LENGTH*2+10];
   md = HMAC( EVP_sha1(), key,strlen(key), data,strlen(data), NULL,NULL);
   for (i=0; i<SHA_DIGEST_LENGTH; i++)  sprintf(&(digest[i*2]),"%02x",md[i]);
   sv_setpvn(hash, digest, strlen(digest));
}


void 
MilenageF1 ( char *opHex, char* kHex, char *randHex, char *sqnHex, char *amfHex, SV *macSv )
 CODE:
 {
/*-------------------------------------------------------------------
 *                            Algorithm f1
 *-------------------------------------------------------------------
 *
 *  Computes network authentication code MAC-A from key K, random
 *  challenge RAND, sequence number SQN and authentication management
 *  field AMF.
 *
 *-----------------------------------------------------------------*/

    u8 op[16], k[16], rand[16], sqn[6], amf[2], mac[8];
    char macHex[17];
    
    hexstr2bin(opHex,op,16);
    hexstr2bin(kHex,k,16);
    hexstr2bin(randHex,rand,16);
    hexstr2bin(sqnHex,sqn,6);
    hexstr2bin(amfHex,amf,2);

    MilenageF1In ( op, k, rand, sqn, amf, mac );

    bin2hexstr(mac,macHex,8);
    sv_setpvn(macSv, macHex, strlen(macHex));
}

  
void 
MilenageF2345 ( char* opHex, char* kHex, char *randHex, SV* resSv, SV* ckSv, SV* ikSv, SV* akSv )
 CODE:
 {
/*-------------------------------------------------------------------
 *                            Algorithms f2-f5
 *-------------------------------------------------------------------
 *
 *  Takes key K and random challenge RAND, and returns response RES,
 *  confidentiality key CK, integrity key IK and anonymity key AK.
 *
 *-----------------------------------------------------------------*/
    u8 op[16], k[16], rand[16], res[8], ck[16], ik[16], ak[6];
    char resHex[17], ckHex[33], ikHex[33], akHex[13];
    
    hexstr2bin(opHex,op,16);
    hexstr2bin(kHex,k,16);
    hexstr2bin(randHex,rand,16);
   
    MilenageF2345In ( op, k, rand, res, ck, ik, ak );

    bin2hexstr(res,resHex,8);
    bin2hexstr(ck,ckHex,16);
    bin2hexstr(ik,ikHex,16);
    bin2hexstr(ak,akHex,6);
    
    sv_setpvn(resSv, resHex, strlen(resHex));
    sv_setpvn(ckSv, ckHex, strlen(ckHex));
    sv_setpvn(ikSv, ikHex, strlen(ikHex));
    sv_setpvn(akSv, akHex, strlen(akHex));
}

void 
MilenageF1star( char *opHex, char *kHex, char *randHex, char *sqnHex, char *amfHex, SV *macSv )
 CODE:
 {
/*-------------------------------------------------------------------
 *                            Algorithm f1*
 *-------------------------------------------------------------------
 *
 *  Computes resynch authentication code MAC-S from key K, random
 *  challenge RAND, sequence number SQN and authentication management
 *  field AMF.
 *
 *-----------------------------------------------------------------*/
    u8 op[16], k[16], rand[16], sqn[6], amf[2], mac[8];
    char macHex[17];

    hexstr2bin(opHex,op,16);
    hexstr2bin(kHex,k,16);
    hexstr2bin(randHex,rand,16);
    hexstr2bin(sqnHex,sqn,6);
    hexstr2bin(amfHex,amf,2);

    MilenageF1starIn ( op, k, rand, sqn, amf, mac );

    bin2hexstr(mac,macHex,8);
    sv_setpvn(macSv, macHex, strlen(macHex));
}

void 
MilenageF5star( char *opHex, char *kHex, char *randHex, SV *akSv )
 CODE:
 {
/*-------------------------------------------------------------------
 *                            Algorithm f5*
 *-------------------------------------------------------------------
 *
 *  Takes key K and random challenge RAND, and returns resynch
 *  anonymity key AK.
 *
 *-----------------------------------------------------------------*/
    u8 op[16], k[16], rand[16], ak[6];
    char akHex[13];

    hexstr2bin(opHex,op,16);
    hexstr2bin(kHex,k,16);
    hexstr2bin(randHex,rand,16);
    
    MilenageF5starIn( op, k, rand, ak );

    bin2hexstr(ak,akHex,6);
    sv_setpvn(akSv, akHex, strlen(akHex));
}


void 
ComputeOPc( char *opHex, char *kHex, SV *opcSv )
 CODE:
 {
/*-------------------------------------------------------------------
 *  Function to compute OPc from OP and K.  Assumes key schedule has
    already been performed.
 *-----------------------------------------------------------------*/
    u8 op[16], k[16], opc[16];
    char opcHex[33];
    
    hexstr2bin(opHex,op,16);
    hexstr2bin(kHex,k,16);
 
    RijndaelKeySchedule( k );

    ComputeOPcIn( op, opc );

    bin2hexstr(opc,opcHex,16);
    sv_setpvn(opcSv, opcHex, strlen(opcHex));
}


void 
MilenageXOR( char *sqnHex, char *akHex, SV *xsqnSv )
 CODE:
 {
    u8 sqn[6], ak[6], xsqn[6];
    char xsqnHex[13];
    
    hexstr2bin(sqnHex,sqn,6);
    hexstr2bin(akHex,ak,6);
 
    MilenageXORIn( sqn, ak, xsqn, 6 );

    bin2hexstr(xsqn,xsqnHex,6);
    sv_setpvn(xsqnSv, xsqnHex, strlen(xsqnHex));
}


