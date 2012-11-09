#!/usr/bin/perl 

BEGIN {
    $IKELoadPerlMO='';
    if($IKELoadPerlMO){
	eval("use Crypt::Random");
	eval("use Crypt::DH");
	eval("use Math::Pari");
	eval("use Digest::SHA1");
	eval("use Digest::MD5");
	eval("use Digest::HMAC_MD5");
	eval("use Digest::HMAC_SHA1");
    }
}

# use strict;

# 
%IKESAProfile;

# 
$IKE_SUB_PKTDEF   = "ikesub.def";

#============================================
# IKE
#============================================
%IKEDoi=(
# 
    'TI_ETYPE_BASE'              => 1,
    'TI_ETYPE_IDENT'             => 2,
    'TI_ETYPE_AUTH'              => 3,
    'TI_ETYPE_AGG'               => 4,
    'TI_ETYPE_INFO'              => 5,
    'TI_ETYPE_QUICK'             => 32,
    'TI_ETYPE_NEWGRP'            => 33,

# ATTR_ENC_ALG
    'TI_ATTR_ENC_ALG_DES'        => 1,
    'TI_ATTR_ENC_ALG_IDEA'       => 2,
    'TI_ATTR_ENC_ALG_BLOWFISH'   => 3,
    'TI_ATTR_ENC_ALG_RC5'        => 4,
    'TI_ATTR_ENC_ALG_3DES'       => 5,
    'TI_ATTR_ENC_ALG_CAST'       => 6,

# 
    'TI_ATTR_HASH_ALG_MD5'       => 1,
    'TI_ATTR_HASH_ALG_SHA'       => 2,
    'TI_ATTR_HASH_ALG_TIGER'     => 3,

# 
    'TI_ATTR_AUTH_METHOD_PSKEY'  => 1,
    'TI_ATTR_AUTH_METHOD_DSSSIG' => 2,
    'TI_ATTR_AUTH_METHOD_RSASIG' => 3,
    'TI_ATTR_AUTH_METHOD_RSAENC' => 4,
    'TI_ATTR_AUTH_METHOD_RSAREV' => 5,

# 
    'TI_ATTR_AUTH_HMAC_MD5'      => 1,
    'TI_ATTR_AUTH_HMAC_SHA'      => 2,
    'TI_ATTR_AUTH_DES_MAC'       => 3,
    'TI_ATTR_AUTH_KPDK'          => 4,

# ATTR_PH1_GRP_DESC, ATTR_PH2_GRP_DESC
    'TI_ATTR_GRP_DESC_MODP768'   => 1,
    'TI_ATTR_GRP_DESC_MODP1024'  => 2,
    'TI_ATTR_GRP_DESC_EC2N155'   => 3,
    'TI_ATTR_GRP_DESC_EC2N185'   => 4,

# ATTR_PH1_SA_LD_TYPE, ATTR_PH2_SA_LD_TYPE
    'TI_ATTR_SA_LD_TYPE_SEC'     => 1,
    'TI_ATTR_SA_LD_TYPE_KB'      => 2,

# 
    'TI_ID_IPV4_ADDR'            => 1,
    'TI_ID_FQDN'                 => 2,
    'TI_ID_USER_FQDN'            => 3,
    'TI_ID_IPV4_ADDR_SUBNET'     => 4,
    'TI_ID_IPV6_ADDR'            => 5,
    'TI_ID_IPV6_ADDR_SUBNET'     => 6,
    'TI_ID_IPV4_ADDR_RANGE'      => 7,
    'TI_ID_IPV6_ADDR_RANGE'      => 8,
    'TI_ID_DER_ASN1_DN'          => 9,
    'TI_ID_DER_ASN1_GN'          => 10,
    'TI_ID_KEY_ID'               => 11,

# IPsec SA
    'TI_ATTR_ENC_MODE_TUNNEL'    => 1,
    'TI_ATTR_ENC_MODE_TRNS'      => 2,

# PROTO
    'TI_PROTO_ISAKMP'            => 1,
    'TI_PROTO_IPSEC_AH'          => 2,
    'TI_PROTO_IPSEC_ESP'         => 3,
    'TI_PROTO_IPCOMP'            => 4,

# 
    'TI_ISAKMP_KEY_IKE'          => 1,

# 
    'TI_AH_ALG_MD5'              => 2,
    'TI_AH_ALG_SHA'              => 3,
    'TI_AH_ALG_DES'              => 4,

# 
    'TI_ESP_ALG_DES_IV64'        => 1,
    'TI_ESP_ALG_DES'             => 2,
    'TI_ESP_ALG_3DES'            => 3,
    'TI_ESP_ALG_RC5'             => 4,
    'TI_ESP_ALG_IDEA'            => 5,
    'TI_ESP_ALG_CAST'            => 6,
    'TI_ESP_ALG_BLOWFISH'        => 7,
    'TI_ESP_ALG_3IDEA'           => 8,
    'TI_ESP_ALG_DES_IV32'        => 9,
    'TI_ESP_ALG_RC4'             => 10,
    'TI_ESP_ALG_NULL'            => 11,

# ISAKMP SA
    'TI_ISAKMP_ENC_ALG'         => 1,
    'TI_ISAKMP_HASH_ALG'        => 2,
    'TI_ISAKMP_AUTH_METHOD'     => 3,
    'TI_ISAKMP_GRP_DESC'        => 4,
    'TI_ISAKMP_GRP_TYPE'        => 5,
    'TI_ISAKMP_GRP_PI'          => 6,
    'TI_ISAKMP_GRP_GEN_ONE'     => 7,
    'TI_ISAKMP_GRP_GEN_TWO'     => 8,
    'TI_ISAKMP_GRP_CURVE_A'     => 9,
    'TI_ISAKMP_GRP_CURVE_B'     =>10,
    'TI_ISAKMP_SA_LD_TYPE'      =>11,
    'TI_ISAKMP_SA_LD'           =>12,
    'TI_ISAKMP_PRF'             =>13,
    'TI_ISAKMP_KEY_LEN'         =>14,
    'TI_ISAKMP_FIELD_SIZE'      =>15,
    'TI_ISAKMP_GRP_ORDER'       =>16,
    'TI_ISAKMP_BLOCK_SIZE'      =>17,

# IPSec SA
    'TI_IPSEC_SA_LD_TYPE'      => 1,
    'TI_IPSEC_SA_LD'           => 2,
    'TI_IPSEC_GRP_DESC'        => 3,
    'TI_IPSEC_ENC_MODE'        => 4,
    'TI_IPSEC_AUTH'            => 5,
    'TI_IPSEC_KEY_LENGTH'      => 6,
    'TI_IPSEC_KEY_ROUNDS'      => 7,
    'TI_IPSEC_COMP_DICT_SIZE'  => 8,
    'TI_IPSEC_COMP_PRIVALG'    => 9,

# 
    'NX_PAYLOAD_NONE'           =>0,
    'NX_PAYLOAD_SA'             =>1,
    'NX_PAYLOAD_P'              =>2,
    'NX_PAYLOAD_T'              =>3,
    'NX_PAYLOAD_KE'             =>4,
    'NX_PAYLOAD_ID'             =>5,
    'NX_PAYLOAD_CERT'           =>6,
    'NX_PAYLOAD_CR'             =>7,
    'NX_PAYLOAD_HASH'           =>8,
    'NX_PAYLOAD_SIG'            =>9,
    'NX_PAYLOAD_NONCE'          =>10,
    'NX_PAYLOAD_N'              =>11,
    'NX_PAYLOAD_D'              =>12,
    'NX_PAYLOAD_VID'            =>13,
    'NX_PAYLOAD_MAX'            =>14,

# 
    'PROTO_ICMP'		=>1,
    'PROTO_IGMP'		=>2,
    'PROTO_GGP'			=>3,
    'PROTO_IPV4'		=>4 ,
    'PROTO_IPIP'		=>4,
    'PROTO_TCP'			=>6,
    'PROTO_ST'			=>7,
    'PROTO_EGP'			=>8,
    'PROTO_PIGP'		=>9,
    'PROTO_RCCMON'		=>10,
    'PROTO_NVPII'		=>11,
    'PROTO_PUP'			=>12,
    'PROTO_ARGUS'		=>13,
    'PROTO_EMCON'		=>14,
    'PROTO_XNET'		=>15,
    'PROTO_CHAOS'		=>16,
    'PROTO_UDP'			=>17,
    'PROTO_MUX'			=>18,
    'PROTO_MEAS'		=>19,
    'PROTO_HMP'			=>20,
    'PROTO_PRM'			=>21,
    'PROTO_IDP'			=>22,
    'PROTO_TRUNK1'		=>23,
    'PROTO_TRUNK2'		=>24,
    'PROTO_LEAF1'		=>25,
    'PROTO_LEAF2'		=>26,
    'PROTO_RDP'			=>27,
    'PROTO_IRTP'		=>28,
    'PROTO_TP'			=>29 ,
    'PROTO_BLT'			=>30,
    'PROTO_NSP'			=>31,
    'PROTO_INP'			=>32,
    'PROTO_SEP'			=>33,
    'PROTO_3PC'			=>34,
    'PROTO_IDPR'		=>35,
    'PROTO_XTP'			=>36,
    'PROTO_DDP'			=>37,
    'PROTO_CMTP'		=>38,
    'PROTO_TPXX'		=>39,
    'PROTO_IL'			=>40,
    'PROTO_IPV6'		=>41,
    'PROTO_SDRP'		=>42,
    'PROTO_ROUTING'		=>43,
    'PROTO_FRAGMENT'		=>44,
    'PROTO_IDRP'		=>45,
    'PROTO_RSVP'		=>46,
    'PROTO_GRE'			=>47,
    'PROTO_MHRP'		=>48,
    'PROTO_BHA'			=>49,
    'PROTO_ESP'			=>50,
    'PROTO_AH'			=>51,
    'PROTO_INLSP'		=>52,
    'PROTO_SWIPE'		=>53,
    'PROTO_NHRP'		=>54,
    'PROTO_MOBILE'		=>55,
    'PROTO_TLSP'		=>56,
    'PROTO_SKIP'		=>57,
    'PROTO_ICMPV6'		=>58,
    'PROTO_NONE'		=>59,
    'PROTO_DSTOPTS'		=>60,
    'PROTO_AHIP'		=>61,
    'PROTO_CFTP'		=>62,
    'PROTO_MOBILITY'		=>62,
    'PROTO_HELLO'		=>63,
    'PROTO_SATEXPAK'		=>64,
    'PROTO_KRYPTOLAN'		=>65,
    'PROTO_RVD'			=>66,
    'PROTO_IPPC'		=>67,
    'PROTO_ADFS'		=>68,
    'PROTO_SATMON'		=>69,
    'PROTO_VISA'		=>70,
    'PROTO_IPCV'		=>71,
    'PROTO_CPNX'		=>72,
    'PROTO_CPHB'		=>73,
    'PROTO_WSN'			=>74,
    'PROTO_PVP'			=>75,
    'PROTO_BRSATMON'		=>76,
    'PROTO_ND'			=>77,
    'PROTO_WBMON'		=>78,
    'PROTO_WBEXPAK'		=>79,
    'PROTO_EON'			=>80,
    'PROTO_VMTP'		=>81,
    'PROTO_SVMTP'		=>82,
    'PROTO_VINES'		=>83,
    'PROTO_TTP'			=>84,
    'PROTO_IGP'			=>85,
    'PROTO_DGP'			=>86,
    'PROTO_TCF'			=>87,
    'PROTO_IGRP'		=>88,
    'PROTO_OSPFIGP'		=>89,
    'PROTO_SRPC'		=>90,
    'PROTO_LARP'		=>91,
    'PROTO_MTP'			=>92,
    'PROTO_AX25'		=>93,
    'PROTO_IPEIP'		=>94,
    'PROTO_MICP'		=>95,
    'PROTO_SCCSP'		=>96,
    'PROTO_ETHERIP'		=>97,
    'PROTO_ENCAP'		=>98,
    'PROTO_APES'		=>99,
    'PROTO_GMTP'		=>100,
    'PROTO_IPCOMP'		=>108,
    'PROTO_PIM'			=>103,
    'PROTO_PGM'			=>113,
    'PROTO_SCTP'		=>132,
    'PROTO_DIVERT'		=>254,
    'PROTO_RAW'			=>255,

    'INVALID_PAYLOAD_TYPE'      => 1  ,
    'DOI_NOT_SUPPORTED'         => 2  ,
    'SITUATION_NOT_SUPPORTED'   => 3  ,
    'INVALID_COOKIE'            => 4  ,
    'INVALID_MAJOR_VERSION'     => 5  ,
    'INVALID_MINOR_VERSION'     => 6  ,
    'INVALID_EXCHANGE_TYPE'     => 7  ,
    'INVALID_FLAGS'             => 8  ,
    'INVALID_MESSAGE_ID'        => 9  ,
    'INVALID_PROTOCOL_ID'       => 10 ,
    'INVALID_SPI'               => 11 ,
    'INVALID_TRANSFORM_ID'      => 12 ,
    'ATTRIBUTES_NOT_SUPPORTED'  => 13 ,
    'NO_PROPOSAL_CHOSEN'        => 14 ,
    'BAD_PROPOSAL_SYNTAX'       => 15 ,
    'PAYLOAD_MALFORMED'         => 16 ,
    'INVALID_KEY_INFORMATION'   => 17 ,
    'INVALID_ID_INFORMATION'    => 18 ,
    'INVALID_CERT_ENCODING'     => 19 ,
    'INVALID_CERTIFICATE'       => 20 ,
    'BAD_CERT_REQUEST_SYNTAX'   => 21 ,
    'INVALID_CERT_AUTHORITY'    => 22 ,
    'INVALID_HASH_INFORMATION'  => 23 ,
    'AUTHENTICATION_FAILED'     => 24 ,
    'INVALID_SIGNATURE'         => 25 ,
    'ADDRESS_NOTIFICATION'      => 26 ,
    'NOTIFY_SA_LIFETIME'        => 27 ,
    'CERTIFICATE_UNAVAILABLE'   => 28 ,
    'UNSUPPORTED_EXCHANGE_TYPE' => 29 ,
    'UNEQUAL_PAYLOAD_LENGTHS'   => 30 ,
    'CONNECTED'                 => 16384,
    'RESPONDER_LIFETIME'        => 24576,
    'REPLAY_STATUS'             => 24577,
    'INITIAL_CONTACT'           => 24578,
);

%IKENotifyName=(
     1                          => 'INVALID_PAYLOAD_TYPE',
     2                          => 'DOI_NOT_SUPPORTED',
     3                          => 'SITUATION_NOT_SUPPORTED',
     4                          => 'INVALID_COOKIE',
     5                          => 'INVALID_MAJOR_VERSION',
     6                          => 'INVALID_MINOR_VERSION',
     7                          => 'INVALID_EXCHANGE_TYPE',
     8                          => 'INVALID_FLAGS',
     9                          => 'INVALID_MESSAGE_ID',
     10                         => 'INVALID_PROTOCOL_ID',
     11                         => 'INVALID_SPI',
     12                         => 'INVALID_TRANSFORM_ID',
     13                         => 'ATTRIBUTES_NOT_SUPPORTED',
     14                         => 'NO_PROPOSAL_CHOSEN',
     15                         => 'BAD_PROPOSAL_SYNTAX',
     16                         => 'PAYLOAD_MALFORMED',
     17                         => 'INVALID_KEY_INFORMATION',
     18                         => 'INVALID_ID_INFORMATION',
     19                         => 'INVALID_CERT_ENCODING',
     20                         => 'INVALID_CERTIFICATE',
     21                         => 'BAD_CERT_REQUEST_SYNTAX',
     22                         => 'INVALID_CERT_AUTHORITY',
     23                         => 'INVALID_HASH_INFORMATION',
     24                         => 'AUTHENTICATION_FAILED',
     25                         => 'INVALID_SIGNATURE',
     26                         => 'ADDRESS_NOTIFICATION',
     27                         => 'NOTIFY_SA_LIFETIME',
     28                         => 'CERTIFICATE_UNAVAILABLE',
     29                         => 'UNSUPPORTED_EXCHANGE_TYPE',
     30                         => 'UNEQUAL_PAYLOAD_LENGTHS',
     16384                      => 'CONNECTED',
     24576                      => 'RESPONDER_LIFETIME',
     24577                      => 'REPLAY_STATUS',
     24578                      => 'INITIAL_CONTACT',
);
%IKEEtypeName=(
    1  => 'BASE',
    2  => 'IDENT',
    3  => 'AUTH',
    4  => 'AGG',
    5  => 'INFO',
    32 => 'QUICK',
    33 => 'NEWGRP',
);

#============================================
# 
#============================================
# 
$IKESATimeout=28800;
$IPSecSATimeout=28800;
%IKEDefaultPH1SA=(
    'ID'                  => {'TY'=>'require','VM'=>'real'},
    'PHASE'               => {'TY'=>'require','VM'=>'real'},
    'ETYPE'               => {'TY'=>'fix',    'VM'=>'label','VL'=>'TI_ETYPE_AGG'},
    'TN_IP_ADDR'          => {'TY'=>'require','VM'=>'real'},
    'NUT_IP_ADDR'         => {'TY'=>'require','VM'=>'real'},
    'TN_ETHER_ADDR'       => {'TY'=>'op',     'VM'=>'real', 'VL'=>'tnether()'},
    'NUT_ETHER_ADDR'      => {'TY'=>'op',     'VM'=>'real', 'VL'=>'nutether()'},
    'ATTR_ENC_ALG'        => {'TY'=>'op',     'VM'=>'label','VL'=>'TI_ATTR_ENC_ALG_3DES',
			      'VR'=>['TI_ATTR_ENC_ALG_3DES','TI_ATTR_ENC_ALG_DES'],
			      'AT'=>$IKEDoi{'TI_ISAKMP_ENC_ALG'}},
    'ATTR_HASH_ALG'       => {'TY'=>'op',     'VM'=>'label','VL'=>'TI_ATTR_HASH_ALG_SHA',
			      'VR'=>['TI_ATTR_HASH_ALG_SHA','TI_ATTR_HASH_ALG_MD5'],
			      'AT'=>$IKEDoi{'TI_ISAKMP_HASH_ALG'}},
    'ATTR_AUTH_METHOD'    => {'TY'=>'fix',    'VM'=>'label','VL'=>'TI_ATTR_AUTH_METHOD_PSKEY',
			      'AT'=>$IKEDoi{'TI_ISAKMP_AUTH_METHOD'}},
    'ATTR_PH1_GRP_DESC'   => {'TY'=>'op',     'VM'=>'label','VL'=>'TI_ATTR_GRP_DESC_MODP768',
			      'VR'=>['TI_ATTR_GRP_DESC_MODP768','TI_ATTR_GRP_DESC_MODP1024'],
			      'AT'=>$IKEDoi{'TI_ISAKMP_GRP_DESC'}},
    'ATTR_PH1_SA_LD_TYPE' => {'TY'=>'fix',    'VM'=>'label','VL'=>'TI_ATTR_SA_LD_TYPE_SEC','FM'=>'empty',
			      'AT'=>$IKEDoi{'TI_ISAKMP_SA_LD_TYPE'}},
    'ATTR_PH1_SA_LD'      => {'TY'=>'op',     'VM'=>'real', 'VL'=>$IKESATimeout,           'FM'=>'empty',
			      'AT'=>$IKEDoi{'TI_ISAKMP_SA_LD'}},
    'TN_ID_TYPE'          => {'TY'=>'require','VM'=>'label','VR'=>['TI_ID_FQDN','TI_ID_USER_FQDN','TI_ID_IPV6_ADDR']},
    'TN_ID'               => {'TY'=>'require','VM'=>'real'},
    'NUT_ID_TYPE'         => {'TY'=>'require','VM'=>'label','VR'=>['TI_ID_FQDN','TI_ID_USER_FQDN','TI_ID_IPV6_ADDR']},
    'NUT_ID'              => {'TY'=>'require','VM'=>'real'},
    'PSK'                 => {'TY'=>'op',     'VM'=>'real', 'VL'=>'PSKey'},
);

