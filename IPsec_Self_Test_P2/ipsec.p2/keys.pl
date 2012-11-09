#!/usr/bin/perl
#
# IPsec Key Definition
#
# 
######################################################################

#----- Encryption Key
$E_3descbc_in_key = 'ipv6readylogo3descbcin01';	# Key for 3DES-CBC Inbound
$E_3descbc_out_key = 'ipv6readylogo3descbcout1';# Key for 3DES-CBC Outbound

#----- FOR HOST2
$E_3descbc_in_key_2 = 'ipv6readylogo3descbcin02';  # Key for 3DES-CBC Inbound
$E_3descbc_out_key_2 = 'ipv6readylogo3descbcout2'; # Key for 3DES-CBC Outbound

$E_aescbc_in_key = 'ipv6readaescin01';		# Key for AES-CBC Inbound
$E_aescbc_out_key = 'ipv6readaescout1';		# Key for AES-CBC Outbound

$E_descbc_in_key = 'idesin01';			# Key for DES-CBC Inbound
$E_descbc_out_key = 'idesout1';			# Key for DES-CBC Outbound

$E_null_in_key = '';			# Key for NULL Inbound
$E_null_out_key = '';			# Key for NULL Outbound

#----- Authentication Key
$A_hmacsha1_in_key = 'ipv6readylogsha1in01';	# Key for HMAC-SHA1 Inbound
$A_hmacsha1_out_key = 'ipv6readylogsha1out1';	# Key for HMAC-SHA1 Outbound

#----- FOR HOST2
$A_hmacsha1_in_key_2 = 'ipv6readylogsha1in02';	# Key for HMAC-SHA1 Inbound
$A_hmacsha1_out_key_2 = 'ipv6readylogsha1out2';	# Key for HMAC-SHA1 Outbound

$A_aesxcbc_in_key = 'ipv6readaesxin01';		# Key for AES-XCBC Inbound
$A_aesxcbc_out_key = 'ipv6readaesxout1';	# Key for AES-XCBC Outbound

$A_hmacmd5_in_key = 'ipv6readymd5in01';		# Key for MD5 Inbound
$A_hmacmd5_out_key = 'ipv6readymd5out1';	# Key for MD5 Outbound

$A_null_in_key = '';			# Key for NULL Inbound
$A_null_out_key = '';			# Key for NULL Outbound

$A_hmacsha2256_in_key = 'ipv6readylogoph2ipsecsha2256in01';	# Key for HMAC-SHA2-256 Inbound
$A_hmacsha2256_out_key = 'ipv6readylogoph2ipsecsha2256out1';	# Key for HMAC-SHA2-256 Outbound

$E_aesctr_in_key	= 'ipv6readylogaescin01';
$E_aesctr_out_key	= 'ipv6readylogaescout1';

$E_camelliacbc_in_key = 'ipvcamelliacin01';	# Key for CAMELLIA-CBC Inbound
$E_camelliacbc_out_key = 'ipvcamelliacout1';	# Key for CAMELLIA-CBC Outbound



#
# for passive node
#

$E_3descbc_out_key_3	= 'ipv6readylogo3descbcout3';
$A_hmacsha1_out_key_3	= 'ipv6readylogsha1out3';

$E_3descbc_in_key_4	= 'ipv6readylogo3descbcin04';
$A_hmacsha1_in_key_4	= 'ipv6readylogsha1in04';



$dummy = 1;

###end

