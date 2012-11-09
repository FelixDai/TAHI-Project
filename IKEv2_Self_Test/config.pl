#!/usr/bin/perl
#
# Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009
# Yokogawa Electric Corporation.
# All rights reserved.
# 
# Redistribution and use of this software in source and binary
# forms, with or without modification, are permitted provided that
# the following conditions and disclaimer are agreed and accepted
# by the user:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with
#    the distribution.
# 
# 3. Neither the names of the copyrighters, the name of the project
#    which is related to this software (hereinafter referred to as
#    "project") nor the names of the contributors may be used to
#    endorse or promote products derived from this software without
#    specific prior written permission.
# 
# 4. No merchantable use may be permitted without prior written
#    notification to the copyrighters.
# 
# 5. The copyrighters, the project and the contributors may prohibit
#    the use of this software at any time.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING
# BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE
# COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# $Id: config.pl,v 1.24 2010/07/22 13:33:59 doo Exp $
#
################################################################


# Link A:
#     Common Topology for End-Node: End-Node vs. End-Node
#     Common Topology for End-Node: End-Node vs. SGW
#     Common Topology for SGW: SGW vs. SGW
#     Common Topology for SGW: SGW vs. End-Node
$ikev2_prefixA	= '2001:0db8:0001:0001';



# Link B:
#     Common Topology for SGW: SGW vs. SGW
#     Common Topology for SGW: SGW vs. End-Node
$ikev2_prefixB	= '2001:0db8:0001:0002';



# Link X:
#     Common Topology for End-Node: End-Node vs. End-Node
#     Common Topology for End-Node: End-Node vs. SGW
#     Common Topology for SGW: SGW vs. SGW
#     Common Topology for SGW: SGW vs. End-Node
$ikev2_prefixX	= '2001:0db8:000f:0001';



# Link Y:
#     Common Topology for End-Node: End-Node vs. SGW
#     Common Topology for SGW: SGW vs. SGW
$ikev2_prefixY	= '2001:0db8:000f:0002';



# Link A: Common Topology for End-Node: End-Node vs. End-Node
# Link A: Common Topology for End-Node: End-Node vs. SGW
# Link A: Common Topology for SGW: SGW vs. SGW
# Link A: Common Topology for SGW: SGW vs. End-Node
#
# This value is used to make global address connected to Link A by
# $ikev2_prefixA + $ikev2_interface_id_nut_link0
# (ex. $ikev2_prefixA is '2001:0db8:0001:0001' and
#      $ikev2_interface_id_nut_link0 is '::1',
#      The generated global address '2001:0db8:0001:0001::1'
$ikev2_interface_id_nut_link0	= '::1';



# Link B: Common Topology for SGW: SGW vs. SGW
# Link B: Common Topology for SGW: SGW vs. End-Node
#
# This value is used to make global address connected to Link B by
# $ikev2_prefixB + $ikev2_interface_id_nut_link1
# (ex. $ikev2_prefixB is '2001:0db8:0001:0002' and
#      $ikev2_interface_id_nut_link1 is '::1',
#      The generated global address '2001:0db8:0001:0002::1'
$ikev2_interface_id_nut_link1	= '::1';



# Link A: Common Topology for End-Node: End-Node vs. End-Node
# Link A: Common Topology for End-Node: End-Node vs. SGW
# Link B: Common Topology for SGW: SGW vs. SGW
# Link B: Common Topology for SGW: SGW vs. End-Node
$ikev2_link_local_addr_router_link0	= 'fe80::f';



$ikev2_pre_shared_key_tn	= 'IKETEST12345678!';
$ikev2_pre_shared_key_nut	= 'IKETEST12345678!';


# [sec]
$ikev2_nut_ike_sa_lifetime = '64';
# [sec]
$ikev2_nut_child_sa_lifetime = '128';
#
$ikev2_nut_ike_sa_init_req_retrans_timer = '16';
#
$ikev2_nut_ike_auth_req_retrans_timer = '16';
#
$ikev2_nut_create_child_sa_req_retrans_timer = '16';
#
$ikev2_nut_informational_req_retrans_timer = '16';
#
$ikev2_nut_liveness_check_timer = '32';
#
$ikev2_nut_num_of_half_opens_cookie = '32';

#
$ikev2_nut_num_of_retransmissions = '16';

#
# Advanced Function Switch
#

#   $advanced_support_initial_contact:
#     If NUT supports the function to close connections at receiving 
#     INITIAL_CONTACT, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_initial_contact	= '0';