%IKEDefaultPH2SA=(
    'ID'                  => {'TY'=>'require','VM'=>'real'},
    'PHASE'               => {'TY'=>'require','VM'=>'real'},
    'ETYPE'               => {'TY'=>'fix',    'VM'=>'label','VL'=>'TI_ETYPE_QUICK'},
    'ISAKMP_SA_ID'        => {'TY'=>'require','VM'=>'real'},
    'TN_ID_ADDR'          => {'TY'=>'require','VM'=>'real'},
    'TN_ID_PORT'          => {'TY'=>'op',     'VM'=>'real', 'VL'=>0},
    'NUT_ID_ADDR'         => {'TY'=>'require','VM'=>'real'},
    'NUT_ID_PORT'         => {'TY'=>'op',     'VM'=>'real', 'VL'=>0},
    'ID_PROTO'            => {'TY'=>'op',     'VM'=>'real', 'VL'=>0},
    'PROTO'               => {'TY'=>'fix',    'VM'=>'label','VL'=>'TI_PROTO_IPSEC_ESP'},
#   'AH_ALG'              => '',
    'ESP_ALG'             => {'TY'=>'op',     'VM'=>'label','VL'=>'TI_ESP_ALG_3DES',
			      'VR'=>['TI_ESP_ALG_3DES','TI_ESP_ALG_DES']},
    'ATTR_ENC_MODE'       => {'TY'=>'op',     'VM'=>'label','VL'=>'TI_ATTR_ENC_MODE_TRNS',
			      'VR'=>['TI_ATTR_ENC_MODE_TUNNEL','TI_ATTR_ENC_MODE_TRNS'],
			      'AT'=>$IKEDoi{'TI_IPSEC_ENC_MODE'}},
    'ATTR_AUTH'           => {'TY'=>'op',     'VM'=>'label','VL'=>'TI_ATTR_AUTH_HMAC_SHA',
			      'VR'=>['TI_ATTR_AUTH_HMAC_SHA','TI_ATTR_AUTH_HMAC_MD5'],
			      'AT'=>$IKEDoi{'TI_IPSEC_AUTH'}},
    'ATTR_PH2_GRP_DESC'   => {'TY'=>'fix',     'VM'=>'label','VL'=>'',
			      'VR'=>['TI_ATTR_GRP_DESC_MODP768','TI_ATTR_GRP_DESC_MODP1024'],
			      'AT'=>$IKEDoi{'TI_IPSEC_GRP_DESC'}},
    'ATTR_PH2_SA_LD_TYPE' => {'TY'=>'fix',    'VM'=>'label','VL'=>'TI_ATTR_SA_LD_TYPE_SEC','FM'=>'empty',
			      'AT'=>$IKEDoi{'TI_IPSEC_SA_LD_TYPE'}},
    'ATTR_PH2_SA_LD'      => {'TY'=>'op',     'VM'=>'real', 'VL'=>$IPSecSATimeout,         'FM'=>'empty',
			      'AT'=>$IKEDoi{'TI_IPSEC_SA_LD'}},
);


#============================================
# IKE
#============================================

# 
$PKT_FMT_UDP=
    "_HETHER_define(IKE_EH_TNtoNUT,%s,%s)\n" .
    'FEM_udp6(IKE_SEND,IKE_EH_TNtoNUT,{SourceAddress=v6("%s");DestinationAddress=v6("%s");},' .
    "\n{SourcePort=%s;DestinationPort=%s;},{header=_HDR_UDP_NAME(IKE_SEND);payload=IKE_SEND_ISAKMP;})\n" .
    'Udp_ISAKMP IKE_SEND_ISAKMP {header=IKE_SEND_ISAKMP_HDR;%s}';
$PKT_FMT_ISAKMP=
    'Hdr_ISAKMP IKE_SEND_ISAKMP_HDR {InitiatorCookie=hexstr("%s");ResponderCookie=hexstr("%s");NextPayload=%s;' . 
    'ExchangeType=%s;CFlag=%s;EFlag=%s;MessageID=%s;}';
$PKT_FMT_SA=
    'Pld_ISAKMP_SA_IPsec_IDonly IKE_SEND_SA {proposal=IKE_SEND_PR;}';
$PKT_FMT_PR=
    'Pld_ISAKMP_P_ANY IKE_SEND_PR {ProtocolID=%s;ProposalNumber=%s;SPI=hexstr("%s");transform=IKE_SEND_TR;NumOfTransforms=1;}';
$PKT_FMT_TR=
    'Pld_ISAKMP_T IKE_SEND_TR {TransformID=%s;TransformNumber=%s;%s}';
$PKT_FMT_TV=
    'Attr_ISAKMP_TV ATT%s {AF=1;Type=%s;Value=%s;}';
$PKT_FMT_TLV=
    'Attr_ISAKMP_TLV ATT%s {AF=0;Type=%s;Value=int2hex(%s,%s);}';
$PKT_FMT_KE=
    'Pld_ISAKMP_KE IKE_SEND_KE {KeyExchangeData=hexstr("%s");}';
$PKT_FMT_IDIPv6=
    'Pld_ISAKMP_ID_ANY IKE_SEND_ID%s {IDtype=%s;ProtocolID=%s;Port=%s;ID=v6("%s");}';
$PKT_FMT_IDIPv6Subnet=
    'Pld_ISAKMP_ID_IPV6_ADDR_SUBNET IKE_SEND_ID%s {IDtype=%s;ProtocolID=%s;Port=%s;ID1=v6("%s");ID2=v6("%s");}';
$PKT_FMT_IDIPv6Range=
    'Pld_ISAKMP_ID_IPV6_ADDR_RANGE IKE_SEND_ID%s {IDtype=%s;ProtocolID=%s;Port=%s;ID1=v6("%s");ID2=v6("%s");}';
$PKT_FMT_IDFQDN=
    'Pld_ISAKMP_ID_ANY IKE_SEND_ID%s {IDtype=%s;ProtocolID=%s;Port=%s;ID=ascii("%s");}';
$PKT_FMT_HA=
    'Pld_ISAKMP_HASH IKE_SEND_HA {HashData=hexstr("%s");}';
$PKT_FMT_NC=
    'Pld_ISAKMP_NONCE IKE_SEND_NC {NonceData=hexstr("%s");}';
$PKT_FMT_NO=
    'Pld_ISAKMP_N_IPsec_ANY IKE_SEND_NO {DOI=1;ProtocolID=%s;SPIsize=%s;NotifyMessageType=%s;SPI=hexstr("%s");}';
$PKT_FMT_DL=
    'Pld_ISAKMP_D IKE_SEND_DL {DOI=1;ProtocolID=%s;SPIsize=%s;NumberOfSPI=1;SPI=hexstr("%s");}';
$PKT_FMT_VI=
    'Pld_ISAKMP_VID IKE_SEND_VI {VID=hexstr("%s");}';

# IKE
$IKEFrameHeadField= "Frame_Ether.Packet_IPv6.Upp_UDP.Udp_ISAKMP";

# IKE
%IKEFrameFieldMapAssoc;
@IKEFrameFieldMap = (
{'##'=>'Udp_ISAKMP','#Name#'=>'IK',
 'Hdr_ISAKMP'=>'@@@',
 'Pld_ISAKMP_SA_IPsec_IDonly'=>'@@@',
 'Pld_ISAKMP_KE'=>'@@@',
 'Pld_ISAKMP_ID_FQDN'=>'@@@',
 'Pld_ISAKMP_ID_USER_FQDN'=>'@@@',
 'Pld_ISAKMP_ID_IPV6_ADDR'=>'@@@',
 'Pld_ISAKMP_ID_IPV6_ADDR_SUBNET'=>'@@@',
 'Pld_ISAKMP_ID_IPV6_ADDR_RANGE'=>'@@@',
 'Pld_ISAKMP_ID_KEY_ID'=>'@@@',
 'Pld_ISAKMP_HASH'=>'@@@',
 'Pld_ISAKMP_NONCE'=>'@@@',
 'Pld_ISAKMP_N_IPsec_ANY'=>'@@@',
 'Pld_ISAKMP_D'=>'@@@',
 'Pld_ISAKMP_VID'=>'@@@',
 'ISAKMP_Encryption'=>'---',
},
{'##'=>'ISAKMP_Encryption','#Skip#'=>['Decrypted','PlainText']},
#{'##'=>'ISAKMP_Encryption','#Skip#'=>['Decrypted']},

{'##'=>'Hdr_ISAKMP','#Name#'=>'HD','#CPP#'=>\'IKEEncodeISAKMP(@_)',
 'InitiatorCookie'=>'InitiatorCookie',
# 'InitiatorCookie'=>{'#Name#'=>'InitiatorCookie','CPP'=>{'LA'=>'INITCookie','VA'=>"%s",'IV'=>'xxx'}},
 'ResponderCookie'=>'ResponderCookie',
 'NextPayload'=>'NextPayload',
 'MjVer'=>{'#Name#'=>'MjVer','IV'=>1},
 'MnVer'=>{'#Name#'=>'MnVer','IV'=>0},
 'ExchangeType'=>'ExchangeType',
 'EFlag'=>{'#Name#'=>'EFlag','IV'=>0},
 'CFlag'=>{'#Name#'=>'CFlag','IV'=>0},
 'AFlag'=>{'#Name#'=>'AFlag','IV'=>0},
 'Reserved'=>{'#Name#'=>'Reserved','IV'=>0},
 'MessageID'=>{'#Name#'=>'MessageID','IV'=>0},
 'Length'=>'Length',
},
    
{'##'=>'Pld_ISAKMP_SA_IPsec_IDonly','#Name#'=>'SA','#CPP#'=>$PKT_FMT_SA,
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'DOI'=>{'#Name#'=>'DOI','IV'=>1},
 'Situation'=>{'#Name#'=>'Situation','IV'=>'00000001'},
 'Pld_ISAKMP_P_ISAKMP'=>'@@@',
 'Pld_ISAKMP_P_IPsec_AH'=>'@@@',
 'Pld_ISAKMP_P_IPsec_ESP'=>'@@@',
},
    
{'##'=>'Pld_ISAKMP_P_ISAKMP','#Name#'=>'PR','#Multi#'=>'T','#CPP#'=>\'IKEEncodePR(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'ProposalNumber'=>'ProposalNumber',
# 'ProposalNumber'=>{'#Name#'=>'ProposalNumber','CPP'=>{'LA'=>\\'Proposal$index->[0]','VA'=>"%s"}},
 'ProtocolID'=>'ProtocolID',
 'SPIsize'=>{'#Name#'=>'SPIsize','IV'=>0},
 'NumOfTransforms'=>'NumOfTransforms',
 'SPI'=>'SPI',
 'Pld_ISAKMP_T'=>'@@@',
},
{'##'=>'Pld_ISAKMP_P_IPsec_AH','#Name#'=>'PR','#Multi#'=>'T',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'ProposalNumber'=>'ProposalNumber',
 'ProtocolID'=>'ProtocolID',
 'SPIsize'=>{'#Name#'=>'SPIsize','IV'=>0},
 'NumOfTransforms'=>'NumOfTransforms',
 'SPI'=>'SPI',
 'Pld_ISAKMP_T'=>'@@@',
},
{'##'=>'Pld_ISAKMP_P_IPsec_ESP','#Name#'=>'PR','#Multi#'=>'T',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'ProposalNumber'=>'ProposalNumber',
 'ProtocolID'=>'ProtocolID',
 'SPIsize'=>{'#Name#'=>'SPIsize','IV'=>0},
 'NumOfTransforms'=>'NumOfTransforms',
 'SPI'=>'SPI',
 'Pld_ISAKMP_T'=>'@@@',
},
    
{'##'=>'Pld_ISAKMP_T','#Name#'=>'TR','#Multi#'=>'T','#CPP#'=>\'IKEEncodeTR(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'TransformNumber'=>{'#Name#'=>'TransformNumber','VA'=>"%s"},
# 'TransformNumber'=>{'#Name#'=>'TransformNumber','CPP'=>{'LA'=>\'CPIdx("TransformNumber",$index)','VA'=>"%s"}},
 'TransformID'=>{'#Name#'=>'TransformID','VA'=>"%s"},
 'Reserved2'=>'Reserved2',
 'Attr_ISAKMP_TLV'=>'@@@',
 'Attr_ISAKMP_TV'=>'@@@',
},
    
{'##'=>'Attr_ISAKMP_TLV','#Name#'=>'ATT','#CPP#'=>\'IKEEncodeTLV(@_)',
 'AF'=>{'#Name#'=>'AF','IV'=>0},
 'Type'=>'Type',
 'Length'=>'Length',
 'Value'=>{'#Name#'=>'Value','TY'=>'hex'},
},
    
{'##'=>'Attr_ISAKMP_TV','#Name#'=>'ATT','#CPP#'=>\'IKEEncodeTV(@_)',
 'AF'=>{'#Name#'=>'AF','IV'=>1},
 'Type'=>'Type',
 'Value'=>'Value',
},
    
{'##'=>'Pld_ISAKMP_KE','#Name#'=>'KE','#CPP#'=>\'IKEEncodeKE(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'KeyExchangeData'=>'KeyExchangeData',
},
    
{'##'=>'Pld_ISAKMP_ID_IPV6_ADDR','#Name#'=>'ID','#CPP#'=>\'IKEEncodeIDIPv6(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'IDtype'=>'IDtype',
 'ProtocolID'=>'ProtocolID',
 'Port'=>'Port',
 'ID'=>'ID',
},
    
{'##'=>'Pld_ISAKMP_ID_FQDN','#Name#'=>'ID','#Multi#'=>'T','#CPP#'=>\'IKEEncodeIDFQDN(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'IDtype'=>'IDtype',
 'ProtocolID'=>'ProtocolID',
 'Port'=>'Port',
 'ID'=>'ID',
},
    
{'##'=>'Pld_ISAKMP_ID_USER_FQDN','#Name#'=>'ID','#Multi#'=>'T','#CPP#'=>\'IKEEncodeIDFQDN(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'IDtype'=>'IDtype',
 'ProtocolID'=>'ProtocolID',
 'Port'=>'Port',
 'ID'=>'ID',
},

{'##'=>'Pld_ISAKMP_ID_IPV6_ADDR_SUBNET','#Name#'=>'ID','#CPP#'=>\'IKEEncodeIDIPv6Subnet(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'IDtype'=>'IDtype',
 'ProtocolID'=>'ProtocolID',
 'Port'=>'Port',
 'ID1'=>'ID1',
 'ID2'=>'ID2',
},
    
{'##'=>'Pld_ISAKMP_ID_IPV6_ADDR_RANGE','#Name#'=>'ID','#CPP#'=>\'IKEEncodeIDIPv6Range(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'IDtype'=>'IDtype',
 'ProtocolID'=>'ProtocolID',
 'Port'=>'Port',
 'ID1'=>'ID1',
 'ID2'=>'ID2',
},
    
{'##'=>'Pld_ISAKMP_ID_KEY_ID','#Name#'=>'ID','#CPP#'=>\'IKEEncodeIDFQDN(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'IDtype'=>'IDtype',
 'ProtocolID'=>'ProtocolID',
 'Port'=>'Port',
 'ID'=>'ID',
},
    
{'##'=>'Pld_ISAKMP_HASH','#Name#'=>'HA','#CPP#'=>\'IKEEncodeHA(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'HashData'=>'HashData',
},
    
{'##'=>'Pld_ISAKMP_NONCE','#Name#'=>'NC','#Multi#'=>'T','#CPP#'=>\'IKEEncodeNC(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'NonceData'=>'NonceData',
# 'NonceData'=>{'#Name#'=>'NonceData','CPP'=>{'LA'=>\\'NonceData$index->[0]','VA'=>"%s"}},
},
    
{'##'=>'Pld_ISAKMP_N_IPsec_ANY','#Name#'=>'NO','#CPP#'=>\'IKEEncodeNO(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'DOI'=>{'#Name#'=>'DOI','IV'=>1},
 'ProtocolID'=>'ProtocolID',
 'SPIsize'=>'SPIsize',
 'NotifyMessageType'=>'NotifyMessageType',
 'SPI'=>'SPI',
 'NotificationData'=>'NotificationData',
},
    
{'##'=>'Pld_ISAKMP_D','#Name#'=>'DL','#CPP#'=>\'IKEEncodeDL(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'DOI'=>{'#Name#'=>'DOI','IV'=>1},
 'ProtocolID'=>'ProtocolID',
 'SPIsize'=>'SPIsize',
 'NumberOfSPI'=>'NumberOfSPI',
 'SPI'=>'SPI',
},
    
{'##'=>'Pld_ISAKMP_VID','#Name#'=>'VI','#CPP#'=>\'IKEEncodeVI(@_)',
 'NextPayload'=>'NextPayload',
 'Reserved1'=>'Reserved1',
 'PayloadLength'=>'PayloadLength',
 'VID'=>'VID',
},
);

%IKEIDtoSTRUCT = (
    $IKEDoi{'TI_ID_IPV4_ADDR'}       =>'',
    $IKEDoi{'TI_ID_FQDN'}            =>'Pld_ISAKMP_ID_FQDN',
    $IKEDoi{'TI_ID_USER_FQDN'}       =>'Pld_ISAKMP_ID_USER_FQDN',
    $IKEDoi{'TI_ID_IPV4_ADDR_SUBNET'}=>'',
    $IKEDoi{'TI_ID_IPV6_ADDR'}       =>'Pld_ISAKMP_ID_IPV6_ADDR',
    $IKEDoi{'TI_ID_IPV6_ADDR_SUBNET'}=>'Pld_ISAKMP_ID_IPV6_ADDR_SUBNET',
    $IKEDoi{'TI_ID_IPV4_ADDR_RANGE'} =>'',
    $IKEDoi{'TI_ID_IPV6_ADDR_RANGE'} =>'Pld_ISAKMP_ID_IPV6_ADDR_RANGE',
    $IKEDoi{'TI_ID_DER_ASN1_DN'}     =>'',
    $IKEDoi{'TI_ID_DER_ASN1_GN'}     =>'',
    $IKEDoi{'TI_ID_KEY_ID'}          =>'Pld_ISAKMP_ID_KEY_ID',
);
# ID
sub IKEGetPayloadFromIDType($) {
    my($idtype)=@_;
    return $IKEIDtoSTRUCT{$idtype};
}
#============================================
# 
#============================================
$MD5_DIGEST_LENGTH=16;
$SHA_DIGEST_LENGTH=20;
%IKEAlgo = (
	    'Hash'=>
	    [{'Name'=>'MD5',     'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>$MD5_DIGEST_LENGTH << 3},
	     {'Name'=>'SHA1',    'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_SHA},'Compute'=>'',Length=>$SHA_DIGEST_LENGTH << 3}],
	    'HHMacIKE'=>
	    [{'HMacMD5'=>'',     'Doi'=>$IKEDoi{TI_ATTR_AUTH_HMAC_MD5},'Compute'=>'',Length=>''},
	     {'HMacSHA1'=>'',    'Doi'=>$IKEDoi{TI_ATTR_AUTH_HMAC_SHA},'Compute'=>'',Length=>''}],
	    'EncIKE'=>
	    [{'Name'=>'DES',     'Doi'=>$IKEDoi{TI_ATTR_ENC_ALG_DES},'Compute'=>'',     Length=>64, 'CBCBlock'=>8},
	     {'Name'=>'BLOWFISH','Doi'=>$IKEDoi{TI_ATTR_ENC_ALG_BLOWFISH},'Compute'=>'',Length=>448,'CBCBlock'=>8},
	     {'Name'=>'3DES',    'Doi'=>$IKEDoi{TI_ATTR_ENC_ALG_3DES},'Compute'=>'',Length=>192,    'CBCBlock'=>8},
	     {'Name'=>'CAST',    'Doi'=>$IKEDoi{TI_ATTR_ENC_ALG_CAST},'Compute'=>'',Length=>128,    'CBCBlock'=>8}],
	    'EncIPSEC'=>
	    [{'Name'=>'DES',     'Doi'=>$IKEDoi{'TI_ESP_ALG_DES'},'Compute'=>'',     Length=>64, 'CBCBlock'=>8},
	     {'Name'=>'3DES',    'Doi'=>$IKEDoi{'TI_ESP_ALG_3DES'},'Compute'=>'', Length=>192,    'CBCBlock'=>8}],
#		  {'Name'=>'AES',     'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''}]},
# 	    {'CA'=>'HMacIPSEC','Alg'=>
# 		 [{'MD5'=>'',         'Doi'=>$IKEDoi{TI_ATTR_AUTH_HMAC_MD5},'Compute'=>'',Length=>''},
# 		  {'SHA1'=>'',        'Doi'=>$IKEDoi{TI_ATTR_AUTH_HMAC_SHA},'Compute'=>'',Length=>''},
# 		  {'KPDK'=>'',        'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'null'=>'',        'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'HMacSha2_256'=>'','Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'HMacSha2_384'=>'','Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'HMacSha2_512'=>'','Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''}]},
# 	    {'CA'=>'EncIPSEC','Alg'=>
# 		 [{'Name'=>'DES-IV64','Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'Name'=>'DES',     'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'Name'=>'3DES',    'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'Name'=>'CAST',    'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'Name'=>'BLOWFISH','Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'Name'=>'DES-IV32','Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'Name'=>'null',    'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'Name'=>'RIJNDAEL','Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'Name'=>'TWOFISH', 'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''},
# 		  {'Name'=>'RC4',     'Doi'=>$IKEDoi{TI_ATTR_HASH_ALG_MD5},'Compute'=>'',Length=>''}]},
);
# 
@IKEDHGrpDesc = (
    {'desc'=>$IKEDoi{'TI_ATTR_GRP_DESC_MODP768'}, 'type'=>'1','gen1'=>2,
     'prime'=> 
	 'FFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD1' .
	 '29024E088A67CC74020BBEA63B139B22514A08798E3404DD' .
	 'EF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245' .
	 'E485B576625E7EC6F44C42E9A63A3620FFFFFFFFFFFFFFFF'},

    {'desc'=>$IKEDoi{'TI_ATTR_GRP_DESC_MODP1024'},'type'=>'1','gen1'=>2,
     'prime'=>
	 'FFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD1' .
	 '29024E088A67CC74020BBEA63B139B22514A08798E3404DD' .
	 'EF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245' .
	 'E485B576625E7EC6F44C42E9A637ED6B0BFF5CB6F406B7ED' .
	 'EE386BFB5A899FA5AE9F24117C4B1FE649286651ECE65381' .
	 'FFFFFFFFFFFFFFFF'},

    {'desc'=>$IKEDoi{'TI_ATTR_GRP_DESC_MODP1536'},'type'=>'1','gen1'=>2,
     'prime'=>
	 'FFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD1' .
	 '29024E088A67CC74020BBEA63B139B22514A08798E3404DD' .
	 'EF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245' .
	 'E485B576625E7EC6F44C42E9A637ED6B0BFF5CB6F406B7ED' .
	 'EE386BFB5A899FA5AE9F24117C4B1FE649286651ECE45B3D' .
	 'C2007CB8A163BF0598DA48361C55D39A69163FA8FD24CF5F' .
	 '83655D23DCA3AD961C62F356208552BB9ED529077096966D' .
	 '670C354E4ABC9804F1746C08CA237327FFFFFFFFFFFFFFFF'},
);

#============================================
# 
#============================================
sub IKERegsitSAProf {
    my($saProfile,$check)=@_;
    my($prof);

    # 
    if( $check ){
	$prof=$saProfile;
    }
    elsif( !($prof=IKESetupSAProf($saProfile)) ){
	MsgPrint('ERR',"SA profile[%s] parameter error\n",$prof->{ID});
	return 'SA profile parameter error';
    }
    if($IKESAProfile{$prof->{ID}}){
	MsgPrint('ERR',"SA profile[%s] already registed\n",$prof->{ID});
	return 'SA profile already registed';
    }
    # 
    if($prof->{'PHASE'} eq 1){
	$prof->{'PROPOSAL-NO'}=1;
	$prof->{'TRANSFORM-NO'}=1;
    }

    $IKESAProfile{$prof->{ID}}=$prof;
    return;
}
sub IKEGetSAProf ($){
    my($said)=@_;
    return $IKESAProfile{$said};
}
sub IKEGetSubSAProf ($){
    my($said)=@_;
    my(@match,$key,$val);
    while(($key,$val)=each(%IKESAProfile)){
	if($val->{'ISAKMP_SA_ID'} eq $said && $val->{'PHASE'} eq 2){
	    push(@match,$key);
	}
    }
    return \@match;
}
sub IKESALabelToVal {
    my($phase,$data)=@_;
    my($temp,$key,$val);
    $temp=$phase eq 1 ? \%IKEDefaultPH1SA: \%IKEDefaultPH2SA;
    while(($key,$val)=each(%$data)){
	if( $temp->{$key}->{'VM'} eq 'label' ){
	    $data->{$key} = $IKEDoi{$val};
	}
    }
}
sub IKESALabelToDefaultVal {
    my($phase,$key)=@_;
    my($temp);
    $temp=$phase eq 1 ? \%IKEDefaultPH1SA: \%IKEDefaultPH2SA;
    if($temp->{$key}->{'VM'} eq 'label'){
	return $IKEDoi{$temp->{$key}->{'VL'}};
    }
    return $temp->{$key}->{'VL'};
}
sub IKEDoiToLabel {
    my($doi,$labelList)=@_;
    my($i);
    for $i (0..$#$labelList){
	if($doi eq $IKEDoi{$labelList->[$i]}){return $labelList->[$i];}
    }
    return;
}
# SA
sub IKESetupSAProf {
    my($usrProf)=@_;
    my(%prof,$temp,$key,$val,$i);

    # 
    if($usrProf->{PHASE} eq 1){
	$temp=\%IKEDefaultPH1SA;
    }
    elsif($usrProf->{PHASE} eq 2){
	$temp=\%IKEDefaultPH2SA;
    }
    else{
	LogPrint('ERR','','',"SA Profile PHASE parameter invalid\n");
	return;
    }
    # 
    while(($key,$val)=each(%$temp)){
	# 
	if($val->{'FM'} eq 'empty' && !defined($usrProf->{$key})){
	    next;
	}
	# 
	if($val->{'TY'} eq 'require'){
	    if($usrProf->{$key} eq ''){
		LogPrint('ERR','','',"SA Profile [$key] parameter empty\n");
		return;
	    }
	    if($val->{'VM'} eq 'label' && $val->{'VR'}){
		if(!grep{$_ eq $usrProf->{$key}} @{$val->{'VR'}}){
		    LogPrint('ERR','','',"SA Profile [$key]=>[$usrProf->{$key}] parameter invalid label\n");
		    return;
		}
	    }
	    $prof{$key}=($val->{'VM'} eq 'real')?$usrProf->{$key}:$IKEDoi{$usrProf->{$key}};
	}
	# 
	if($val->{'TY'} eq 'fix'){
	    $prof{$key}=($val->{'VM'} eq 'real')?$val->{'VL'}:$IKEDoi{$val->{'VL'}};
	    if($usrProf->{$key} ne '' && $prof{$key} ne $IKEDoi{$usrProf->{$key}}){ 
		MsgPrint('WAR',"SA Profile [$key]=>[$usrProf->{$key}] parameter can't change valus\n");
	    }
	}
	if($val->{'TY'} eq 'op'){
	    if($usrProf->{$key} eq ''){
		$prof{$key}=($val->{'VM'} eq 'real')?$val->{'VL'}:$IKEDoi{$val->{'VL'}};
	    }
	    else{
		if($val->{'VM'} eq 'label' && $val->{'VR'}){
		    if(!grep{$_ eq $usrProf->{$key}} @{$val->{'VR'}}){
			LogPrint('ERR','','',"SA Profile [$key]=>[$usrProf->{$key}] parameter invalid label\n");
			return;
		    }
		}
		$prof{$key}=($val->{'VM'} eq 'real')?$usrProf->{$key}:$IKEDoi{$usrProf->{$key}};
	    }
	}
    }
    return \%prof;
}

# 
sub IKEIsInvalidSAID {
    my($said,$dir,$validSaid)=@_;
    if(!$said || !$validSaid){return;}
    if( grep{$_->{'ID'} eq $said && $_->{'DIR'} eq $dir} @$validSaid ){
	return 'OK';
    }
    return;
}
# 
sub IKEPh2IDtoType {
    my($id)=@_;
    my($type);
    if($id =~ /.+\/.+/ ){$type='TI_ID_IPV6_ADDR_SUBNET'}
    elsif($id =~ /.+\|.+/ ){$type='TI_ID_IPV6_ADDR_RANGE'}
    else{$type='TI_ID_IPV6_ADDR'}
    return $type;
}

#============================================
# 
#============================================
sub IKEIsValidAddress {
    my($inst,$pkt,$intf)=@_;
    if($pkt->{'recvFrame'}){
	if (IKGetMacAddress($inst->{'TnEtherAddr'},$intf)  eq $pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'} && 
	    $inst->{'TnIPAddr'}     eq $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'} && 
	    IKGetMacAddress($inst->{'NutEtherAddr'},$intf) eq $pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'} && 
	    $inst->{'NutIPAddr'}    eq $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'}){
	    return '';
	}
	LogPrint('WAR',$inst,'',"Receive address [%s|%s][%s|%s]  [%s|%s][%s|%s]\n",
		 $pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'},IKGetMacAddress($inst->{'NutEtherAddr'},$intf),
		 $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'},$inst->{'NutIPAddr'},
		 $pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'},IKGetMacAddress($inst->{'TnEtherAddr'},$intf),
		 $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'},$inst->{'TnIPAddr'});
    }
    else{
	if (IKGetMacAddress($inst->{'TnEtherAddr'},$intf)  eq $pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'} && 
	    $inst->{'TnIPAddr'}     eq $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'} && 
	    IKGetMacAddress($inst->{'NutEtherAddr'},$intf) eq $pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'} && 
	    $inst->{'NutIPAddr'}    eq $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'}){
	    return '';
	}
	LogPrint('WAR',$inst,'',"Sender address [%s|%s][%s|%s]  [%s|%s][%s|%s]\n",
		 $pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'}, IKGetMacAddress($inst->{'TnEtherAddr'},$intf),
		 $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'},$inst->{'TnIPAddr'},
		 $pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'},IKGetMacAddress($inst->{'NutEtherAddr'},$intf),
		 $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'},$inst->{'NutIPAddr'});
    }
    return 'Unmatch Address';
}

#============================================
# 
#============================================
# 
sub IKEMatchSAforAddr {
    my($said,$pkt,$intf)=@_;
    my($i,$prof,@match);
    if(!$said){$said=[keys(%IKESAProfile)];}
    elsif(!ref($said)){$said=[$said];}
    for $i (0..$#$said){
	$prof = IKEGetSAProf($said->[$i]);
	# IP
	MsgPrint('DBG',"SAID[%s] Addr[%s][%s]\n",
		 $said->[$i],$pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'},$prof->{'TN_IP_ADDR'});
	if( $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.DestinationAddress'} ne 
	    $prof->{'TN_IP_ADDR'} ){ next; }
	MsgPrint('DBG',"SAID[%s] Addr[%s][%s]\n",
		 $said->[$i],$pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'},$prof->{'NUT_IP_ADDR'});
	if( $pkt->{'Frame_Ether.Packet_IPv6.Hdr_IPv6.SourceAddress'} ne 
	    $prof->{'NUT_IP_ADDR'} ){ next; }
	# MAC
	MsgPrint('DBG',"SAID[%s] Mac[%s][%s]\n",
		 $said->[$i],$pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'},IKGetMacAddress($prof->{'TN_ETHER_ADDR'},$intf));
	if( $pkt->{'Frame_Ether.Hdr_Ether.DestinationAddress'} ne 
	    IKGetMacAddress($prof->{'TN_ETHER_ADDR'},$intf) ){ next; }
	MsgPrint('DBG',"SAID[%s] Mac[%s][%s]\n",
		 $said->[$i],$pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'},IKGetMacAddress($prof->{'NUT_ETHER_ADDR'},$intf));
	if( $pkt->{'Frame_Ether.Hdr_Ether.SourceAddress'} ne 
	    IKGetMacAddress($prof->{'NUT_ETHER_ADDR'},$intf) ){ next; }
	push(@match,$said->[$i]);
    }
    return $#match eq -1 ? '' :\@match;
}


sub IKEIsMatchID {
    my($type,$id1,$id2,$protocol,$port,$prof_id,$prof_protocol,$prof_port)=@_;
    my(@ids,$mask);

    if($type eq $IKEDoi{'TI_ID_IPV6_ADDR'}){
	return($id1 eq $prof_id && $protocol eq $prof_protocol && $port eq $prof_port);
    }
    if($type eq $IKEDoi{'TI_ID_IPV6_ADDR_RANGE'}){
	$prof_id =~ /(.+)\|(.+)/;
	$ids[0]=$1;$ids[1]=$2;
	return(IPv6EQ($id1,$ids[0]) && IPv6EQ($id2,$ids[1]) && $protocol eq $prof_protocol && $port eq $prof_port);
    }
    elsif($type eq $IKEDoi{'TI_ID_IPV6_ADDR_SUBNET'}){
	@ids=IPv6WithMaskStrToVal($prof_id);

	return(IPv6EQ($id1,$ids[0]) && IPv6EQ($id2,$ids[1]) && $protocol eq $prof_protocol && $port eq $prof_port);
    }
    return;
}
sub IKEIsMatchIDAd {
    my($profID,$idno,$pktinfo,$inst,$context)=@_;
    my($idtype,$id1,$id2,$proto,$port,@ids,$mask,$ret);
    
    ($idtype,$id1,$id2,$proto,$port)=IKEGetIDPalyloadField($idno,$pktinfo);
    if($idtype eq $IKEDoi{'TI_ID_IPV6_ADDR'}){
	$ret = $profID eq $id1;
    }
    elsif($idtype eq $IKEDoi{'TI_ID_IPV6_ADDR_SUBNET'}){
	@ids=IPv6WithMaskStrToVal($profID);
	$ret = (IPv6EQ($id1,$ids[0]) && IPv6EQ($id2,$ids[1]));
	$id1=$id1 . '/' . $id2;
    }
    elsif($idtype eq $IKEDoi{'TI_ID_IPV6_ADDR_RANGE'}){
	$profID =~ /(.+)\|(.+)/;
	$ids[0]=$1;$ids[1]=$2;
	$ret = (IPv6EQ($id1,$ids[0]) && IPv6EQ($id2,$ids[1]));
	$id1=$id1 . '|' . $id2;
    }
    elsif($idtype eq $IKEDoi{'TI_ID_FQDN'}){
	$ret = $profID eq $id1;
    }
    elsif($idtype eq $IKEDoi{'TI_ID_USER_FQDN'}){
	$ret = $profID eq $id1;
    }
    IKSetEvalResult($context,'2op','eq',$ret,$profID,$id1);
    return $ret;
}

# 
sub IKEMatchSAforID1 {
    my($said,$side,$type,$id)=@_;
    my($i,$prof,@match);
    if(!$said){$said=[keys(%IKESAProfile)];}
    elsif(!ref($said)){$said=[$said];}
    for $i (0..$#$said){
	$prof = IKEGetSAProf($said->[$i]);
	if($side eq 'remote'){
	    MsgPrint('DBG6',"  id(remote) matching SAID[%s] type[%s/%s] id[%s/%s]\n",
		     $said->[$i], $prof->{'NUT_ID_TYPE'},$type,$prof->{'NUT_ID'},$id);
	    if($prof->{'NUT_ID_TYPE'} eq $type && $prof->{'NUT_ID'} eq $id ){
		push(@match,$said->[$i]);
	    }
	}
	else{
	    MsgPrint('DBG6',"  id(local) matching SAID[%s] type[%s/%s] id[%s/%s]\n",
		     $said->[$i],$prof->{'TN_ID_TYPE'},$type,$prof->{'TN_ID'},$id);
	    if($prof->{'TN_ID_TYPE'} eq $type && $prof->{'TN_ID'} eq $id ){
		push(@match,$said->[$i]);
	    }
	}
    }    
    return $#match eq -1 ? '' :\@match;
}
# 
#   ID
#     TI_ID_IPV6_ADDR
sub IKEMatchSAforID2 {
    my($said,$side,$type,$id1,$id2,$protocol,$port)=@_;
    my($i,$prof,@match);
    if(!$said){$said=[keys(%IKESAProfile)];}
    elsif(!ref($said)){$said=[$said];}
    for $i (0..$#$said){
	$prof = IKEGetSAProf($said->[$i]);
	if($side eq 'remote'){ # 
	    MsgPrint('DBG6',
		     "  id matching SAID[%s] type(%s)\n                  id[%s/%s] proto[%s/%s] port[%s/%s]\n",
		     $prof->{'ID'},$type,$prof->{'NUT_ID_ADDR'},$id1,
		     $prof->{'ID_PROTO'},$protocol,$prof->{'NUT_ID_PORT'},$port);
	    if(IKEIsMatchID($type,$id1,$id2,$protocol,$port,$prof->{'NUT_ID_ADDR'},$prof->{'ID_PROTO'},$prof->{'NUT_ID_PORT'})){
		push(@match,$said->[$i]);
#		MsgPrint('DBG6',"Matched ID SAID[%s] ID(%s)\n",$said->[$i],$id1);
	    }
	}
	else{
	    MsgPrint('DBG6',
		     "  id matching SAID[%s] type(%s)\n                  id[%s/%s] proto[%s/%s] port[%s/%s]\n",
		     $prof->{'ID'},$type,$prof->{'TN_ID_ADDR'},$id1,
		     $prof->{'ID_PROTO'},$protocol,$prof->{'TN_ID_PORT'},$port);
	    if(IKEIsMatchID($type,$id1,$id2,$protocol,$port,$prof->{'TN_ID_ADDR'},$prof->{'ID_PROTO'},$prof->{'TN_ID_PORT'})){
		push(@match,$said->[$i]);
#		MsgPrint('DBG6',"Matched ID SAID[%s] ID(%s)\n",$said->[$i],$id1);
	    }
	}
    }    
    return $#match eq -1 ? '' :\@match;
}
# 
sub IKEGetSAAttKeyName {
    my($phase,$attType)=@_;
    my($temp,@keys,$i);
    $temp=($phase eq 1)?\%IKEDefaultPH1SA:\%IKEDefaultPH2SA;
    @keys=keys(%$temp);
    for $i (0..$#keys){
	if( defined($temp->{$keys[$i]}->{'AT'}) && $temp->{$keys[$i]}->{'AT'} eq $attType ){
	    return $keys[$i];
	}
    }
    return;
}

# 
#   useDefVal:
sub IKEMatchSAforAttr {
    my($said,$phase,$attType,$val,$useDefVal)=@_;
    my($i,$prof,@match,$name);

#    MsgPrint('DBG6',"   *ATT matching SAID[%s] phase(%d) type(%s) val(%s) def(%s)\n",$said,$phase,$attType,$val,$useDefVal);

    if(!$said){$said=[keys(%IKESAProfile)];}
    elsif(!ref($said)){$said=[$said];}

    for $i (0..$#$said){
	if( !($prof = IKEGetSAProf($said->[$i])) ){next;}
	if($prof->{'PHASE'} ne $phase){next;}
	# 
	$name=IKEGetSAAttKeyName($phase,$attType);
	# 
	if(defined($prof->{$name}) && ($val eq '' || $prof->{$name} ne $val)){next;}
	# 
	if(!defined($prof->{$name}) && $useDefVal && $val ne ''){
	    if(IKESALabelToDefaultVal($prof->{'PHASE'},$name) ne $val){next;}
	}
	# 
	push(@match,$said->[$i]);
    }
    return $#match eq -1 ? '' :\@match;
}

# 
sub IKEIsExistPayload {
    my($frame,$payload)=@_;
    my(@keys,$i,$idx,$count);
    @keys=keys(%$payload);
    for($i=0;$i<=$#keys;$i++){
	$idx=$i;
	# 
	$count=GFv('IK,' . $keys[$i] . '#N',$frame);
#	printf("%s %s => count=[$count]\n",$i,'IK,' . $keys[$i] . '#N');
	if( !$payload->{$keys[$i]} ){
	    if($count){goto NOTEXIST;}
	}
	else{
	    # 
	    if(ref($payload->{$keys[$i]})){
		if($payload->{$keys[$i]}->{'Op'} eq 'over'){
		    if( $count < $payload->{$keys[$i]}->{'Val'} ){goto NOTEXIST;}
		}
		if($payload->{$keys[$i]}->{'Op'} eq 'under'){
		    if( $count > $payload->{$keys[$i]}->{'Val'} ){goto NOTEXIST;}
		}
	    }
	    # 
	    else{
		if( $count ne $payload->{$keys[$i]} ){goto NOTEXIST;}
	    }
	}
    }
    return ;
  NOTEXIST:
    MsgPrint('DBG',"Payload not exit <IK,%s,%s>(%s)\n",$keys[$idx],$idx,$count);
    return 'Not exist payload';
}
sub IKEMatchSAPH1 {
    # 
    # 1.
    #     
    # 2.ID
    #     
    # 3.
    #     
    #   (
    #   (
    #   (
    #   (
    #   (
    #   (
    #   
    my($frame,$pkt,$intf,$dir,$reqprof)=@_;
    my($said,$field,$prof,$j,$k,$trans,$idtype,$id1,$id2,$proto,$port,@reqsaids,@selectsaid,$dbg);
    
    if( $dbg=IsLogLevel('DBG6') ){
	MsgPrint('DBG6',"----- Start Phase1 Profile matching -----\n");
    }

    if( !($said=IKEMatchSAforAddr('',$pkt,$intf)) ){
	LogPrint('WAR','','',"SA matching, Address mismatch\n");
	return;
    }
    # ID
    ($idtype,$id1,$id2,$proto,$port)=IKEGetIDPalyloadField(0,$frame);
    if( !($said=IKEMatchSAforID1($said,'remote',$idtype,$id1)) ){
	LogPrint('WAR','',$said,"SA matching, ID mismatch\n");
	return;
    }
    if($dbg){
	MsgPrint('DBG6',"Matched ID SAID list[@$said]\n");
	@reqsaids=map{$_->{'DIR'} eq $dir ? $_->{'ID'}:''} @$reqprof;
	MsgPrint('DBG6',"Acceptable SAID list[@reqsaids]\n");
    }

    # 
    for $j (0 .. $#$said){
	if( !IKEIsInvalidSAID($said->[$j],$dir,$reqprof) ){
	    MsgPrint('DBG6'," *SAID[%s] is not accesptable said(mismatch).\n",$said->[$j]);
	    next;
	}
	push(@selectsaid,$said->[$j]);
    }
    if($#selectsaid<0){return;}
    $said=\@selectsaid;

    # 
    for $j (0 .. $#$said){
	$prof = IKEGetSAProf($said->[$j]);

	# 
	$trans=GFv('IK,SA,PR,TR,TransformNumber',$frame);
	if(!$trans){
	    if($dbg){MsgPrint('DBG6'," *SAID[%s] transformNumber field empty(mismatch)\n",$said->[$j]);}
	    return;
	}

	if(!ref($trans)){$trans = [$trans];}
	for $k (0..$#$trans){
	    $field='IK,SA,PR,TR#' . $k .',ATT,Type`$v eq ' . $IKEDoi{'TI_ISAKMP_ENC_ALG'} . '`,Value';
	    if( !IKEMatchSAforAttr($said->[$j],1,$IKEDoi{'TI_ISAKMP_ENC_ALG'},GFv($field,$frame)) ){
		if($dbg){
		    MsgPrint('DBG6'," *ENC-ALG mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
			     $said->[$j],$prof->{'ATTR_ENC_ALG'},GFv($field,$frame),$k);
		}
		next;
	    }
	    $field='IK,SA,PR,TR#' . $k . ',ATT,Type`$v eq ' . $IKEDoi{'TI_ISAKMP_HASH_ALG'} . '`,Value';
	    if( !($said=IKEMatchSAforAttr($said->[$j],1,$IKEDoi{'TI_ISAKMP_HASH_ALG'},GFv($field,$frame))) ){
		if($dbg){
		    MsgPrint('DBG6'," *HASH-ALG mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
			     $said->[$j],$prof->{'ATTR_HASH_ALG'},GFv($field,$frame),$k);
		}
		next;
	    }
	    $field='IK,SA,PR,TR#' . $k . ',ATT,Type`$v eq ' . $IKEDoi{'TI_ISAKMP_AUTH_METHOD'} . '`,Value';
	    if( !($said=IKEMatchSAforAttr($said->[$j],1,$IKEDoi{'TI_ISAKMP_AUTH_METHOD'},GFv($field,$frame))) ){
		if($dbg){
		    MsgPrint('DBG6'," *AUTH-ALG mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
			     $said->[$j],$prof->{'ATTR_AUTH_METHOD'},GFv($field,$frame),$k);
		}
		next;
	    }
	    $field='IK,SA,PR,TR#' . $k . ',ATT,Type`$v eq ' . $IKEDoi{'TI_ISAKMP_GRP_DESC'} . '`,Value';
	    if( !($said=IKEMatchSAforAttr($said->[$j],1,$IKEDoi{'TI_ISAKMP_GRP_DESC'},GFv($field,$frame))) ){
		if($dbg){
		    MsgPrint('DBG6'," *GROUP-DESC mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
			     $said->[$j],$prof->{'ATTR_PH1_GRP_DESC'},GFv($field,$frame),$k);
		}
		next;
	    }
	    $field='IK,SA,PR,TR#' . $k . ',ATT,Type`$v eq ' . $IKEDoi{'TI_ISAKMP_SA_LD_TYPE'} . '`,Value';
	    if( !($said=IKEMatchSAforAttr($said->[$j],1,$IKEDoi{'TI_ISAKMP_SA_LD_TYPE'},GFv($field,$frame),'useDef')) ){
		if($dbg){
		    MsgPrint('DBG6'," *LIFE-TYPE mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
			     $said->[$j],$prof->{'ATTR_PH1_SA_LD_TYPE'},GFv($field,$frame),$k);
		}
		next;
	    }
	    $field='IK,SA,PR,TR#' . $k . ',ATT,Type`$v eq ' . $IKEDoi{'TI_ISAKMP_SA_LD'} . '`,Value';
	    if( !($said=IKEMatchSAforAttr($said->[$j],1,$IKEDoi{'TI_ISAKMP_SA_LD'},GFv($field,$frame))) ){
		if($dbg){
		    MsgPrint('DBG6'," *LIFE-DURATION mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
			     $said->[$j],$prof->{'ATTR_PH1_SA_LD'},GFv($field,$frame),$k);
		}
		next;
	    }
	    # 
	    if($dbg){MsgPrint('DBG6',"Matched Complete SAID[%s] TransformNo[#%s]\n",$said->[$j],$k);}
	    return $said->[$j],0,$k;
	}
    }
    return $said;
}
sub IKEMatchSAPH2 {
    # 
    # 1.
    #     
    # 2.Ph2 1st Msg
    #     
    # 3.
    #     
    #    (
    #    (
    #    (
    # 4.
    #     
    #     
    #    (
    #         
    #    (
    #    (
    #         
    #         
    #         
    #         
    #         
    #         
    #         
    #         
    #         
    #    (
    #         
    #  
    # 
    #  
    my($frame,$pkt,$ph1prof,$dir,$reqprof)=@_;
    my($said,$field,$i,$j,$k,$procount,$propno,$trans,$val,$prof,$idtype,$id1,$id2,$proto,$port,@reqsaids,@selectsaid,$dbg);

    if( $dbg=IsLogLevel('DBG6') ){
	MsgPrint('DBG6',"----- Start Phase2 Profile matching -----\n");
    }

    # ID
    ($idtype,$id1,$id2,$proto,$port)=IKEGetIDPalyloadField(0,$frame);

    if( !($said=IKEMatchSAforID2($said,'remote',$idtype,$id1,$id2,$proto,$port)) ){
	LogPrint('ERR','',$said,"SA matching, Initiator ID mismatch\n");
	return;
    }
    ($idtype,$id1,$id2,$proto,$port)=IKEGetIDPalyloadField(1,$frame);
    if( !($said=IKEMatchSAforID2($said,'local',$idtype,$id1,$id2,$proto,$port)) ){
	LogPrint('ERR','',$said,"SA matching, Responder ID mismatch\n");
	return;
    }
    if($dbg){
	MsgPrint('DBG6',"Matched ID SAID list[@$said]\n");
	@reqsaids=map{$_->{'DIR'} eq $dir ? $_->{'ID'}:''} @$reqprof;
	MsgPrint('DBG6',"Acceptable SAID list[@reqsaids]\n");
    }

    # 
    for $j (0 .. $#$said){
	if( !IKEIsInvalidSAID($said->[$j],$dir,$reqprof) ){
	    MsgPrint('DBG6'," *SAID[%s] is not accesptable said(mismatch).\n",$said->[$j]);
	    next;
	}
	$prof = IKEGetSAProf($said->[$j]);
	# 
	if( $ph1prof ne $prof->{'ISAKMP_SA_ID'} ){
	    MsgPrint('DBG6'," *PH1-PH2 relation mismatch, SAID[%s]ISAKMP_SA_ID(%s) not equal [%s]\n",
		     $said->[$j],$prof->{'ISAKMP_SA_ID'},$ph1prof);
	    next;
	}
	push(@selectsaid,$said->[$j]);
    }
    if($#selectsaid<0){return;}
    $said=\@selectsaid;

    # 
    $procount=GFv("IK,SA,PR#N",$frame);
    for($i=0;$i<$procount;$i++){
	$propno=GFv('IK,SA,PR#' . $i . ',ProposalNumber',$frame);
	$val=($i+1<$procount)?GFv('IK,SA,PR#' . $i+1 . ',ProposalNumber',$frame):'';
	if($propno ne $val){
	    # 
	    for $j (0 .. $#$said){
		$prof = IKEGetSAProf($said->[$j]);
		$val=GFv('IK,SA,PR#' . $i . ',ProtocolID',$frame);
		if($prof->{'PROTO'} ne $val){next;}
		$val=GFv('IK,SA,PR#' . $i . ',SPIsize',$frame);
		if($val ne 4){
		    if($dbg){MsgPrint('DBG6'," *SAID[%s] SPI size(%s) mismatch\n",$said->[$j],$val);}
		    next;
		}
		# 
		$trans=GFv('IK,SA,PR#' . $i . ',TR,TransformNumber',$frame);
		if(!$trans){
		    if($dbg){MsgPrint('DBG6'," *SAID[%s] transformNumber field empty(mismatch)\n",$said->[$j]);}
		    next;
		}
		if(!ref($trans)){$trans = [$trans];}
		# 
		for $k (0..$#$trans){
		    $val=GFv('IK,SA,PR#' . $i . ',TR#' . $k .',TransformID',$frame);
		    if($val ne $prof->{'ESP_ALG'}){  # Transform-ID(
			if($dbg){MsgPrint('DBG6'," *Transform-ID mismatch SAID[%s](%d) != Pkt(%s) tr:#%s\n",
					  $said->[$j],$prof->{'ESP_ALG'},$val,$k);}
			next;
		    }
		    $field='IK,SA,PR#' . $i . ',TR#' . $k .',ATT,Type`$v eq ' . $IKEDoi{'TI_IPSEC_AUTH'} . '`,Value';
		    if( !IKEMatchSAforAttr($said->[$j],2,$IKEDoi{'TI_IPSEC_AUTH'},GFv($field,$frame)) ){
			if($dbg){
			    MsgPrint('DBG6'," *AuthenIPSEC-AUTH mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
				     $said->[$j],$prof->{'ATTR_AUTH'},GFv($field,$frame),$k);
			}
			next;
		    }
		    $field='IK,SA,PR#' . $i . ',TR#' . $k .',ATT,Type`$v eq ' . $IKEDoi{'TI_IPSEC_ENC_MODE'} . '`,Value';
		    if( !IKEMatchSAforAttr($said->[$j],2,$IKEDoi{'TI_IPSEC_ENC_MODE'},GFv($field,$frame)) ){
			if($dbg){
			    MsgPrint('DBG6'," *Encapsulation-Mode mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
				     $said->[$j],$prof->{'ATTR_ENC_MODE'},GFv($field,$frame),$k);
			}
			next;
		    }
		    $field='IK,SA,PR#' . $i . ',TR#' . $k .',ATT,Type`$v eq ' . $IKEDoi{'TI_IPSEC_GRP_DESC'} . '`,Value';
		    if( !IKEMatchSAforAttr($said->[$j],2,$IKEDoi{'TI_IPSEC_GRP_DESC'},GFv($field,$frame)) ){
			if($dbg){
			    MsgPrint('DBG6'," *Group-Description mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
				     $said->[$j],$prof->{'ATTR_PH2_GRP_DESC'},GFv($field,$frame),$k);
			}
			next;
		    }
		    $field='IK,SA,PR#' . $i . ',TR#' . $k .',ATT,Type`$v eq ' . $IKEDoi{'TI_IPSEC_SA_LD_TYPE'} . '`,Value';
		    if( !IKEMatchSAforAttr($said->[$j],2,$IKEDoi{'TI_IPSEC_SA_LD_TYPE'},GFv($field,$frame),'useDef') ){
			if($dbg){
			    MsgPrint('DBG6'," *Life-Type mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
				     $said->[$j],$prof->{'ATTR_PH2_SA_LD_TYPE'},GFv($field,$frame),$k);
			}
			next;
		    }
		    $field='IK,SA,PR#' . $i . ',TR#' . $k .',ATT,Type`$v eq ' . $IKEDoi{'TI_IPSEC_SA_LD'} . '`,Value';
		    if( !IKEMatchSAforAttr($said->[$j],2,$IKEDoi{'TI_IPSEC_SA_LD'},GFv($field,$frame)) ){
			if($dbg){
			    MsgPrint('DBG6'," *Life-Duration mismatch SAID[%s](%s) != Pkt(%s) tr:#%d\n",
				     $said->[$j],$prof->{'ATTR_PH2_SA_LD'},GFv($field,$frame),$k);
			}
			next;
		    }
		    # 
		    if($dbg){MsgPrint('DBG6',"Matched Complete SAID[%s] ProposalNo[%s] TransformNo[#%s]\n",$said->[$j],$i,$k);}
		    return $said->[$j],$i,$k;
		}
	    }
	}
	# SA bandle
	else{
	    if($dbg){MsgPrint('DBG6'," *ignore SA bandle,SA protocolNo[%s]\n", $propno);}
	    for($i+=2;$i<$procount;$i++){
		$val=GFv('IK,SA,PR#' . $i . ',ProposalNumber',$frame);
		if($propno ne $val){last;}
	    }
	}
    }
    return;
}

sub IKEGetIDPalyloadField {
    my($index,$frame)=@_;
    my($idtype,$id1,$id2,$proto,$port);

    $idtype=GFv('IK,ID#' . $index . ',IDtype',$frame);
    if($idtype eq $IKEDoi{'TI_ID_IPV6_ADDR'}){
	$id1=GFv('IK,ID#' . $index . ',ID',$frame);
    }
    elsif($idtype eq $IKEDoi{'TI_ID_IPV6_ADDR_SUBNET'}){
	$id1=GFv('IK,ID#' . $index . ',ID1',$frame);
	$id2=GFv('IK,ID#' . $index . ',ID2',$frame);
    }
    elsif($idtype eq $IKEDoi{'TI_ID_IPV6_ADDR_RANGE'}){
	$id1=GFv('IK,ID#' . $index . ',ID1',$frame);
	$id2=GFv('IK,ID#' . $index . ',ID2',$frame);
    }
    elsif($idtype eq $IKEDoi{'TI_ID_FQDN'}){
	$id1=GFv('IK,ID#' . $index . ',ID',$frame);
    }
    elsif($idtype eq $IKEDoi{'TI_ID_USER_FQDN'}){
	$id1=GFv('IK,ID#' . $index . ',ID',$frame);
    }
    $proto=GFv('IK,ID#' . $index . ',ProtocolID',$frame);
    $port=GFv('IK,ID#' . $index . ',Port',$frame);

    return $idtype,$id1,$id2,$proto,$port;
}

#============================================
# 
#============================================
# 
#  
#      
#  
#
#
#                  
#                  
#  
#
#        
#        
sub IKEFindScenarioInstanceFromEvent {
    my($event,$context)=@_;
    my($sceName,$inst,$key,$etype,$icookie,$rcookie,$msgID,$phase);

    if($event->{'Etype'} eq 'MSGREV'){
	# 
	$etype=GFv("IK,HD,ExchangeType",$event->{Data}->{Frame});
	# 
	$icookie=GFv("IK,HD,InitiatorCookie",$event->{Data}->{Frame});
	$rcookie=GFv("IK,HD,ResponderCookie",$event->{Data}->{Frame});
	# 
	$msgID=GFv("IK,HD,MessageID",$event->{Data}->{Frame});
	# 
	$inst=IKEFindFromIKEMsg($etype,$icookie,$rcookie,$msgID,$context->{'RequestSaID'});
	if(!$inst){
	    # 
	    if($etype eq $IKEDoi{'TI_ETYPE_AGG'} && $icookie && $rcookie eq '0000000000000000'){
		# 
		if( !($inst= IKCreateScenarioInst(IKFindScenarioFromKey(['responder','phase1','aggressive']))) ){
		    return '';
		}
		MsgPrint('DBG',"Phase-1 responder instance create\n");
		# 
		IKAddScenInst($inst);
		$inst->{'Phase'}=1;
		return $inst;
	    }
	    else{
		LogPrint('WAR','','',"Unknown IKE message received. Etype[%s] Icookie[%s] Rcookie[%s] MessageID[%s]\n",
			 $etype,$icookie,$rcookie,$msgID);
		return '';
	    }
	}
	return $inst;
    }
    elsif($event->{'Etype'} eq 'TIMEOUT'){
	return $event->{'Data'}->{'ScenarioInst'}
    }
    elsif($event->{'Etype'} eq 'START'){
	# 
	$key=$event->{'Data'}->{'Scenariokey'};

	# 
	$phase=(grep{$_ =~ /phase1/} @$key)?1:2;

	# 
	if(!($sceName=IKFindScenarioFromKey($key))){
	    LogPrint('ERR','','',"IKEFindScenarioInstance unmatch find Scenario from keyward\n");
	    return '';
	}
	# 
	$inst= IKCreateScenarioInst($sceName);

	$inst->{'Phase'}=$phase;
	$inst->{($phase eq 1)?'SaID1':'SaID2'}=
	    (ref($context->{'RequestSaID'}))?$context->{'RequestSaID'}->[0]->{'ID'}:$context->{'RequestSaID'}->{'ID'};
	# 
	# 

	# 
	IKAddScenInst($inst);
	
	return $inst;
    }
    elsif($event->{'Etype'} eq 'END'){
	MsgPrint('DBG',"IKEFindScenarioInstance not impliment yet\n");
    }
    LogPrint('ERR','','',"IKEFindScenarioInstance can't find Scenario Instance\n");
    return '';
}

# 
sub IKEFindFromIKEMsg {
    my($etype,$icookie,$rcookie,$msgID,$validSAID)=@_;
    my($key,$i,$inst,%ph1validSAID,$val);
    # 
    if($etype eq $IKEDoi{'TI_ETYPE_AGG'}){
	for $i (0..$#IKScenarioINST){
	    MsgPrint('DBG',"AGG Matching Cookie [%s][%s] <=>[%s][%s](%s)\n",$icookie,$rcookie,
		     $IKScenarioINST[$i]->{'InitiatorCookie'},$IKScenarioINST[$i]->{'ResponderCookie'},
		     $IKScenarioINST[$i]->{'ST'});
	    if($IKScenarioINST[$i]->{Phase} eq 1 && $IKScenarioINST[$i]->{InitiatorCookie} eq $icookie &&
	       $IKScenarioINST[$i]->{'ST'} ne 'PH1.complete'){
		if($IKScenarioINST[$i]->{ResponderCookie} eq '0000000000000000' ||
		   ($rcookie && $IKScenarioINST[$i]->{ResponderCookie} eq $rcookie)){
		    MsgPrint('DBG',"Match phase-1 instance %s:%s\n",
			     $IKScenarioINST[$i]->{'InitiatorCookie'},$IKScenarioINST[$i]->{'ResponderCookie'});
		    return $IKScenarioINST[$i];
		}
	    }
	}
	MsgPrint('DBG',"UnMatch phase-1 instance\n");
    }
    # 
    elsif($etype eq $IKEDoi{'TI_ETYPE_QUICK'}){
	# 
	$key={'InitiatorCookie'=>$icookie,'ResponderCookie'=>$rcookie,'Phase'=>2,'MessageID'=>$msgID};
	for $i (0..$#IKScenarioINST){
	    if(IsIncludeAssoc($IKScenarioINST[$i],$key) && $IKScenarioINST[$i]->{'ST'} ne 'PH2.complete'){
		MsgPrint('DBG',"Match phase-2 instance\n");
		return $IKScenarioINST[$i];
	    }
	}
	# API
	foreach $val (@$validSAID){
	    if($IKESAProfile{$val->{'ID'}}->{'PHASE'} eq 2){ $ph1validSAID{$IKESAProfile{$val->{'ID'}}->{'ISAKMP_SA_ID'}}='T'; }
	}
	# 
	for $i (0..$#IKScenarioINST){
	    if($IKScenarioINST[$i]->{Phase} eq 1 && 
	       $IKScenarioINST[$i]->{InitiatorCookie} eq $icookie &&
	       $IKScenarioINST[$i]->{ResponderCookie} eq $rcookie &&
	       $IKScenarioINST[$i]->{'ST'} eq 'PH1.complete'){
#               if($validSAID && !grep{$_->{'ID'} eq $IKScenarioINST[$i]->{'SaID1'}} @$validSAID ){next;}
# 
 		if(!$ph1validSAID{$IKScenarioINST[$i]->{'SaID1'}}){
 		    MsgPrint('WAR',"Phase2 message matched Phase1 SA instance(%s), but phase-1 SA not specified\n",
			     $IKScenarioINST[$i]->{'SaID1'});
 		    next;
 		}
		# 
		MsgPrint('DBG',"Match phase-2 first %s:%s\n",
			 $IKScenarioINST[$i]->{'InitiatorCookie'},$IKScenarioINST[$i]->{'ResponderCookie'});
		if( !($inst= IKCreateScenarioInst(IKFindScenarioFromKey(['responder','phase2','quick']))) ){
		    return '';
		}
		$inst->{'Phase1ID'}=$IKScenarioINST[$i]->{'ID'};
		$inst->{'Phase'}=2;
		# 
		IKAddScenInst($inst);
		return $inst;
	    }
	}
	MsgPrint('DBG',"UnMatch phase-2 instance\n");
    }
    elsif($etype eq $IKEDoi{'TI_ETYPE_INFO'}){
	for $i (0..$#IKScenarioINST){
	    MsgPrint('DBG',"INFO Matching Cookie [%s][%s] <=>[%s][%s](%s)\n",$icookie,$rcookie,
		     $IKScenarioINST[$i]->{'InitiatorCookie'},$IKScenarioINST[$i]->{'ResponderCookie'},
		     $IKScenarioINST[$i]->{'ST'});
	    if($IKScenarioINST[$i]->{'InitiatorCookie'} eq $icookie && $IKScenarioINST[$i]->{'ResponderCookie'} eq $rcookie){
		return $IKScenarioINST[$i];
	    }
	}
	MsgPrint('DBG',"UnMatch Infomation instance\n");
    }
    return '';
}
sub IsRegistedCookie {
    my($cookie,$side,$pktinfo,$inst,$context)=@_;
    my($i,$result);
    shift;shift;
    for $i (0..$#IKScenarioINST){
#	printf("IsRegistedCookie[%s] (%s:%s)\n",$cookie,$IKScenarioINST[$i]->{InitiatorCookie},$IKScenarioINST[$i]->{ResponderCookie});
	if(($side eq 'I' && $IKScenarioINST[$i]->{InitiatorCookie} eq $cookie) ||
	   ($side eq 'R' && $IKScenarioINST[$i]->{ResponderCookie} eq $cookie)){
	    $result='T';
	    last;
	}
    }
    IKSetEvalResult($context,'1op','registed',$result,$cookie);
    return $result;
}

sub IKEFindScenarioInstanceFromSAID {
    my($saids,$relation)=@_;
    my($i,$j,%match,$inst1,$said);

    for $j (0..$#$saids){
	$said=$saids->[$j];
	for $i (0..$#IKScenarioINST){
	    if($IKScenarioINST[$i]->{'SaID1'} eq $said || $IKScenarioINST[$i]->{'SaID2'} eq $said){
		$match{$IKScenarioINST[$i]->{'ID'}}=$IKScenarioINST[$i];
		next;
	    }
	    if($relation && $IKScenarioINST[$i]->{'Phase'} eq 2){
		$inst1=IKFindScenInstFromID($IKScenarioINST[$i]->{'Phase1ID'});
		if( $inst1->{'SaID1'} eq $said ){
		    $match{$IKScenarioINST[$i]->{'ID'}}=$IKScenarioINST[$i];
		}
	    }
	}
    }
    return [values(%match)];
}
# 
sub IKEDisableScenarioInstanceRelation {
    my($id,$notify,$reason)=@_;
    my($inst1,$i,@delID);
    
    if(ref($id) ne 'HASH'){$id=IKFindScenInstFromID($id);}
    push(@delID,$id->{'ID'});
    if($id->{'Phase'} eq 2){
	if( $inst1=IKFindScenInstFromID($id->{'Phase1ID'}) ){push(@delID,$inst1->{'ID'});}
    }
    else{
	$inst1=$id;
    }
    # 
    if($inst1){
	for $i (0..$#IKScenarioINST){
	    if( $IKScenarioINST[$i]->{'Phase1ID'} eq $inst1->{'ID'} ){
		push(@delID,$IKScenarioINST[$i]->{'ID'});
	    }
	}
    }
    for $i (0..$#delID){
	IKEDisableScenarioInstance($delID[$i],$notify,$reason);
    }
}
# 
sub IKEDisableScenarioInstance {
    my($id,$notify,$reason)=@_;
    my($inst,$i);
    if(!$reason){$reason='Unknown reason';}
    if(ref($id) eq 'HASH'){$id=$id->{'ID'};}

    if( $inst=IKDestroyedScenInst($id) ){
	$inst->{'DisableNotify'}=$notify;
	$inst->{'DestroyReason'}=$reason;
	if($inst->{'Phase'} eq 1){
	    $inst->{'ISAKMPStatus'}='INVALID';
	    MsgPrint('DBG',"Disable Phase1 Instance SA(%s) ID(%s)\n",$inst->{'SaID1'},$inst->{'ID'});
	}
	else{
	    $inst->{'IPSecINStatus'}='INVALID';
	    $inst->{'IPSecOUTStatus'}='INVALID';
	    MsgPrint('DBG',"Disable Phase2 Instance SA(%s) ID(%s)\n",$inst->{'SaID2'},$inst->{'ID'});
	}
    }

#     for $i (0..$#IKScenarioINST){
# 	if($IKScenarioINST[$i]->{'ID'} eq $id){
# 	    $inst=$IKScenarioINST[$i];
# 	    splice(@IKScenarioINST,$i,1);
# 	    $inst->{'DisableNotify'}=$notify;
# 	    $inst->{'DestroyReason'}=$reason;
# 	    if($inst->{'Phase'} eq 1){
# 		$inst->{'ISAKMPStatus'}='INVALID';
# 		MsgPrint('DBG',"Disable Phase1 Instance SA(%s) ID(%s)\n",$inst->{'SaID1'},$inst->{'ID'});
# 	    }
# 	    else{
# 		$inst->{'IPSecINStatus'}='INVALID';
# 		$inst->{'IPSecOUTStatus'}='INVALID';
# 		MsgPrint('DBG',"Disable Phase2 Instance SA(%s) ID(%s)\n",$inst->{'SaID2'},$inst->{'ID'});
# 	    }
# 	    push(@IKScenarioINSTDisable,$inst);
# 	}
#     }
}
sub IKEFindDisableScenarioInstanceFromCookie {
    my($icookie,$rcookie)=@_;
    my($i);
    for $i (0..$#IKScenarioINSTDisable){
	if($IKScenarioINSTDisable[$i]->{InitiatorCookie} eq $icookie &&
	   $IKScenarioINSTDisable[$i]->{ResponderCookie} eq $rcookie ){
	    return $IKScenarioINSTDisable[$i];
	}
    }
    return;
}
sub IKEGetPhase1Inst {
    my($inst)=@_;
    if(!ref($inst)){$inst=IKFindScenInstFromID($inst);}
    if($inst->{'Phase'} eq 1){return $inst;}
    else{return IKFindScenInstFromID($inst->{'Phase1ID'});}
    return;
}
sub IKEGetSaExpired {
    my(@said);
    my($i);
    for $i (0..$#IKScenarioINSTDisable){
	if(!$IKScenarioINSTDisable[$i]->{'DisableNotify'}){
	    push(@said,$IKScenarioINSTDisable[$i]->{'ID'});
	    $IKScenarioINSTDisable[$i]->{'DisableNotify'}='TRUE';
	}

    }
    return -1<$#said?\@said:'';
}
sub IKESendDLMsgInfoForALL {
    my($i,@ids);
    for $i (0..$#IKScenarioINST){
	if($IKScenarioINST[$i]->{'Phase'} eq 1){next;}
	if($IKScenarioINST[$i]->{'ST'} eq 'PH2.complete'){
	    IKEInfoExchSend($IKScenarioINST[$i]->{'ID'},'DL','',{'Interface'=>$IKScenarioINST[$i]->{'Link'}});
	}
    }
    for $i (0..$#IKScenarioINST){
	if($IKScenarioINST[$i]->{'Phase'} eq 2){next;}
	if($IKScenarioINST[$i]->{'ST'} eq 'PH1.complete'){
	    IKEInfoExchSend($IKScenarioINST[$i]->{'ID'},'DL','',{'Interface'=>$IKScenarioINST[$i]->{'Link'}});
	}
    }
    @ids=keys(%IKScenarioINSTID);
    for $i (0..$#ids){
	IKEDisableScenarioInstance($ids[$i],'','Scenario end');
    }
}
#============================================
# 
#============================================
sub IKECheckTimeout {
    my($i,$inst,@disable);

    # 
    for $i (0..$#IKScenarioINST){
	$inst=$IKScenarioINST[$i];
	if($inst->{'ST'} eq 'PH1.complete'){
	    if($inst->{'ISAKMPStart'}+$inst->{'ISAKMPTimeout'} < time()){
		MsgPrint('WAR',"Phase1 SA[%s] Timeout\n",$inst->{'ID'});
		push(@disable,$inst);
	    }
	}
	elsif($inst->{'ST'} eq 'PH2.complete'){
	    if($inst->{'IPSecINStart'}+$inst->{'IPSecINTimeout'} < time() ||
	       $inst->{'IPSecOUTStart'}+$inst->{'IPSecOUTTimeout'} < time() ){
		MsgPrint('WAR',"Phase2 SA[%s] Timeout\n",$inst->{'ID'});
		push(@disable,$inst);
	    }
	}
    }
    # 
    for $i (0..$#disable){
	IKEDisableScenarioInstance($disable[$i],'','Timeout');
    }
}
sub IKEIsTimeoutSA {
    my($inst)=@_;
    if(!ref($inst)){$inst=IKFindScenInstFromID($inst);}
    if(!$inst || !ref($inst)){return 'TIMEOUT';}
    if($inst->{'ST'} eq 'PH1.complete' && $inst->{'ISAKMPStart'}+$inst->{'ISAKMPTimeout'} < time()){
	return 'TIMEOUT';
    }
    elsif($inst->{'ST'} eq 'PH2.complete' &&
	  ($inst->{'IPSecINStart'}+$inst->{'IPSecINTimeout'} < time() ||
	   $inst->{'IPSecOUTStart'}+$inst->{'IPSecOUTTimeout'} < time())){
	return 'TIMEOUT';
    }
    return ;
}
#============================================
# 
#============================================
sub IKERandom {
    my($size)=@_;
    my($val,$i);
    if($IKELoadPerlMO){
	$val=Crypt::Random::makerandom ( Size => 8*$size, Strength => 1,Device=>'/dev/urandom');
	$val=IKBignumToHex(PARI $val);
    }
    else{
	for $i (0..$size/4){
	    $val .= sprintf("%08x",int(rand(0xFFFFFFFF)));
	}
	$val = substr($val,0,$size*2);
    }
    return $val;
}
sub IKEMkSPI { # SPI
    my($spi);
    # 
    #   599427488,230314073
    $spi=hex( IKERandom(4) );
    MsgPrint('DBG',"Create SPI [%s:%x:%08x]\n",$spi,$spi,$spi);
    return $spi;
}
sub IKEMkCookie {
    my($localAddr,$localPort,$remoteAddr,$remotePort)=@_;

    # 
    # $ctx = Digest::SHA1->new;
    # $ctx->add(pack('H64',"9001000001f49001000001f47405d0409360f1c31e5810635fa52e8565447c50"));
    # $digest = $ctx->hexdigest;

    # 
    return IKERandom(8);
}
sub IKEMkNonce {
    # 
    return IKERandom(16);
}
sub IKEMkMsgID {
    # 
    return IKERandom(4);
}

#============================================
# 
#============================================
# 
sub IKEMkDH {
    my($keydesc)=@_;
    my($i,$dh,$priv,$pub,%ret);

    # DH
    for $i (0..$#IKEDHGrpDesc){
	if( $IKEDHGrpDesc[$i]->{'desc'} eq $keydesc){
	    $keydesc=$IKEDHGrpDesc[$i];
	    last;
	}
    }
    if(!ref($keydesc)){
	MsgPrint('ERR',"DH Group description[$keydesc] is illegal\n");
	return;
    }
    if($IKELoadPerlMO){
	# DH
	$dh = Crypt::DH->new;
	# GEN1
	$dh->g($keydesc->{'gen1'});
	# 
	$dh->p('0x' . $keydesc->{'prime'});
	# DH
	$dh->generate_keys;
	# 
#    printf("%s\n", PrintBignum(Math::Pari::_hex_cvt($prim)));
#    printf("%s\n", PrintBignum($dh->priv_key));
#    printf("%s\n", PrintBignum($dh->pub_key));
	$priv=IKBignumToHex($dh->priv_key);
	$pub=IKBignumToHex($dh->pub_key);
    }
    else{
	%ret=vDHGen2($keydesc->{'prime'}, $keydesc->{'gen1'});
	$pub=$ret{'DHGen_Results.Public_Key.data'};
	$priv=$ret{'DHGen_Results.Private_Key.data'};
    }
    return $pub,$priv;
}
# 
sub IKEMkDHSharedKey {
    my($keydesc,$localpub,$localpriv,$remotepub)=@_;
    my($dh,$shared_secret,$i,%ret);

    # DH
    for $i (0..$#IKEDHGrpDesc){
	if( $IKEDHGrpDesc[$i]->{'desc'} eq $keydesc){
	    $keydesc=$IKEDHGrpDesc[$i];
	    last;
	}
    }
    if(!ref($keydesc)){
	MsgPrint('ERR',"DH Group description[$keydesc] is illegal\n");
	return;
    }

    if($IKELoadPerlMO){
	# 0x
	if(substr($localpub,0,2) ne '0x'){
	    $localpub = '0x' . $localpub;
	}
	if(substr($localpriv,0,2) ne '0x'){
	    $localpriv = '0x' . $localpriv;
	}
	if(substr($remotepub,0,2) ne '0x'){
	    $remotepub = '0x' . $remotepub;
	}
	$dh = Crypt::DH->new;
	$dh->p('0x' . $keydesc->{'prime'});
	$dh->pub_key(Math::Pari::_hex_cvt($localpub));
	$dh->priv_key(Math::Pari::_hex_cvt($localpriv));
	$shared_secret = $dh->compute_key( Math::Pari::_hex_cvt($remotepub) );
	$shared_secret = IKBignumToHex($shared_secret);
    }
    else{
	%ret=vDHComp2($keydesc->{'prime'},$keydesc->{'gen1'},$localpub,$localpriv,$remotepub);
	$shared_secret=$ret{'DHComp_Results.Shared_Key.data'};
    }
#    MsgPrint('DBG',"SHARED Key(%s)\n", $shared_secret);
    return $shared_secret;
}
# 
sub IKEPrf {
    my($algo,$key,@data)=@_;
    my($digest,$data);

    # 
    $data=join('',@data);

    # 
    if($algo eq $IKEDoi{'TI_ATTR_HASH_ALG_SHA'}){
	$digest=IKEHmacSHA1($key,$data);
    }
    else{
	$digest=IKEHmacMD5($key,$data);
    }
    return $digest;
}
sub IKEHmacMD5 {
    my($key,$data)=@_;
    my($hmac,$digest,%ret);
    if($IKELoadPerlMO){
	$hmac = Digest::HMAC_MD5->new(pack('H' . length($key), $key));
	$hmac->add(pack('H' . length($data), $data));
	$digest=$hmac->hexdigest;
    }
    else{
	%ret=vPRFComp('hmacmd5', $key, $data);
	$digest=$ret{'PRFComp_Results.Digest.data'};
    }
    return $digest;
}
sub IKEHmacSHA1 {
    my($key,$data)=@_;
    my($hmac,$digest,%ret);
    if($IKELoadPerlMO){
	$hmac = Digest::HMAC_SHA1->new(pack('H' . length($key), $key));
	$hmac->add(pack('H' . length($data), $data));
	$digest=$hmac->hexdigest;
    }
    else{
	%ret=vPRFComp('hmacsha1', $key, $data);
	$digest=$ret{'PRFComp_Results.Digest.data'};
    }
    return $digest;
}
sub IKESHA1 {
    my($data)=@_;
    my($ctx);

    $ctx = Digest::SHA1->new;
    $ctx->add(pack('H' . length($data), $data));
    return $ctx->hexdigest;
}
sub IKEMD5 {
    my($data)=@_;
    return Digest::MD5::md5_hex( pack('H' . length($data), $data) );
}
# 
sub IKEGetAlgoLength {
    my($algo,$doi,$len)=@_;
    my($method,$i);
    $method=$IKEAlgo{$algo};
    for $i (0..$#$method){
	if( $method->[$i]->{'Doi'} eq $doi){
	    return $method->[$i]->{'Length'};
	}
    }
    LogPrint('WAR','','',"Unknown Hash Algo(algo length)[%s]\n",$doi);
    return 0;
}
sub IKEGetCBCLength {
    my($algo,$doi)=@_;
    my($method,$i);
    $method=$IKEAlgo{$algo};
    for $i (0..$#$method){
	if( $method->[$i]->{'Doi'} eq $doi){
	    return $method->[$i]->{'CBCBlock'};
	}
    }
    LogPrint('WAR','','',"Unknown Hash Algo(cbc size)[%s]\n",$doi);
    return 0;
}
# 
sub IKECalcIKEEncKey {
    my($enctype,$enclen,$hashtype,$skeyid_e)=@_;
    my($hashlen,$cipherkey,$digest,$len);

    # 
    $enclen=(IKEGetAlgoLength('EncIKE',$enctype,$enclen)/8)*2;

    # 
    $hashlen=(IKEGetAlgoLength('Hash',$hashtype)/8)*2;

    if($enclen<=length($skeyid_e)){
	$cipherkey=substr($skeyid_e,0,$enclen);
    }
    else{
	$digest='00';
	while(0<$enclen){
	    $digest=IKEPrf($hashtype,$skeyid_e,$digest);
	    $len = (length($digest)<$enclen)?length($digest):$enclen;
	    $cipherkey .= substr($digest,0,$len);
	    $enclen -= $len;
	    if(length($digest) ne $hashlen){
		MsgPrint('ERR',"Enckey caluculate error\n");
		return '';
	    }
	}
    }
    return $cipherkey;
}
# 
#   KEYMAT = K1 | K2 | K3 | ...
#   where
#     src = [ g(qm)^xy | ] protocol | SPI | Ni_b | Nr_b
#      K1 = prf(SKEYID_d, src)
#      K2 = prf(SKEYID_d, K1 | src)
#      K3 = prf(SKEYID_d, K2 | src)
#      Kn = prf(SKEYID_d, K(n-1) | src)
sub IKECalcIPsecEncKey {
    my($hashtype,$enctype,$authtype,$protocol,$spi,$iNonce,$rNonce,$skeyid_d)=@_;
    my($hexString,$hashData,$encKey,$hashKey,$enclen,$hashlen,$keymatlen,$digest,$len,$i,$keymat,$cbcSize);

    $hexString=$protocol . sprintf("%08x",$spi) . $iNonce . $rNonce;
    $hashData=IKEPrf($hashtype,$skeyid_d,$hexString);
    $keymat=$hashData;
    $cbcSize=length($hashData)/2;

    # 
    $enclen=IKEGetAlgoLength('EncIPSEC',$enctype,$enclen);

    # 
    $hashlen=IKEGetAlgoLength('Hash',$authtype);
    MsgPrint('DBG4',"enclen[%s]  hashlen[%s].\n",$enclen, $hashlen);

    # 
    $keymatlen = $enclen + $hashlen;
    $keymatlen = ($keymatlen / ($cbcSize*8)) + (($keymatlen % ($cbcSize*8)) ? 1 : 0);
    MsgPrint('DBG4',"Generating K1...K%d for KEYMAT.\n",$keymatlen);
    for $i (2..$keymatlen){
	$hashData = IKEPrf($hashtype,$skeyid_d,$hashData . $hexString);
	$keymat .= $hashData;
    }
    MsgPrint('DBG4',"K(%d) CBC[%s]byte  KEYMAT[%s]byte  ENC[%s]byte  HASH[%s]byte\n",
	     $keymatlen,$cbcSize,length($keymat)/2,$enclen/8,$hashlen/8);
    $encKey=substr($keymat,0,$enclen/4);
    $hashKey=substr($keymat,$enclen/4,$hashlen/4);
#    $hashKey=substr($keymat,(length($keymat)/2-$hashlen/8)*2); 
    MsgPrint('DBG4',"Calc ENCkey[%s]byte  HASHkey[%s]byte\n", length($encKey)/2,length($hashKey)/2);
    return $encKey,$hashKey;
}

sub IKENewIV {
    my($encAlgo,$hashType,$localPub,$remotePub)=@_;
    my($digest,$size);
    
    if($IKELoadPerlMO){
	# 
	if($hashType eq $IKEDoi{'TI_ATTR_HASH_ALG_SHA'}){
	    $digest=IKESHA1($localPub . $remotePub);
	}
	else{
	    $digest=IKEMD5($localPub . $remotePub);
	}
	$size=IKEGetCBCLength('EncIKE',$encAlgo);
        MsgPrint('DBG',"IV1 size=[$size] IV=[%s]\n",substr($digest,0,$size*2));
	return substr($digest,0,$size*2);
    }
    else{
 	# TAHI
 	return;
    }
}

sub IKENewIV2 {
    my($encAlgo,$hashType,$phase1IV,$messageID)=@_;
    my($digest,$size);
    
    if($IKELoadPerlMO){
	$messageID=sprintf("%08x",$messageID);
	# 
	if($hashType eq $IKEDoi{'TI_ATTR_HASH_ALG_SHA'}){
	    $digest=IKESHA1($phase1IV . $messageID);
	}
	else{
	    $digest=IKEMD5($phase1IV . $messageID);
	}
	$size=IKEGetCBCLength('EncIKE',$encAlgo);
	MsgPrint('DBG',"IV2 size=[$size] IV=[%s]\n",substr($digest,0,$size*2));
	return substr($digest,0,$size*2);
    }
    else{
 	# TAHI
 	return;
    }
}

sub IKBignumToHex {
    my($val)=@_;
    my($mod,$base,$i,$msg,$hexstr);
    $base = 0x10000;
    $base = PARI $base;
    while($base<=$val){
	$mod=int($val) % $base;
	$val=$val / $base;
	$msg = sprintf("%04x%s",$mod,$msg);
    }
    $mod=int($val) % $base;
    if($mod){$msg=sprintf("%x%s",$mod,$msg);}
    for($i=0;$i<length($msg);$i+=8){
	$hexstr .= substr($msg,$i,8);
    }
    $hexstr .= substr($msg,$i);
    return $hexstr;
}
sub PrintBignum {
    my($val)=@_;
    my($mod,$base,$i,$msg,$hexstr);

    $base = 0x10000;
    $base = PARI $base;
    while($base<=$val){
	$mod=int($val) % $base;
	$val=$val / $base;
	$msg = sprintf("%04x%s",$mod,$msg);
    }
    $mod=int($val) % $base;
    if($mod){$msg=sprintf("%x%s",$mod,$msg);}
    for($i=0;$i<length($msg);$i+=8){
	if($i && !($i % 64)){$hexstr .= "\n";}
	$hexstr .= substr($msg,$i,8) . ' ';
    }
    $hexstr .= substr($msg,$i);
    return $hexstr;
}

# 
sub IKECalcSecParam {
    my($inst,$frame,$prof)=@_;
    my($skeyid,$skeyid_d,$skeyid_a,$skeyid_e,$iv,$enckey,$remoteNC,$localGxy,$remoteGxy,$hashData);

    $remoteGxy=GFv("IK,KE,KeyExchangeData",$frame);
    $localGxy=IKEMkDHSharedKey($prof->{'ATTR_PH1_GRP_DESC'},$inst->{'DHPublicKey'},
			       $inst->{'DHPrivateKey'},$remoteGxy);
# printf("pub[%s] priv[%s] localGxy[%s] remoteGxy[%s]\n",
#   $inst->{'DHPublicKey'},$inst->{'DHPrivateKey'},$localGxy,$remoteGxy);    
    # SKEYID
    $remoteNC=GFv("IK,NC,NonceData",$frame);
    $skeyid=IKEPrf($inst->{'PRFHashAlgo'},unpack('H*',$prof->{'PSK'}),
		   ($inst->{'Side'} eq 'initiator' ? $inst->{'PH1LocalNonce'}:$remoteNC),
		   ($inst->{'Side'} eq 'initiator' ? $remoteNC:$inst->{'PH1LocalNonce'}));
# printf("localNC[%s] remoteNC[%s] PSK[%s] SKEYID[%s]\n",$inst->{'PH1LocalNonce'},$remoteNC,$prof->{'PSK'},$skeyid);    

    # SKEYID_d
    $skeyid_d=IKEPrf($inst->{'PRFHashAlgo'},$skeyid,
		     $localGxy,$inst->{'InitiatorCookie'},$inst->{'ResponderCookie'},'00');
# printf("localCookie[%s] remoteCookie[%s] SKEYID_d[%s]\n",
#    $inst->{'InitiatorCookie'},$inst->{'ResponderCookie'},$skeyid_d);    

    # SKEYID_a
    $skeyid_a=IKEPrf($inst->{'PRFHashAlgo'},$skeyid,
		     $skeyid_d,$localGxy,$inst->{'InitiatorCookie'},$inst->{'ResponderCookie'},'01');
# printf("localCookie[%s] remoteCookie[%s] SKEYID_a[%s]\n",
#    $inst->{'InitiatorCookie'},$inst->{'ResponderCookie'},$skeyid_a);    

    # SKEYID_e
    $skeyid_e=IKEPrf($inst->{'PRFHashAlgo'},$skeyid,
		     $skeyid_a,$localGxy,$inst->{'InitiatorCookie'},$inst->{'ResponderCookie'},'02');
# printf("localCookie[%s] remoteCookie[%s] SKEYID_e[%s]\n",
#    $inst->{'InitiatorCookie'},$inst->{'ResponderCookie'},$skeyid_e);    

    # 
    $enckey=IKECalcIKEEncKey($inst->{'IKEEncAlgo'},$inst->{'IKEEncLeng'},$inst->{'PRFHashAlgo'},$skeyid_e);

    # IV
    $iv=IKENewIV($inst->{'IKEEncAlgo'},$inst->{'PRFHashAlgo'},$inst->{'DHPublicKey'},$remoteGxy);

    # 
    $inst->{'DHGxy'}=$localGxy;
    $inst->{'DHRemotePublicKey'}=$remoteGxy;
    $inst->{'SKEYID'}=$skeyid;
    $inst->{'SKEYID_d'}=$skeyid_d;
    $inst->{'SKEYID_a'}=$skeyid_a;
    $inst->{'SKEYID_e'}=$skeyid_e;
    $inst->{'IV'}=$iv;
    $inst->{'IKEEncKey'}=$enckey;
    $inst->{'IKEEncKeyStart'}=time();
    $inst->{'IKEEncKeyTimeout'}=$prof->{'ATTR_PH1_SA_LD'}?$prof->{'ATTR_PH1_SA_LD'}:$IKESATimeout;
    return;
}

#============================================
# 
#============================================

# 
#  frame::= 
#           
#              
#                
#                
sub GFv {
    my($field,$frame,$mode)=@_;
    my($context,$val,$status);
  
    if(ref($frame) eq 'ARRAY' && !ref($frame->[0]) && !ref($frame->[1])){
	$status=GFvForFrames($field,$frame->[0],$frame->[1],$frame->[2]);
	return $status;
    }
    elsif(!ref($frame)){
	if($frame eq ''){return '';}
	if( $IKMsgCapture[$frame]->{'Frame'} ){
	    $frame=$IKMsgCapture[$frame]->{'Frame'};
	}
	else{
	    if($IKMsgCapture[$frame]->{'Pkt'}){
		$IKMsgCapture[$frame]->{'Frame'}=IKEParse($IKMsgCapture[$frame]->{'Pkt'});
		$frame=$IKMsgCapture[$frame]->{'Frame'};
	    }
	    else{
		return '';
	    }
	}
    }
    $context->{pkt}=$frame;
    $context->{field}=$field;

    # 
    ($val,$status,$field)=IKFieldVL($frame,$field,'',0,$context);
    return $status?'':((!ref($val)||ref($val) eq 'HASH')?$val:($#$val<1?$val->[0]:$val));
}
# ``
sub GFe {
    my($field,$frame,$mode)=@_;
    my($context,$val,$status);
    
    $context->{pkt}=$frame;
    $context->{field}=$field;

    # 
    ($val,$status,$field)=IKFieldVL($frame,$field,'eval',0,$context);
    return $status?'':((!ref($val)||ref($val) eq 'HASH')?$val:($#$val<1?$val->[0]:$val));
}
# 
sub IFv {
    my($field,$pktinfo,$inst,$context)=@_;
    my(@tags,$i);
    if(ref($inst) ne 'HASH'){
	$inst=IKFindScenInstFromID($inst);
	if(ref($inst) ne 'HASH'){return '';}
    }
    @tags=split(/,/,$field);
    for $i (0..$#tags){
	$inst=$inst->{$tags[$i]};
    }
    return $inst;
}
# 
sub Fv {
    my($field,$pktinfo,$inst,$context)=@_;
    my($val,$status,$v1);

    $context->{pkt}=$pktinfo;
    $context->{field}=$field;

    # 
    ($val,$status,$field)=IKFieldVL($pktinfo,$field,'',0,$context);
    $val=$status?'':((!ref($val)||ref($val) eq 'HASH')?$val:($#$val<1?$val->[0]:$val));
    IKSetEvalResult($context,'1op','v',$status,$val);
    return $v1;
}
# 
sub GPf {
    my($field,$phase,$pktinfo,$inst,$context)=@_;
    my($prof,$said);
#    PrintVal($inst);
    if($inst->{'Phase'} eq 1){
	$said=$inst->{'SaID1'};
    }
    elsif($phase eq 1){
	$inst=IKFindScenInstFromID($inst->{'Phase1ID'});
	$said=$inst->{'SaID1'};
    }
    else{
	$said=$inst->{'SaID2'};
    }
    if( !($prof=IKEGetSAProf($said)) ){
	return '';
    }
    return $prof->{$field};
}
# HAHI
#   ET:   Frame_Ether.Hdr_Ether
#   IP6:  Frame_Ether.Packet_IPv6.Hdr_IPv6
#   UDT6: Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP
#   Ether, IPv6, IPv6UDP 
sub PFv {
    my($field,$pktinfo,$inst,$context)=@_;
    my(@tags,$pkt,$fname);
    
    if(!($pkt=$context->{'RecvPkt'})){
	if(!($pkt=$context->{'Event'}->{'Data'}->{'Packet'})){return '';}
    }
    @tags=split(/,/,$field);
    if($tags[0] eq 'ET'){
	$fname='Frame_Ether.Hdr_Ether.' . $tags[1];
    }
    elsif($tags[0] eq 'IP6'){
	$fname='Frame_Ether.Packet_IPv6.Hdr_IPv6.' . $tags[1];
    }
    elsif($tags[0] eq 'UDP6'){
	$fname='Frame_Ether.Packet_IPv6.Upp_UDP.Hdr_UDP.' . $tags[1];
    }
    else{return '';}
    return $pkt->{$fname};
}
sub GFvForFrames {
    my($field,$start,$end,$cond)=@_;
    my($count,$i,$val,@vals);
    if( ($count=$#IKMsgCapture)<0 ){return '';}
    if($start eq 'top' || $start eq ''){$start=0;}
    elsif($start eq 'last')            {$start=$count;}
    elsif($start eq 'before')          {if($count eq 0){return '';} $start=$count-1;}
    if($end eq 'top')                  {$end=0;}
    elsif($end eq 'last' || $end eq ''){$end=$count;}
    elsif($end eq 'before')            {if($count eq 0){return '';} $end=$count-1;}
    if($start<=$end){
	for($i=$start;$i<=$end;$i++){
	    if($cond){
		if($cond eq 'in'  && $IKMsgCapture[$i]->{'Direction'} ne 'in'){next;}
		if($cond eq 'out' && $IKMsgCapture[$i]->{'Direction'} ne 'out'){next;}
	    }
	    $val=GFv($field,$IKMsgCapture[$i]->{'Frame'});
	    if(ref($val) eq 'ARRAY'){push(@vals,@$val);}
	    elsif($val ne ''){push(@vals,$val);}
	}
    }
    else{
	for($i=$start;$end<=$i;$i--){
	    if($cond){
		if($cond eq 'in'  && $IKMsgCapture[$i]->{'Direction'} ne 'in'){next;}
		if($cond eq 'out' && $IKMsgCapture[$i]->{'Direction'} ne 'out'){next;}
	    }
	    $val=GFv($field,$IKMsgCapture[$i]->{'Frame'});
	    if(ref($val) eq 'ARRAY'){push(@vals,@$val);}
	    elsif($val ne ''){push(@vals,$val);}
	}
    }
    return -1<$#vals?\@vals:'';
}
#============================================
# 
#============================================
sub IKERIsEqualAttr {
    my($phase,$attr1,$attr2,$pktinfo,$inst,$context)=@_;
    my($i,$j,$matched,$aftype);
    if(ref($attr1) eq 'ARRAY' || ref($attr2) eq 'ARRAY'){
	if(ref($attr1) ne ref($attr2)){goto ERROR;}
	if($#$attr1 ne $#$attr2){goto ERROR;}
	if($#$attr1 ne 1){goto ERROR;}
	$attr1=$attr1->[0];
	$attr2=$attr2->[0];
    }
    $attr1=$attr1->{'ATT'};
    $attr2=$attr2->{'ATT'};
    if(ref($attr1) ne ref($attr2)){goto ERROR;}
    if($#$attr1 ne $#$attr2){goto ERROR;}
    for $i (0..$#$attr1){
	$matched='T';
	for $j (0..$#$attr2){
	    if($attr1->[$i]->{'Type'} eq $attr2->[$j]->{'Type'}){
		if($attr1->[$i]->{'Value'} eq $attr2->[$j]->{'Value'}){
		    if($attr1->[$i]->{'AF'} eq $attr2->[$j]->{'AF'}){$matched='T';}
		    else{
			if($phase eq 1){
			    $aftype=[$IKEDoi{'TI_ISAKMP_GRP_PI'},$IKEDoi{'TI_ISAKMP_GRP_GEN_ONE'},
				     $IKEDoi{'TI_ISAKMP_GRP_GEN_TWO'},$IKEDoi{'TI_ISAKMP_GRP_CURVE_A'},
				     $IKEDoi{'TI_ISAKMP_GRP_CURVE_B'},$IKEDoi{'TI_ISAKMP_SA_LD'},
				     $IKEDoi{'TI_ISAKMP_GRP_ORDER'}];
			}
			else{
			    $aftype=[$IKEDoi{'TI_IPSEC_SA_LD'},$IKEDoi{'TI_IPSEC_COMP_PRIVALG'}];
			}
			if(grep{$attr1->[$i]->{'Type'} eq $_} @$aftype){$matched='T';}
		    }
		}
		last;
	    }
	}
	if(!$matched){last;}
    }
    if($matched){
	IKSetEvalResult($context,'2op','v','OK');
	return 'OK';
    }
ERROR:

    IKSetEvalResult($context,'2op','v','');
    return '';
}
sub IKERLTandLDorder {
    my($phase,$trans,$pktinfo,$inst,$context)=@_;
    my($i,$j,$attr,$notExitType,$before);

    if(ref($trans) ne 'ARRAY'){
	$trans=[$trans];
    }
    $notExitType='';
    for $i (0..$#$trans){
	$attr=$trans->[$i]->{'ATT'};
	$before='';
	for $j (0..$#$attr){
	    if($phase eq 2){
		if($attr->[$j]->{'Type'} eq $IKEDoi{'TI_IPSEC_SA_LD'}){
#		    printf("IKERLTandLDorder [%s:%s]\n",$attr->[$j]->{'Type'},$before);
		    if($before ne $IKEDoi{'TI_IPSEC_SA_LD_TYPE'}){$notExitType='T';last;}
		}
	    }
	    else{
		if($attr->[$j]->{'Type'} eq $IKEDoi{'TI_ISAKMP_SA_LD'}){
		    if($before ne $IKEDoi{'TI_ISAKMP_SA_LD_TYPE'}){$notExitType='T';last;}
		}
	    }
	    $before=$attr->[$j]->{'Type'};
	}
	if($notExitType){last;}
    }
    IKSetEvalResult($context,'1op','v',$notExitType?'':'OK');
    return $notExitType?'':'OK';
}

#============================================
# 
#============================================

# TAHI
# 
sub IKEParse {
    my($pkt)=@_;
    my($key,$val,$frame,@tags,@keys,@subnode,$i,$j,$enckey,$ord,$ordName,$pttn);

    $enckey='.ISAKMP_Encryption.Decrypted.PlainText';
    # 
    if($val=$pkt->{$IKEFrameHeadField . $enckey}){
	@tags=split(/\s/,$val);
	@subnode=map{$IKEFrameHeadField . "$enckey." . $_} @tags;
	unshift(@subnode,$IKEFrameHeadField . '.Hdr_ISAKMP');
    }
    else{
	$val=$pkt->{$IKEFrameHeadField};
	@tags=split(/\s/,$val);
	@subnode=map{$IKEFrameHeadField . '.' . $_} @tags;
    }

    @keys=sort keys(%$pkt);
    for $j (0..$#subnode){
	@elskey=();
	for $i (0..$#keys){
	    $key=$keys[$i];     # 
	    $val=$pkt->{$key};  # 
	    # 
	    if($key =~ /^$subnode[$j](?:[#\.]|\z)/){
#printf("<< [$key] \n");
		$key =~ /^$IKEFrameHeadField\.(.+)/;
		@tags=split(/\./,$1);
		$frame=IKDecodeFieldTree(\@tags,$val,'Udp_ISAKMP',$frame);
#printf(">> [$key]\n");
	    }
            else{
		push(@elskey,$key);
	    }				      
	}
       @keys=@elskey;
    }

    if($pkt->{ $IKEFrameHeadField . $enckey}){
	$val = 'Hdr_ISAKMP ' . $pkt->{ $IKEFrameHeadField . $enckey};
    }
    else{
	$val = $pkt->{$IKEFrameHeadField};
    }
    ($ord,$ordName)=IKFieldOrder('Udp_ISAKMP',$val);
    $frame->{'++'}=$ord;
    $frame->{'+++'}=$ordName;
    return {'###'=>'ISAKMP','##'=>'Udp_ISAKMP',IK=>$frame};
}

# IKR
#  $name
sub IKEAddPayload {
    my($upper,$name,$data,$nextpayload)=@_;
    my($ikeTemp,$val,$key,$value,$init,$i,@tmp,$set);

    if(!$name){
	$name=$data->{'###'};
	$val={%$data};
    }
    else{
	if(!($ikeTemp=$IKEFrameFieldMapAssoc{$name})){
	    MsgPrint('WAR',"Templete name[$name] is illegal\n");
	    return '';
	}
	# 
	while(($key,$value)=each(%$ikeTemp)){
	    $set='T';
	    if($key eq '##'){$val->{'##'}=$value;}
	    elsif($key eq '#Name#'){$val->{'###'}=$value;}
	    elsif(substr($key,0,1) eq '#'){$set='';}
	    elsif(ref($value)){
		$name=$value->{'#Name#'};
		$init=$value->{'IV'};
	    }
	    elsif($value eq '@@@'){$set='';}
	    else{
		$name=$value;
		$init='';
	    }
	    # 
	    if($set){$val->{$name}=($data->{$name} eq '')?$init:$data->{$name};}
	}

	$name=$ikeTemp->{'#Name#'};
    }
    if($nextpayload){
	$val->{'NextPayload'}=IKEPayloadID($nextpayload);
    }
    push(@{$upper->{$name}},$val);
    # 
    @tmp=grep{$_ =~ /$name#[0-9]*/ } @{$upper->{'++'}};
    push(@{$upper->{'++'}},$name . '#' . ($#tmp+1));
    return $val;
}

#============================================
# 
#============================================

# IKR
sub IKEComposePayload {
    my($frame)=@_;
    my($size,$status);
    # TAHI
#    if($TAHIPlatformMode eq 'HEX'){
	($status,$size)=IKEComposePayloadIN($frame);
	if(!$status){$frame->{HD}->[0]->{Length}=$size;}
#    }
    return $status;
}
sub IKEComposePayloadIN {
    my($frame)=@_;
    my($order,$i,$tag,$index,$before,$next,$hexStTemp,$field,$size,$len,$status);

    # 
    #   
    #   
    if($order=$frame->{'++'}){
	for $i (0..$#$order){
	    ($tag,$index)=IKPKTIndexTag($order->[$i]);
	    if(!($next=$frame->{$tag})){
		MsgPrint('ERR',"IKE Message next payload($tag) struct invalid\n");
		return 'Invalid struct',0;
	    }
	    # NextPayload
	    if($before && defined($before->{'NextPayload'})){
		$before->{'NextPayload'}=IKEPayloadID($frame->{$tag}->[$index]->{'##'});
	    }
	    # 
	    $before=$frame->{$tag}->[$index];
	    ($status,$len)=IKEComposePayloadIN($before);
	    if($status){return $status;}
	    $size += $len;
	}
    }
    # 
    if(!($hexStTemp=$HXPKTPatternDB{$frame->{'##'}}) || !($field=$hexStTemp->{'field'})){return '',$size;}
    # 
    for $i (0..$#$field){
	if(ref($field->[$i]->{'SZ'})){
	    if($field->[$i]->{'TY'} eq 'hex'){
		$size += length($frame->{$field->[$i]->{'NM'}})/2;
	    }
	    if($field->[$i]->{'TY'} eq 'byte'){
		$size += length($frame->{$field->[$i]->{'NM'}});
	    }
	    if($field->[$i]->{'TY'} eq 'short'){
		$size += 2;
	    }
	    if($field->[$i]->{'TY'} eq 'long'){
		$size += 4;
	    }
	    if($field->[$i]->{'TY'} eq 'ipv6'){
		$size += 16;
	    }
	}
	else{
	    $size += $field->[$i]->{'SZ'};
	}
    }

    # 
    if(defined($frame->{'PayloadLength'}) && !$frame->{'PayloadLength'}){
	$frame->{'PayloadLength'}=$size;
    }
    return '',$size;
}
sub IKENewPacket (){
    return {'##'=>Udp_ISAKMP,'###'=>IK,'++'=>()};
}

# IKE
sub IKEWritePktDef ($){
    my($msg) = @_;
    open(OUT, "> " . $IKE_SUB_PKTDEF);
    print OUT "$msg";
    close(OUT);
}

#============================================
# 
#============================================
#
# 
#   
#               
#   
#               
#               
# 
#   
#               
#   
#               
#

# 
sub IKEGetIVEC {
    my($pkt)=@_;
    return $pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_ISAKMP.ISAKMP_Encryption.IVEC'};
}
sub IKEIsCryptedFrame {
    my($pkt)=@_;
    return $pkt->{'Frame_Ether.Packet_IPv6.Upp_UDP.Udp_ISAKMP.ISAKMP_Encryption.Crypted'};
}

# 
sub IKESetupEncInfo {
    my($inst,$dir,$msg)=@_;
    my($encInfo,$inst1,$initiatorKey,$responderKey);

    # 
    if(!$IKEEncryptMode){return;}

    # 
    if($inst->{'Phase'} eq 1){
	$inst1=$inst;
    }
    else{
	$inst1=IKFindScenInstFromID($inst->{'Phase1ID'});
    }
    $initiatorKey=$inst1->{'Side'} eq 'initiator' ? $inst1->{'DHPublicKey'} : $inst1->{'DHRemotePublicKey'};
    $responderKey=$inst1->{'Side'} eq 'initiator' ? $inst1->{'DHRemotePublicKey'} : $inst1->{'DHPublicKey'};
# printf("IKESetupEncInfo [%s][%s][%s]\n",$inst->{'Phase'},$inst->{'ST'},$inst->{'IV'});
    # INFO
    if($msg eq 'INFO'){
	$encInfo={'Phase'=>$inst->{'Phase'},
		  'IKEEncKey'=>$inst1->{'IKEEncKey'},
		  'PRFHashAlgo'=>$inst1->{'PRFHashAlgo'},
		  'IKEEncAlgo'=>$inst1->{'IKEEncAlgo'},
		  'CBCSize'=>IKEGetCBCLength('EncIKE',$inst1->{'IKEEncAlgo'}),
		  'IV'=>'',
		  'PH1IV'=>$inst1->{'IV'},
		  'DHInitiatorKey'=>$initiatorKey,
		  'DHResponderKey'=>$responderKey };
    }
    else{
	$encInfo={'Phase'=>$inst->{'Phase'},
		  'IKEEncKey'=>$inst1->{'IKEEncKey'},
		  'PRFHashAlgo'=>$inst1->{'PRFHashAlgo'},
		  'IKEEncAlgo'=>$inst1->{'IKEEncAlgo'},
		  'CBCSize'=>IKEGetCBCLength('EncIKE',$inst1->{'IKEEncAlgo'}),
		  'IV'=>$dir eq 'recv' ? $inst->{'IV'}:$inst->{'IVE'},
		  'PH1IV'=>$inst1->{'IV'},
		  'DHInitiatorKey'=>$initiatorKey,
		  'DHResponderKey'=>$responderKey };
	if($inst->{'ST'} eq 'PH2.complete'){
	    $encInfo->{'IV'}='';
	}
    }
    if($inst->{'ST'} eq 'PH1.complete'){
	$encInfo->{'Phase'}=2;
	$encInfo->{'IV'}='';
    }
    return $encInfo;
}
# 
#
# 
# 
# 
# 
# 
# INFO    : PH1:IV
# INFO    : PH1:IV
#  
#   p1_iv("algorithm","g^xi","g^xr",CBCsize)
#   p2_iv("algorithm","last CBC block of Phase1")
#   
sub IKEEncryptRecvFrame {
    my($idx,$encInfo,$extype,$icookie,$rcookie)=@_;
    my($cpp,$encKey,$hashAlgo,$encAlgo,$iv);

    # 
    $encKey=$encInfo->{'IKEEncKey'};
    $hashAlgo=$encInfo->{'PRFHashAlgo'} eq $IKEDoi{'TI_ATTR_HASH_ALG_SHA'}?'sha1':'md5';
    $encAlgo=$encInfo->{'IKEEncAlgo'} eq $IKEDoi{'TI_ATTR_ENC_ALG_3DES'}?'des3cbc':'descbc';

    if($icookie){$icookie='hexstr("' . $icookie . '")';}else{$icookie='any';}
    if($rcookie){$rcookie='hexstr("' . $rcookie . '")';}else{$rcookie='any';}

    if($encInfo->{'Phase'} eq 1){
	if($encInfo->{'IV'}){
	    $iv='hexstr("' . $encInfo->{'IV'} . '",' . $encInfo->{'CBCSize'} . ')';
#	    printf("<<<<<<<<<<<<<<<<<<  IV mode [IV]\n");
	}
	else{
	    $iv='p1_iv("' . $hashAlgo . '",hexstr("' . $encInfo->{'DHInitiatorKey'} . '"),hexstr("' . 
		$encInfo->{'DHResponderKey'} . '"),' . $encInfo->{'CBCSize'} . ')';
#	    printf("<<<<<<<<<<<<<<<<<<  IV mode init1\n");
	}
    }
    else{
	if($encInfo->{'IV'}){
	    $iv='hexstr("' . $encInfo->{'IV'} . '",' . $encInfo->{'CBCSize'} . ')';
#	    printf("<<<<<<<<<<<<<<<<<<  IV mode [IV]\n");
	}
	elsif($encInfo->{'PH1IV'}){
	    $iv='hexstr("' . $encInfo->{'PH1IV'} . '",' . $encInfo->{'CBCSize'} . '),';
	    $iv='p2_iv("' . $hashAlgo . '",' . $iv . $encInfo->{'CBCSize'} . ')';
#	    printf("<<<<<<<<<<<<<<<<<<  IV mode init2+[IV]\n");
	}
	else{
	    $iv='p1_iv("' . $hashAlgo . '",hexstr("' . $encInfo->{'DHInitiatorKey'} . '"),hexstr("' . 
		$encInfo->{'DHResponderKey'} . '"),' . $encInfo->{'CBCSize'} . '),';
	    $iv='p2_iv("' . $hashAlgo . '",' . $iv . $encInfo->{'CBCSize'} . ')';
#	    printf("<<<<<<<<<<<<<<<<<<  IV mode init2+init1\n");
	}
    }

    $cpp=eval "sprintf(\"$IKEEncFrameFMT\")";
#    PrintItem($cpp);
    return $cpp;
}
# 
# 
# 
# 
# 
# 
# INFO    : PH1:IV
# INFO    : PH1:IV
sub IKEEncryptSendFrame {
    my($encInfo)=@_;
    my($cpp,$iv);

    $cpp="ISAKMP_Encryption IKE_SEND_ENC {algorithm = IKE_SEND_ALGORITHM;}\n";
    if($encInfo->{'Phase'} eq 1){
	if($encInfo->{'IV'}){
	    $cpp .= sprintf("ISAKMP_Algorithm IKE_SEND_ALGORITHM {" . 
			    "crypt=ike_%s(hexstr(\"%s\", 24),hexstr(\"%s\",%s));pad=allzero();}",
			    $encInfo->{'IKEEncAlgo'} eq $IKEDoi{'TI_ATTR_ENC_ALG_3DES'}?'des3cbc':'descbc',
			    $encInfo->{'IKEEncKey'},
			    $encInfo->{'IV'},
			    $encInfo->{'CBCSize'});
	}
	else{
	    $cpp .= sprintf("ISAKMP_Algorithm IKE_SEND_ALGORITHM {" .
			    "crypt=ike_%s(hexstr(\"%s\", 24),p1_iv(\"%s\",hexstr(\"%s\"),hexstr(\"%s\"),%s));pad=allzero();}",
			    $encInfo->{'IKEEncAlgo'} eq $IKEDoi{'TI_ATTR_ENC_ALG_3DES'}?'des3cbc':'descbc',
			    $encInfo->{'IKEEncKey'},
			    $encInfo->{'PRFHashAlgo'} eq $IKEDoi{'TI_ATTR_HASH_ALG_SHA'}?'sha1':'md5',
			    $encInfo->{'DHInitiatorKey'},
			    $encInfo->{'DHResponderKey'},
			    $encInfo->{'CBCSize'});
#	    printf(">>>>>>>>>>>>>>>>>>  IV mode init1\n");
	}
    }
    else{
	if($encInfo->{'IV'}){
	    $cpp .= sprintf("ISAKMP_Algorithm IKE_SEND_ALGORITHM {" . 
			    "crypt=ike_%s(hexstr(\"%s\", 24),hexstr(\"%s\",%s));pad=allzero();}",
			    $encInfo->{'IKEEncAlgo'} eq $IKEDoi{'TI_ATTR_ENC_ALG_3DES'}?'des3cbc':'descbc',
			    $encInfo->{'IKEEncKey'},
			    $encInfo->{'IV'},
			    $encInfo->{'CBCSize'});
#	    printf(">>>>>>>>>>>>>>>>>>  IV mode [IV]\n");
	}
	elsif($encInfo->{'PH1IV'}){
	    $iv=sprintf("hexstr(\"%s\",%s)",$encInfo->{'PH1IV'},$encInfo->{'CBCSize'});
	    $cpp .= sprintf("ISAKMP_Algorithm IKE_SEND_ALGORITHM {" . 
			    "crypt=ike_%s(hexstr(\"%s\", 24),p2_iv(\"%s\",%s,%s));pad=allzero();}",
			    $encInfo->{'IKEEncAlgo'} eq $IKEDoi{'TI_ATTR_ENC_ALG_3DES'}?'des3cbc':'descbc',
			    $encInfo->{'IKEEncKey'},
			    $encInfo->{'PRFHashAlgo'} eq $IKEDoi{'TI_ATTR_HASH_ALG_SHA'}?'sha1':'md5',
			    $iv,
			    $encInfo->{'CBCSize'});
#	    printf(">>>>>>>>>>>>>>>>>>  IV mode init2+[IV]\n");
	}
	else{
	    $iv=sprintf("p1_iv(\"%s\",hexstr(\"%s\"),hexstr(\"%s\"),%s)",
			$encInfo->{'PRFHashAlgo'} eq $IKEDoi{'TI_ATTR_HASH_ALG_SHA'}?'sha1':'md5',
			$encInfo->{'DHInitiatorKey'},
			$encInfo->{'DHResponderKey'},
			$encInfo->{'CBCSize'});
	    $cpp .= sprintf("ISAKMP_Algorithm IKE_SEND_ALGORITHM {" . 
			    "crypt=ike_%s(hexstr(\"%s\", 24),p2_iv(\"%s\",%s,%s));pad=allzero();}",
			    $encInfo->{'IKEEncAlgo'} eq $IKEDoi{'TI_ATTR_ENC_ALG_3DES'}?'des3cbc':'descbc',
			    $encInfo->{'IKEEncKey'},
			    $encInfo->{'PRFHashAlgo'} eq $IKEDoi{'TI_ATTR_HASH_ALG_SHA'}?'sha1':'md5',
			    $iv,
			    $encInfo->{'CBCSize'});
#	    printf(">>>>>>>>>>>>>>>>>>  IV mode init2+init1\n");
	}

    }
    return $cpp;
}


# 
sub IKEEncryptRecvFrames {
    my($i,$cpp,$idx,$encInfo,@frames,$exit,$extype,$icookie,$rcookie);

    # 
    if(!$IKEEncryptMode){return;}

    # 
    $idx=1;
    for $i (0..$#IKScenarioINST){
	if(grep{$_ eq $IKScenarioINST[$i]->{'ST'}} @IKEEncFrameRecvState){
	    $icookie=$IKScenarioINST[$i]->{'InitiatorCookie'};
	    $rcookie=$IKScenarioINST[$i]->{'ResponderCookie'};
	    $extype=$IKEEncFrameExchangeType{$IKScenarioINST[$i]->{'ST'}};
	    $encInfo=IKESetupEncInfo($IKScenarioINST[$i],'recv');
	    $cpp .= IKEEncryptRecvFrame($idx,$encInfo,$extype,$icookie,$rcookie);
	    push(@frames,$IKERcvFRAMENAME . '_ENC' . $idx);
	    $idx++;
	    # 2006/04/05 ExchangeType
	    if($IKScenarioINST[$i]->{'ST'} eq 'PH1.complete'){
		$extype=$IKEDoi{'TI_ETYPE_QUICK'};
		$cpp .= IKEEncryptRecvFrame($idx,$encInfo,$extype,$icookie,$rcookie);
		push(@frames,$IKERcvFRAMENAME . '_ENC' . $idx);
		$idx++;
	    }
	    if($IKScenarioINST[$i]->{'ST'} eq 'PH2.QK.MSG2.recv'){$exit=1;}
	}
    }

    # 
    if($cpp){
	# 
	IKEWritePktDef($cpp);
	# VCPP
	VCppApply('','','','force');
#	PrintVal(\@frames);
	return \@frames;
    }
    return;
}
sub IKEEncode {
    my($srcmac,$srcip,$dstmac,$dstip,$frame,$enc)=@_;
    if(!$srcmac){$srcmac='tnether()';}
    if(!$dstmac){$dstmac='nutether()';}
    my($cpp);

    # Ether
    $cpp=IKEEncodeUDP($srcmac,$srcip,$dstmac,$dstip,$frame,$enc);
    # Hdr_ISAKMP
    $cpp.=IKEncodeVcpp($frame,0);
    # ISAKMP_Encryption
    if($enc){
	$cpp.=IKEEncryptSendFrame($enc);
    }
    # 

    IKEWritePktDef($cpp);
#    PrintItem($cpp);
    # VCPP
    VCppApply('','','','force');
}
sub IKEEncodeUDP {
    my($srcmac,$srcip,$dstmac,$dstip,$frame,$enc)=@_;
    my($idx,$payload,$i,$tag,$index);
    $idx=$#{$frame->{'++'}};
    if($enc){
	$payload .= sprintf("\nencrypt=IKE_SEND_ENC;");
    }
    for $i (0..$idx){
	($tag,$index)=IKPKTIndexTag($frame->{'++'}->[$i]);
	if($tag eq 'HD'){next;}
	$payload .= sprintf("\npayload=IKE_SEND_%s%s;",$tag,$index eq 0?'':$index);
    }
    if($srcmac =~ /^[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+$/){
	$srcmac='ether("' . $srcmac . '")';
    }
    if($dstmac =~ /^[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+:[0-9a-fA-F]+$/){
	$dstmac='ether("' . $dstmac . '")';
    }
    return sprintf($PKT_FMT_UDP . "\n",$srcmac,$dstmac,$srcip,$dstip,500,500,$payload),

}

sub IKEEncodeISAKMP {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_ISAKMP . "\n",$frame->{InitiatorCookie},$frame->{ResponderCookie},$frame->{NextPayload},
		   $frame->{ExchangeType},$frame->{CFlag},$frame->{EFlag},$frame->{MessageID});
}
sub IKEEncodeSA {
    my($frame,$index)=@_;
    return $PKT_FMT_SA;
}
sub IKEEncodePR {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_PR . "\n",$frame->{ProtocolID},$frame->{ProposalNumber},
		   $frame->{SPI}?sprintf("%08x",$frame->{SPI}):'');
}
sub IKEEncodeTR {
    my($frame,$index,$inst)=@_;
    my($idx,$cpp,$i);
    $idx=$#{$frame->{'++'}};
    for $i (0..$idx){
	$cpp.=sprintf("\nattribute=ATT%s;",$i);
    }
    return sprintf($PKT_FMT_TR . "\n",$frame->{TransformID},$frame->{TransformNumber},$cpp);
}
sub IKEEncodeTV {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_TV . "\n",$index,$frame->{Type},$frame->{Value});
}
sub IKEEncodeTLV {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_TLV . "\n",$index,$frame->{Type},$frame->{Value},$frame->{Length});
}
sub IKEEncodeKE {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_KE . "\n",$frame->{KeyExchangeData});
}
sub IKEEncodeIDIPv6 {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_IDIPv6 . "\n",$index?$index:'',$frame->{IDtype},$frame->{ProtocolID},$frame->{Port},$frame->{ID});
}
sub IKEEncodeIDIPv6Subnet {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_IDIPv6Subnet . "\n",$index?$index:'',$frame->{IDtype},$frame->{ProtocolID},$frame->{Port},
		   $frame->{ID1},$frame->{ID2});
}
sub IKEEncodeIDIPv6Range {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_IDIPv6Range . "\n",$index?$index:'',$frame->{IDtype},$frame->{ProtocolID},$frame->{Port},
		   $frame->{ID1},$frame->{ID2});
}
sub IKEEncodeIDFQDN {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_IDFQDN . "\n",$index?$index:'',$frame->{IDtype},$frame->{ProtocolID},$frame->{Port},$frame->{ID});
}
sub IKEEncodeHA {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_HA . "\n",$frame->{HashData});
}
sub IKEEncodeNC {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_NC . "\n",$frame->{NonceData});
}
sub IKEEncodeNO {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_NO . "\n",$frame->{'ProtocolID'},$frame->{'SPIsize'},$frame->{'NotifyMessageType'},$frame->{'SPI'});
}
sub IKEEncodeDL {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_DL . "\n",$frame->{'ProtocolID'},$frame->{'SPIsize'},$frame->{'SPI'});
}
sub IKEEncodeVI {
    my($frame,$index)=@_;
    return sprintf($PKT_FMT_VI . "\n",$frame->{VID});
}
$IKEEncFrameFMT=
'FEM_udp6(IKE_RECV_ENC$idx,IKE_EH_NUTtoTN,{
		Version			= IKE_V6HD_VERSION;
		TrafficClass		= IKE_V6HD_TRAFFICCLASS;
		FlowLabel		= IKE_V6HD_FLOWLABEL;
		PayloadLength		= IKE_V6HD_PAYLOADLENGTH;
		NextHeader		= IKE_V6HD_NEXTHEADER;
		HopLimit		= any;
		SourceAddress		= any;
		DestinationAddress	= any;
	},
	{
		SourcePort		= IKE_UDP_SRC_PORT;
		DestinationPort		= IKE_UDP_DST_PORT;
	},
	{
		header	= _HDR_UDP_NAME(IKE_RECV_ENC$idx);
		payload	= IKE_RECV_ISAKMP_ENC$idx;
	}
)
Udp_ISAKMP IKE_RECV_ISAKMP_ENC$idx {
	header	= IKE_RECV_ISAKMP_HDR_ENC$idx;
	encrypt = IKE_RECV_ENCRYPT$idx;
	payload	= stop;
}
Hdr_ISAKMP IKE_RECV_ISAKMP_HDR_ENC$idx {
	InitiatorCookie	= $icookie;
	ResponderCookie	= $rcookie;
	MjVer		= any;
	MnVer		= any;
	ExchangeType	= $extype;
	EFlag		= 1;
	CFlag		= any;
	AFlag		= any;
	MessageID	= any;
	NextPayload	= any;
}
ISAKMP_Encryption IKE_RECV_ENCRYPT$idx {algorithm=IKE_RECV_ALGORITHM$idx;}
ISAKMP_Algorithm IKE_RECV_ALGORITHM$idx {
	crypt=ike_$encAlgo(hexstr(\\"$encKey\\", 24),
        $iv);
	pad=allzero();
}';

#============================================
# 
#============================================
# 
@IKEPacketHexMap = (
 {'##'=>'Udp_ISAKMP','#Name#'=>'IK','sub'=>
  {'NM'=>'IK','start'=>'Hdr_ISAKMP',
   'pattern'=> ['Pld_ISAKMP_SA_IPsec_IDonly','Pld_ISAKMP_KE','Pld_ISAKMP_NONCE',
		'Pld_ISAKMP_ID_FQDN','Pld_ISAKMP_ID_USER_FQDN',
		'Pld_ISAKMP_ID_IPV6_ADDR','Pld_ISAKMP_ID_IPV6_ADDR_SUBNET','Pld_ISAKMP_ID_IPV6_ADDR_RANGE',
		'Pld_ISAKMP_HASH','Pld_ISAKMP_VID','Pld_ISAKMP_N_IPsec_ANY','Pld_ISAKMP_D']},
  },
 {'##'=>'Hdr_ISAKMP','#Name#'=>'HD',
  'field'=>
     [
      {'NM'=>'InitiatorCookie','SZ'=>8,'TY'=>'hex',  'MK'=>''},
      {'NM'=>'ResponderCookie','SZ'=>8,'TY'=>'hex',  'MK'=>''},
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'MjVer',          'SZ'=>1,'TY'=>'uchar','MK'=>4},
      {'NM'=>'MnVer',          'SZ'=>0,'TY'=>'',     'MK'=>4},
      {'NM'=>'ExchangeType',   'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'EFlag',          'SZ'=>1,'TY'=>'uchar','MK'=>1},
      {'NM'=>'CFlag',          'SZ'=>0,'TY'=>'',     'MK'=>1},
      {'NM'=>'AFlag',          'SZ'=>0,'TY'=>'',     'MK'=>1},
      {'NM'=>'Reserved',       'SZ'=>0,'TY'=>'',     'MK'=>5},
      {'NM'=>'MessageID',      'SZ'=>4,'TY'=>'long', 'MK'=>''},
      {'NM'=>'Length',         'SZ'=>4,'TY'=>'long', 'MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_SA_IPsec_IDonly','#Name#'=>'SA',
#  'sub'=> {'start'=>'Pld_ISAKMP_P_ISAKMP','pattern'=> ['Pld_ISAKMP_P_ISAKMP','Pld_ISAKMP_P_IPsec_ESP']},
  'sub'=> {'NM'=>'PR','pattern'=> ['Pld_ISAKMP_P_ISAKMP','Pld_ISAKMP_P_IPsec_ESP']},
  'field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>'','AC'=>'$SZ=$F->{PayloadLength}-12'},
      {'NM'=>'DOI',            'SZ'=>4,'TY'=>'long', 'MK'=>''},
      {'NM'=>'Situation',      'SZ'=>4,'TY'=>'long', 'MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_P_ISAKMP','#Name#'=>'PR','sub'=> {'start'=>'Pld_ISAKMP_T','pattern'=> ['Pld_ISAKMP_T']},
  'field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'ProposalNumber', 'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'ProtocolID',     'SZ'=>1,'TY'=>'uchar','MK'=>'','PT'=>1},
      {'NM'=>'SPIsize',        'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$SZ=$F->{PayloadLength}-$F->{SPIsize}-8'},
      {'NM'=>'NumOfTransforms','SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'SPI',            'SZ'=>\'$F->{SPIsize}','TY'=>'long'},
      ]
  },
 {'##'=>'Pld_ISAKMP_P_IPsec_ESP','#Name#'=>'PR','sub'=> {'start'=>'Pld_ISAKMP_T','pattern'=> ['Pld_ISAKMP_T']},
  'field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'ProposalNumber', 'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'ProtocolID',     'SZ'=>1,'TY'=>'uchar','MK'=>'','PT'=>3},
      {'NM'=>'SPIsize',        'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$SZ=$F->{PayloadLength}-$F->{SPIsize}-8'},
      {'NM'=>'NumOfTransforms','SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'SPI',            'SZ'=>\'$F->{SPIsize}','TY'=>'long'},
      ]
  },
 {'##'=>'Pld_ISAKMP_T','#Name#'=>'TR','sub'=>{'NM'=>'ATT','pattern'=>['Attr_ISAKMP_TLV','Attr_ISAKMP_TV']},
  'field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>'','AC'=>'$SZ=$F->{PayloadLength}-8'},
      {'NM'=>'TransformNumber','SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'TransformID',    'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'Reserved2',      'SZ'=>2,'TY'=>'short','MK'=>''},
      ]
  },
 {'##'=>'Attr_ISAKMP_TLV','#Name#'=>'ATT','field'=>
     [
      {'NM'=>'AF',             'SZ'=>2,'TY'=>'short','MK'=>1,  'PT'=>0},
      {'NM'=>'Type',           'SZ'=>0,'TY'=>'uchar','MK'=>15},
      {'NM'=>'Length',         'SZ'=>2,'TY'=>'short','MK'=>''},
#      {'NM'=>'Value',          'SZ'=>\'$F->{Length}','TY'=>'byte',  'MK'=>''},
      {'NM'=>'Value',          'SZ'=>\'$F->{Length}','TY'=>'long',  'MK'=>''},
      ]
  },
 {'##'=>'Attr_ISAKMP_TV','#Name#'=>'ATT','field'=>
     [
      {'NM'=>'AF',             'SZ'=>2,'TY'=>'short','MK'=>1,  'PT'=>1},
      {'NM'=>'Type',           'SZ'=>0,'TY'=>'uchar','MK'=>15},
      {'NM'=>'Value',          'SZ'=>2,'TY'=>'short','MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_ID_FQDN','#Name#'=>'ID','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'IDtype',         'SZ'=>1,'TY'=>'uchar','MK'=>'','PT'=>2},
      {'NM'=>'ProtocolID',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'Port',           'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'ID',             'SZ'=>{'Decode'=>\'$F->{PayloadLength}-8','Encode'=>\'length($val)'},'TY'=>'byte','MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_ID_USER_FQDN','#Name#'=>'ID','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'IDtype',         'SZ'=>1,'TY'=>'uchar','MK'=>'','PT'=>3},
      {'NM'=>'ProtocolID',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'Port',           'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'ID',             'SZ'=>{'Decode'=>\'$F->{PayloadLength}-8','Encode'=>\'length($val)'},'TY'=>'byte','MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_ID_IPV6_ADDR','#Name#'=>'ID','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'IDtype',         'SZ'=>1,'TY'=>'uchar','MK'=>'','PT'=>5},
      {'NM'=>'ProtocolID',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'Port',           'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'ID',             'SZ'=>16,'TY'=>'ipv6','MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_ID_IPV6_ADDR_SUBNET','#Name#'=>'ID','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'IDtype',         'SZ'=>1,'TY'=>'uchar','MK'=>'','PT'=>6},
      {'NM'=>'ProtocolID',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'Port',           'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'ID1',            'SZ'=>16,'TY'=>'ipv6','MK'=>''},
      {'NM'=>'ID2',            'SZ'=>16,'TY'=>'ipv6','MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_ID_IPV6_ADDR_RANGE','#Name#'=>'ID','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'IDtype',         'SZ'=>1,'TY'=>'uchar','MK'=>'','PT'=>8},
      {'NM'=>'ProtocolID',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'Port',           'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'ID1',            'SZ'=>16,'TY'=>'ipv6','MK'=>''},
      {'NM'=>'ID2',            'SZ'=>16,'TY'=>'ipv6','MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_HASH','#Name#'=>'HA','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'HashData',       'SZ'=>\'$F->{PayloadLength}-4','TY'=>'hex','MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_KE','#Name#'=>'KE','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'KeyExchangeData','SZ'=>\'$F->{PayloadLength}-4','TY'=>'hex','MK'=>''},
      ]
  },

 {'##'=>'Pld_ISAKMP_NONCE','#Name#'=>'NC','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'NonceData',      'SZ'=>\'$F->{PayloadLength}-4','TY'=>'hex','MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_N_IPsec_ANY','#Name#'=>'NO','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'DOI',            'SZ'=>4,'TY'=>'long', 'MK'=>''},
      {'NM'=>'ProtocolID',     'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'SPIsize',        'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'NotifyMessageType','SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'SPI',            'SZ'=>\'$F->{SPIsize}','TY'=>'hex','MK'=>''},
      {'NM'=>'NotificationData','SZ'=>\'$F->{PayloadLength}-$F->{SPIsize}-12','TY'=>'hex', 'MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_D','#Name#'=>'DL','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'DOI',            'SZ'=>4,'TY'=>'long', 'MK'=>''},
      {'NM'=>'ProtocolID',     'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'SPIsize',        'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'NumberOfSPI',    'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'SPI',            'SZ'=>\'$F->{SPIsize}','TY'=>'hex','MK'=>''},
      ]
  },
 {'##'=>'Pld_ISAKMP_VID','#Name#'=>'VI','field'=>
     [
      {'NM'=>'NextPayload',    'SZ'=>1,'TY'=>'uchar','MK'=>'','AC'=>'$NX=IKEPayloadName($val)'},
      {'NM'=>'Reserved1',      'SZ'=>1,'TY'=>'uchar','MK'=>''},
      {'NM'=>'PayloadLength',  'SZ'=>2,'TY'=>'short','MK'=>''},
      {'NM'=>'VID',            'SZ'=>\'$F->{PayloadLength}-4','TY'=>'hex','MK'=>''},
      ]
 },
);

%PayloadNumToName =
 (  1 => 'Pld_ISAKMP_SA_IPsec_IDonly',
    2 => 'Pld_ISAKMP_P_ISAKMP',
    3 => 'Pld_ISAKMP_T',
    4 => 'Pld_ISAKMP_KE',
    5 => '',                      # 
    6 => 'Pld_ISAKMP_CERT',
    7 => 'Pld_ISAKMP_CR',
    8 => 'Pld_ISAKMP_HASH',
    9 => 'Pld_ISAKMP_SIG',
   10  => 'Pld_ISAKMP_NONCE',
   11 => 'Pld_ISAKMP_N_IPsec_ANY',
   12 => 'Pld_ISAKMP_D',
   13 => 'Pld_ISAKMP_VID');

%PayloadNameToNum =
 (  'Pld_ISAKMP_SA_IPsec_IDonly' =>1,
    'Pld_ISAKMP_P_ISAKMP'        =>2,
    'Pld_ISAKMP_P_IPsec_AH'      =>2,
    'Pld_ISAKMP_P_IPsec_ESP'     =>2,
    'Pld_ISAKMP_T'               =>3,
    'Pld_ISAKMP_KE'              =>4,
    'Pld_ISAKMP_ID_FQDN'         =>5,
    'Pld_ISAKMP_ID_USER_FQDN'    =>5,
    'Pld_ISAKMP_ID_IPV6_ADDR'    =>5,
    'Pld_ISAKMP_ID_IPV6_ADDR_SUBNET'=>5,
    'Pld_ISAKMP_ID_IPV6_ADDR_RANGE'=>5,
    'Pld_ISAKMP_CERT'            =>6,
    'Pld_ISAKMP_CR'              =>7,
    'Pld_ISAKMP_HASH'            =>8,
    'Pld_ISAKMP_SIG'             =>9,
    'Pld_ISAKMP_NONCE'           =>10,
    'Pld_ISAKMP_N_IPsec_ANY'               =>11,
    'Pld_ISAKMP_D'               =>12,
    'Pld_ISAKMP_VID'             =>13,);

sub IKEPayloadName ($){
    my($val)=@_;
    MsgPrint('DBG',"Payload[$val]->$PayloadNumToName{$val}\n");
    return $PayloadNumToName{$val};
}
sub IKEPayloadID ($){
    my($val)=@_;
    return $PayloadNameToNum{$val};
}

#============================================
# 
#============================================
%IKE_MESSAGE = (
    'NG:AddressMismatch'       => 'NG:Address invallid',
    'NG:ProfileMismatch'       => 'NG:Profile mismatch',
    'NG:NoProfile'             => 'NG:Profile not found',
    'NG:ProfileDisable'        => 'NG:Profile disable',
    'NG:PayloadInvalid'        => 'NG:Payload invalid',
    'NG:IDInvalid'             => 'NG:ID playload invallid',
    'NG:KEInvalid'             => 'NG:KE playload invallid',
    'NG:NOInvalid'             => 'NG:Notify playload invallid',
    'NG:AuthInvalid'           => 'NG:Authenticator invalid',
    'NG:NoPhase1'              => 'NG:Phase1 handle not found',
    'NG:NoMatchProposal'       => 'NG:Proposal not match',
    'NG:NotSupportPFS'         => 'NG:PFS not yet suppored',
    'Complete'                 => 'Complete',
    'Expired'                  => 'Expired',
		);
%IKE_SEQ_ARROW_STR = (
    'TN1toNUT1'                => '|     |     |----->|     |     |',
    'TN1toNUT2'                => '|     |     |------|---->|     |',
    'TN1toNUT3'                => '|     |     |------|-----|---->|',
    'TN2toNUT1'                => '|     |-----|----->|     |     |',
    'TN2toNUT2'                => '|     |-----|------|---->|     |',
    'TN2toNUT3'                => '|     |-----|------|-----|---->|',
    'TN3toNUT1'                => '|-----|-----|----->|     |     |',
    'TN3toNUT2'                => '|-----|-----|------|---->|     |',
    'TN3toNUT3'                => '|-----|-----|------|-----|---->|',
    'NUT1toTN1'                => '|     |     |<-----|     |     |',
    'NUT1toTN2'                => '|     |<----|------|     |     |',
    'NUT1toTN3'                => '|<----|-----|------|     |     |',
    'NUT2toTN1'                => '|     |     |<-----|-----|     |',
    'NUT2toTN2'                => '|     |<----|------|-----|     |',
    'NUT2toTN3'                => '|<----|-----|------|-----|     |',
    'NUT3toTN1'                => '|     |     |<-----|-----|-----|',
    'NUT3toTN2'                => '|     |<----|------|-----|-----|',
    'NUT3toTN3'                => '|<----|-----|------|-----|-----|',
    'Expired'                  => '********************************',
);
sub IKEPktComment {
    my($msgID)=@_;
    IKAddCmtCapture($IKE_MESSAGE{$msgID}?$IKE_MESSAGE{$msgID}:$msgID);
}
sub IKSequenceLog {
    my($i,$startTime,$diffTime,$name,$comment,$msg,$frames,$dir,$pkt,$tahino);
    
    # 
    #   
    $frames=IKArrangeCapture();

    vLogHTML('</TD></TR><TR><TD>IKE Sequence</TD><TD><A NAME="SequenceSummary"></A>');
    vLogHTML("<pre>");
    vLogHTML("                     TN3   TN2   TN1    NUT1  NUT2  NUT3\n");
    vLogHTML(" No  time             |     |     |      |     |     |  \n");

    for($i=0;$i<=$#$frames;$i++){
	# 
	if($i eq 0){$startTime = $frames->[$i]->{Time};}

	# 
	$diffTime=$frames->[$i]->{Time}-$startTime;

	if($frames->[$i]->{'Frame'} eq 'Expired'){
	    $pkt=$frames->[$i]->{'Frame'};
	    $name=sprintf("%s(%s)",$frames->[$i]->{'PktName'},$frames->[$i]->{'SequenceNo'});
	    $tahino=0;
	}
	else{
	    # 
	    $dir=$frames->[$i]->{'Direction'};
	    # 
	    if($dir eq 'in'){
		$pkt=sprintf("NUT%stoTN%s",$frames->[$i]->{'NUTNode'}+1,$frames->[$i]->{'TNNode'}+1);
	    }
	    else{
		$pkt=sprintf("TN%stoNUT%s",$frames->[$i]->{'TNNode'}+1,$frames->[$i]->{'NUTNode'}+1);
	    }
	    # 
	    $name=sprintf("%s-%s(%s)",
			  $frames->[$i]->{'PktName'},$frames->[$i]->{'MsgnoInSequence'},$frames->[$i]->{'SequenceNo'});
	    # TAHI
	    $tahino=$dir eq 'out' ? $frames->[$i]->{'Pkt'}->{'vSendPKT'}:$frames->[$i]->{'Pkt'}->{'vRecvPKT'};
	}
	# 
	$comment=$frames->[$i]->{'Comment'};

	# 
#	$msg = sprintf("[<A HREF=\"#Judge%02d\">%02d</A>:%5.2f] %-10.10s %s %s\n",
#		       $i+1,$i+1,$diffTime,$name,$IKE_SEQ_ARROW_STR{$pkt},$comment);
	$msg = sprintf("[<A HREF=\"#%s%d\">%02d</A>:%5.2f] %-10.10s %s %s\n",
		       $dir eq 'out'?'vSendPKT':'vRecvPKT',$tahino-1,
		       $i+1,$diffTime,$name,$IKE_SEQ_ARROW_STR{$pkt},$comment);
	vLogHTML($msg);
    }
    vLogHTML('</pre>');
}

# 
sub IKJudgmentLog {
    my($i,$index,$no,$msg,$j,@sortMsg);

    $msg=[];
    for $i (0..$#IK_HTMLLog){
	if($index ne $IK_HTMLLog[$i]->{'Index'}){
	    if(-1<$#$msg){
		# 
		@sortMsg = sort {
		    my($od1,$od2);
		    $od1=int($IKERuleCategory{$a->{'Category'}}->{'OD:'});
		    $od2=int($IKERuleCategory{$b->{'Category'}}->{'OD:'});
		    if( $od1 < $od2 ){return -1;}
		    if( $od1 > $od2 ){return 1;}
		    return 0;} @$msg;
		for $j (0..$#sortMsg){
		    vLogHTML($sortMsg[$j]->{'Msg'});
		}
		$msg=[];
	    }
	    # 
	    $no=IKEGetFrameNoFromTimestamp($IK_HTMLLog[$i]->{'Index'});
	    vLogHTML(sprintf('<A NAME="Judge%02d"></A><TR><TD> IKE Judge%02d </TD><TD>',$no+1,$no+1));
	    $index=$IK_HTMLLog[$i]->{'Index'};
	}
	push(@$msg,$IK_HTMLLog[$i]);
    }
    if(-1<$#$msg){
	# 
	@sortMsg = sort {
	    my($od1,$od2);
	    $od1=int($IKERuleCategory{$a->{'Category'}}->{'OD:'});
	    $od2=int($IKERuleCategory{$b->{'Category'}}->{'OD:'});
	    if( $od1 < $od2 ){return -1;}
	    if( $od1 > $od2 ){return 1;}
	    return 0;} @$msg;
	for $j (0..$#sortMsg){
	    vLogHTML($sortMsg[$j]->{'Msg'});
	}
	$msg=[];
    }
    undef(@IK_HTMLLog);
}

sub IKESetLogLevel {
    my($loglevel)=@_;
    my(@level,@debug,$i);
    if(!$loglevel){return;}
    if(!ref($loglevel)){ $loglevel=[$loglevel]; }
    for $i (0..$#$loglevel){
	if($loglevel->[$i] =~ /ERR/i){push(@level,'ERR');push(@debug,'ERR');}
	if($loglevel->[$i] =~ /WAR/i){push(@level,'WAR');push(@debug,'WAR');}
	if($loglevel->[$i] =~ /INF1/i){push(@level,'INF1');}
	if($loglevel->[$i] =~ /INF2/i){push(@level,'INF2');}
	if($loglevel->[$i] =~ /^DBG$/i){push(@debug,'DBG');}
	if($loglevel->[$i] =~ /^DBG[1-9]/i){push(@debug,$loglevel->[$i]);}
	if($loglevel->[$i] =~ /SEQ/i) {push(@level,'SEQ');}
	if($loglevel->[$i] =~ /JDG/i) {push(@level,'JDG');}
    }
    @IKLogLevel=@level;
    for $i (0..$#debug){$IKDBGLogLevel{$debug[$i]}++;}
}
sub IKEIsLogLevel {
    my($loglevel)=@_;
    return grep{$_ eq $loglevel} @IKLogLevel;
}
#============================================
# 
#============================================
sub IKEPseudoHandle {
    my($prof)=@_;
    my($handle);
    IKERegsitSAProf($prof);
    $handle=IKCreateScenarioInst("PH1.AG.Initiator");
    if($prof->{'PHASE'} eq 1){
	$handle->{'Phase'}=1;
	$handle->{'SaID1'}=$prof->{'ID'};
    }
    else{
	$handle->{'Phase'}=2;
	$handle->{'SaID2'}=$prof->{'ID'};
    }
    IKAddScenInst($handle);
    return $handle;
}

1