#   $advanced_support_cookie:
#     If NUT supports the function to enable COOKIE, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_cookie		= '0';

#   $advanced_alg_nego_ike_sa:
#     If NUT supports advanced algorithms for IKE_SA,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_alg_nego_ike_sa		= '0';

#   $advanced_alg_nego_child_sa:
#     If NUT supports advanced algorithms for CHILD_SA,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_alg_nego_child_sa		= '0';

#   $advanced_support_encr_aes_cbc:
#     If NUT supports ENCR_AES_CBC, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_encr_aes_cbc		= '0';

#   $advanced_support_encr_aes_ctr:
#     If NUT supports ENCR_AES_CTR, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_encr_aes_ctr		= '0';

#   $advanced_support_encr_null:
#     If NUT supports ENCR_NULL, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_encr_null		= '0';

#   $advanced_support_prf_aes128_cbc:
#     If NUT supports PRF_AES128_XCBC, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_prf_aes128_cbc	= '0';

#   $advanced_support_auth_aes_xcbc_96:
#     If NUT supports AUTH_AES_XCBC_96, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_auth_aes_xcbc_96	= '0';

#   $advanced_support_auth_none:
#     If NUT supports NONE for Integrity Algorithm, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_auth_none		= '0';

#   $advanced_support_dh_group14:
#     If NUT supports Diffie-Hellman group 14, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_dh_group14		= '0';

#   $advanced_support_esn:
#     If NUT supports ESN, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_esn			= '0';

#   $advanced_support_creating_new_child_sa:
#     If NUT supports the function to create new CHILD_SA, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_creating_new_child_sa	= '0';

#   $advanced_multiple_transform_initial_ike_sa:
#     If NUT supports IKE_SA_INIT exchange with multiple Transform Substructure,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_multiple_transform_initial_ike_sa	= '0';

#   $advanced_multiple_proposal_initial_ike_sa:
#     If NUT supports IKE_SA_INIT exchange with multiple Proposal Substructure,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_multiple_proposal_initial_ike_sa	= '0';

#   $advanced_multiple_transform_initial_child_sa:
#     If NUT supports IKE_AUTH exchange with multiple Transform Substructure,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_multiple_transform_initial_child_sa	= '0';

#   $advanced_multiple_proposal_initial_child_sa:
#     If NUT supports IKE_AUTH exchange with multiple Proposal Substructure,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_multiple_proposal_initial_child_sa	= '0';

#   $advanced_multiple_transform_rekey_ike_sa:
#     If NUT supports CREATE_CHILD_SA exchnage with multiple Transform
#     Substructure for IKE_SA, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_multiple_transform_rekey_ike_sa	= '0';

#   $advanced_multiple_proposal_rekey_ike_sa:
#     If NUT supports CREATE_CHILD_SA exchnage with multiple Proposal
#     Substructure for IKE_SA, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_multiple_proposal_rekey_ike_sa	= '0';

#   $advanced_multiple_transform_rekey_child_sa:
#     If NUT supports CREATE_CHILD_SA exchnage with multiple Transform
#     Substructure for CHILD_SA, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_multiple_transform_rekey_child_sa	= '0';

#   $advanced_multiple_proposal_rekey_child_sa:
#     If NUT supports CREATE_CHILD_SA exchnage with multiple Proposal
#     Substructure for CHILD_SA, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_multiple_proposal_rekey_child_sa	= '0';

#   $advanced_support_cert:
#     If NUT supports CERT payload, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_cert	= '0';

#   $advanced_support_certreq:
#     If NUT supports CERTREQ payload, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_certreq	= '0';

#   $advanced_support_rsa_digital_signature:
#     If NUT supports authentication by RSA Digital Signature, please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_rsa_digital_signature	= '0';

#   $advanced_support_cfg_payload:
#     If NUT supports the function to process Configuration Payload,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_cfg_payload	= '0';

#   $advanced_support_invalid_spi:
#     If NUT supports the function to send INVALID_SPI notification,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_invalid_spi	= '0';

#   $advanced_support_invalid_ke_payload:
#     If NUT supports the function to send INVALID_KE_PAYLOAD notification,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_invalid_ke_payload	= '0';

#   $advanced_support_authentication_failed:
#     If NUT supports the function to send AUTHENTICATION_FAILED notification,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_authentication_failed	= '0';

#   $advanced_support_pfs:
#     If NUT supports perfect forward secrecy,
#     please set '1'.
#     If NUT does not support, please set '0'.
$advanced_support_pfs	= '0';


1;
