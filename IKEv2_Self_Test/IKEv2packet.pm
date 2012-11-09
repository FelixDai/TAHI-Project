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
# $Id: IKEv2packet.pm,v 1.43 2010/07/22 13:33:59 doo Exp $
#
################################################################



package IKEv2packet;



BEGIN {}
END   {}



use Exporter;
use strict;
use Socket qw( AF_INET6 );

use kIKE::kHelpers;


our @ISA = qw(Exporter);

our @EXPORT = qw(
	$gen_ike_sa_init_req
	$exp_ike_sa_init_req
	$default_gen_ike_sa_init_req
	$default_exp_ike_sa_init_req

	$gen_ike_sa_init_resp
	$exp_ike_sa_init_resp
	$default_gen_ike_sa_init_resp
	$default_exp_ike_sa_init_resp

	$gen_ike_auth_req
	$exp_ike_auth_req
	$transport_gen_ike_auth_req
	$transport_exp_ike_auth_req
	$tunnel_gen_ike_auth_req
	$tunnel_exp_ike_auth_req

	$gen_ike_auth_resp
	$exp_ike_auth_resp
	$transport_gen_ike_auth_resp
	$transport_exp_ike_auth_resp
	$tunnel_gen_ike_auth_resp
	$tunnel_exp_ike_auth_resp

	$gen_create_child_sa_req
	$exp_create_child_sa_req
	$transport_gen_create_child_sa_req
	$transport_exp_create_child_sa_req
	$tunnel_gen_create_child_sa_req
	$tunnel_exp_create_child_sa_req

	$gen_create_child_sa_resp
	$exp_create_child_sa_resp
	$transport_gen_create_child_sa_resp
	$transport_exp_create_child_sa_resp
	$tunnel_gen_create_child_sa_resp
	$tunnel_exp_create_child_sa_resp

	$gen_informational_req
	$exp_informational_req
	$default_gen_informational_req
	$default_exp_informational_req

	$gen_informational_resp
	$exp_informational_resp
	$default_gen_informational_resp
	$default_exp_informational_resp

	$operation_ike_sa_init_req
	$operation_ike_sa_init_resp
	$operation_ike_auth_req
	$operation_ike_auth_resp
	$operation_create_child_sa_req
	$operation_create_child_sa_resp
	$operation_informational_req
	$operation_informational_resp
);

use constant {
	USE_DONT_CHECK_PAYLOAD_ORDER => 0,
};


# IKE_SA_INIT request
our $gen_ike_sa_init_req = {};
our $default_gen_ike_sa_init_req = undef;
our $exp_ike_sa_init_req = {};
our $default_exp_ike_sa_init_req = undef;

# IKE_SA_INIT response
our $gen_ike_sa_init_resp = {};
our $default_gen_ike_sa_init_resp = undef;
our $exp_ike_sa_init_resp = {};
our $default_exp_ike_sa_init_resp = undef;

# IKE_AUTH request
our $gen_ike_auth_req = {};
our $transport_gen_ike_auth_req = undef;
our $tunnel_gen_ike_auth_req = undef;
our $exp_ike_auth_req = {};
our $transport_exp_ike_auth_req = undef;
our $tunnel_exp_ike_auth_req = undef;

# IKE_AUTH response
our $gen_ike_auth_resp = {};
our $transport_gen_ike_auth_resp = undef;
our $tunnel_gen_ike_auth_resp = undef;
our $exp_ike_auth_resp = {};
our $transport_exp_ike_auth_resp = undef;
our $tunnel_exp_ike_auth_resp = undef;

# CREATE_CHILD_SA request
our $gen_create_child_sa_req = {};
our $transport_gen_create_child_sa_req = undef;
our $tunnel_gen_create_child_sa_req = undef;
our $exp_create_child_sa_req = {};
our $transport_exp_create_child_sa_req = undef;
our $tunnel_exp_create_child_sa_req = undef;

# CREATE_CHILD_SA response
our $gen_create_child_sa_resp = {};
our $transport_gen_create_child_sa_resp = undef;
our $tunnel_gen_create_child_sa_resp = undef;
our $exp_create_child_sa_resp = {};
our $transport_exp_create_child_sa_resp = undef;
our $tunnel_exp_create_child_sa_resp = undef;

# INFORMATIONAL request
our $gen_informational_req = {};
our $default_gen_informational_req = undef;
our $exp_informational_req = {};
our $default_exp_informational_req = undef;

# INFORMATIONAL response
our $gen_informational_resp = {};
our $default_gen_informational_resp = undef;
our $exp_informational_resp = {};
our $default_exp_informational_resp = undef;


#----------------------------------------------------------------------#
# (generation) IKE_SA_INIT request                                     #
#----------------------------------------------------------------------#
$default_gen_ike_sa_init_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'generate',		# Initiator's SPI
		'respSPI'	=> undef,		# Responder's SPI
		'nexttype'	=> undef,		# Next Payload
		'major'		=> undef,		# Major Version
		'minor'		=> undef,		# Minor Version
		'exchType'	=> 'IKE_SA_INIT',	# Exchange Type
		'reserved1'	=> undef,		# Flags: X(reserved)
		'response'	=> undef,		# Flags: R(esponse)
		'higher'	=> undef,		# Flags: V(ersion)
		'initiator'	=> '1',			# Flags: I(nitiator)
		'reserved2'	=> undef,		# Flags: X(reserved)
		'messID'	=> undef,		# Message ID
		'length'	=> undef		# Length
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'		=> undef,	# 0 (last) or 2 (more)
				'reserved'		=> undef,	# RESERVED
				'proposalLen'		=> undef,	# Proposal Length
				'number'		=> undef,	# Proposal #
				'id'			=> 'IKE',	# Protocol ID
				'spiSize'		=> undef,	# SPI Size
				'transformCount'	=> undef,	# # of Transforms
				'spi'			=> undef,	# SPI
				'transforms'		=> [		# Transforms
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'ENCR',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'PRF',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'HMAC_SHA1',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'INTEG',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'D-H',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> '1024 MODP Group',	# Transform ID
						'attributes' => [		# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Key Exchange Payload
		'self'		=> 'KE',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'group'		=> '1024 MODP Group',	# DH Group #
		'reserved1'	=> undef,	# RESERVED
		'publicKey'	=> 'generate'	# Key Exchange Data
	},
	{	# Nonce Payload
		'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'nonce'		=> 'generate'	# Nonce Data
	}
];



#----------------------------------------------------------------------#
# (expectation) IKE_SA_INIT request                                    #
#----------------------------------------------------------------------#
$default_exp_ike_sa_init_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> '0000000000000000',	# Initiator's SPI
		'initSPI_comparator'	=> 'ne',
		'respSPI'	=> '0000000000000000',	# Responder's SPI
		'nexttype'	=> 'SA',		# Next Payload
		'major'		=> '2',			# Major Version
		'minor'		=> '0',			# Minor Version
		'exchType'	=> 'IKE_SA_INIT',	# Exchange Type
		'reserved1'	=> '0',			# Flags: X(reserved)
		'initiator'	=> '1',			# Flags: I(nitiator)
		'higher'	=> '0',			# Flags: V(ersion)
		'response'	=> '0',			# Flags: R(esponse)
		'reserved2'	=> '0',			# Flags: X(reserved)
		'messID'	=> '0',			# Message ID
		'length'	=> undef,		# Length
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> 'KE',	# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'length'	=> '44',	# Payload Length
		'proposals'	=> [	#	 Proposals
			{	# Proposal Substructure
				'nexttype'		=> '0',		# 0 (last) or 2 (more)
				'reserved'		=> '0',		# RESERVED
				'proposalLen'		=> '40',	# Proposal Length
				'number'		=> '1',		# Proposal #
				'id'			=> 'IKE',	# Protocol ID
				'spiSize'		=> '0',		# SPI Size
				'transformCount'	=> '4',		# # of Transforms
				'spi'			=> '',		# SPI
				'transforms'		=> [	# Transforms
					{	# Transform Substructure
						'nexttype'	=> '3',		# 0 (last) or 3 (more)
						'reserved1'	=> '0',		# RESERVED
						'transformLen'	=> '8',		# Transform Length
						'type'		=> 'ENCR',	# Transform Type
						'reserved2'	=> '0',		# RESERVED
						'id'		=> '3DES',	# Transform ID
						'attributes'	=> [	# Transform Attributes
						]
					},
					{	# Transform Substructure
						'nexttype'	=> '3',		# 0 (last) or 3 (more)
						'reserved1'	=> '0',		# RESERVED
						'transformLen'	=> '8',		# Transform Length
						'type'		=> 'PRF',	# Transform Type
						'reserved2'	=> '0',		# RESERVED
						'id'		=> 'HMAC_SHA1',	# Transform ID
						'attributes'	=> [	# Transform Attributes
						]
					},
					{	# Transform Substructure
						'nexttype'	=> '3',		# 0 (last) or 3 (more)
						'reserved1'	=> '0',		# RESERVED
						'transformLen'	=> '8',		# Transform Length
						'type'		=> 'INTEG',	# Transform Type
						'reserved2'	=> '0',		# RESERVED
						'id'		=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [	# Transform Attributes
						]
					},
					{	# Transform Substructure
						'nexttype'	=> '0',		# 0 (last) or 3 (more)
						'reserved1'	=> '0',		# RESERVED
						'transformLen'	=> '8',		# Transform Length
						'type'		=> 'D-H',	# Transform Type
						'reserved2'	=> '0',		# RESERVED
						'id'		=> '1024 MODP Group',	# Transform ID
						'attributes' => [	# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Key Exchange Payload
		'self'		=> 'KE',	# *** MUST BE HERE ***

		'nexttype'	=> 'Ni, Nr',	# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'length'	=> '136',	# Payload Length
		'group'		=> '2',		# DH Group #
		'reserved1'	=> '0',		# RESERVED
		'publicKey'	=> undef,	# Key Exchange Data
	},
	{	# Nonce Payload
		'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

		'nexttype'	=> '0',		# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'length'	=> [20, 260],	# Payload Length	20 - 260
		'length_comparator'	=> 'range',
		'nonce'		=> undef,	# Nonce Data	256
	}
];



#----------------------------------------------------------------------#
# (generation) IKE_SA_INIT response                                    #
#----------------------------------------------------------------------#
$default_gen_ike_sa_init_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'generate',		# Responder's SPI
		'nexttype'	=> undef,		# Next Payload
		'major'		=> undef,		# Major Version
		'minor'		=> undef,		# Minor Version
		'exchType'	=> 'IKE_SA_INIT',	# Exchange Type
		'reserved1'	=> undef,		# Flags: X(reserved)
		'response'	=> '1',			# Flags: R(esponse)
		'higher'	=> undef,		# Flags: V(ersion)
		'initiator'	=> undef,		# Flags: I(nitiator)
		'reserved2'	=> undef,		# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'		=> undef,	# 0 (last) or 2 (more)
				'reserved'		=> undef,	# RESERVED
				'proposalLen'		=> undef,	# Proposal Length
				'number'		=> undef,	# Proposal #
				'id'			=> 'IKE',	# Protocol ID
				'spiSize'		=> undef,	# SPI Size
				'transformCount'	=> undef,	# # of Transforms
				'spi'			=> undef,	# SPI
				'transforms'		=> [		# Transforms
					{	# Transform Substructure
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'ENCR',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{	# Transform Substructure
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'PRF',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'HMAC_SHA1',		# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{	# Transform Substructure
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'INTEG',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{	# Transform Substructure
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'D-H',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> '1024 MODP Group',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Key Exchange Payload
		'self'		=> 'KE',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'group'		=> '1024 MODP Group',	# DH Group #
		'reserved1'	=> undef,	# RESERVED
		'publicKey'	=> 'generate'	# Key Exchange Data
	},
	{	# Nonce Payload
		'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length	20 - 260
		'nonce'		=> 'generate',	# Nonce Data
	}
];



#----------------------------------------------------------------------#
# (expectation) IKE_SA_INIT response                                   #
#----------------------------------------------------------------------#
$default_exp_ike_sa_init_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',	# *** MUST BE HERE ***

		'initSPI'	=> 'read',	# Initiator's SPI
		'respSPI'	=> '0000000000000000',	# Responder's SPI
		'respSPI_comparator'	=> 'ne',
		'nexttype'	=> 'SA',	# Next Payload
		'major'		=> '2',		# Major Version
		'minor'		=> '0',		# Minor Version
		'exchType'	=> 'IKE_SA_INIT',	# Exchange Type
		'reserved1'	=> '0',		# Flags: X(reserved)
		'response'	=> '1',		# Flags: R(esponse)
		'higher'	=> '0',		# Flags: V(ersion)
		'initiator'	=> '0',		# Flags: I(nitiator)
		'reserved2'	=> '0',		# Flags: X(reserved)
		'messID'	=> 'read',	# Message ID
		'length'	=> undef	# Length
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> 'KE',	# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'length'	=> '44',	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'		=> '0',		# 0 (last) or 2 (more)
				'reserved'		=> '0',		# RESERVED
				'proposalLen'		=> '40',	# Proposal Length
				'number'		=> '1',		# Proposal #
				'id'			=> 'IKE',	# Protocol ID
				'spiSize'		=> '0',		# SPI Size
				'transformCount'	=> '4',		# # of Transforms
				'spi'			=> '',		# SPI
				'transforms'		=> [		# Transforms
					{	# Transform Substructure
						'nexttype'	=> '3',		# 0 (last) or 3 (more)
						'reserved1'	=> '0',		# RESERVED
						'transformLen'	=> '8',		# Transform Length
						'type'		=> 'ENCR',	# Transform Type
						'reserved2'	=> '0',		# RESERVED
						'id'		=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{	# Transform Substructure
						'nexttype'	=> '3',		# 0 (last) or 3 (more)
						'reserved1'	=> '0',		# RESERVED
						'transformLen'	=> '8',		# Transform Length
						'type'		=> 'PRF',	# Transform Type
						'reserved2'	=> '0',		# RESERVED
						'id'		=> 'HMAC_SHA1',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{	# Transform Substructure
						'nexttype'	=> '3',		# 0 (last) or 3 (more)
						'reserved1'	=> '0',		# RESERVED
						'transformLen'	=> '8',		# Transform Length
						'type'		=> 'INTEG',	# Transform Type
						'reserved2'	=> '0',		# RESERVED
						'id'		=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{	# Transform Substructure
						'nexttype'	=> '0',		# 0 (last) or 3 (more)
						'reserved1'	=> '0',		# RESERVED
						'transformLen'	=> '8',		# Transform Length
						'type'		=> 'D-H',	# Transform Type
						'reserved2'	=> '0',		# RESERVED
						'id'		=> '1024 MODP Group',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Key Exchange Payload
		'self'		=> 'KE',	# *** MUST BE HERE ***

		'nexttype'	=> 'Ni, Nr',	# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'length'	=> '136',	# Payload Length
		'group'		=> '2',		# DH Group #
		'reserved1'	=> '0',		# RESERVED
		'publicKey'	=> undef	# Key Exchange Data
	},
	{	# Nonce Payload
		'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

		'nexttype'	=> '0',		# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'length'	=> [20, 260],	# Payload Length	20 - 260
		'length_comparator'	=> 'range',
		'nonce'		=> undef,	# Nonce Data
	}
];



#----------------------------------------------------------------------#
# (generation) IKE_AUTH request                                        #
#----------------------------------------------------------------------#
$transport_gen_ike_auth_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> undef,		# Next Payload
		'major'		=> undef,		# Major Version
		'minor'		=> undef,		# Minor Version
		'exchType'	=> 'IKE_AUTH',		# Exchange Type
		'reserved1'	=> undef,		# Flags: X(reserved)
		'response'	=> undef,		# Flags: R(esponse)
		'higher'	=> undef,		# Flags: V(ersion)
		'initiator'	=> '1',			# Flags: I(nitiator)
		'reserved2'	=> undef,		# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrytpted Payloads
		'self'		=> 'E',		# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		# 'iv'		=> undef,	# Initialization Vector
		# 'pad'		=> undef,	# Padding
		# 'padlen'	=> undef,	# Pad Length
		# 'checksum'	=> undef,	# Integrity Checksum Data
	},
	{	# Identification Payloads
		'self'		=> 'IDi',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		# XXX: IPV4
		#'type'		=> 'IPV6_ADDR',		# ID Type
		'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					'IPV6_ADDR' : 'IPV4_ADDR',	# ID Type
							# (IPV6_ADDR, IPV4_ADDR, FQDN, RFC822_ADDR, KEY_ID)
		'reserved1'	=> undef,	# RESERVED
		'value'		=> 'read',	# Identification Data
						# (192.168.0.1, example.com, jsmith@example.com, XXX)
	},
	{	# Authentication Payload
		'self'		=> 'AUTH',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'method'	=> 'SK_MIC',	# Auth Method
		'reserved1'	=> undef,	# RESERVED
		'data'		=> 'generate'	# Authentication Data
	},
	{	# Notify Payload
		'self'		=> 'N',		# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'id'		=> undef,	# Protocol ID
		'spiSize'	=> undef,	# SPI Size
		'type'		=> 'USE_TRANSPORT_MODE',	# Notify Message Type
		'spi'		=> undef,	# SPI
		'data'		=> undef	# Notification Data
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'		=> undef,	# 0 (last) or 2 (more)
				'reserved'		=> undef,	# RESERVED
				'proposalLen'		=> undef,	# Proposal Length
				'number'		=> undef,	# Proposal #
				'id'			=> 'ESP',	# Protocol ID
				'spiSize'		=> undef,	# SPI Size
				'transformCount'	=> undef,	# # of Transforms
				'spi'			=> 'generate',	# SPI
				'transforms'		=> [		# Transforms
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'ENCR',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'INTEG',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'ESN',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'No ESN',	# Transform ID
						'attributes' => [		# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Traffic Selector - Initiator
		'self'		=> 'TSi',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'	=> '0',		# IP Protocol ID
				'selectorLen'	=> undef,	# Selector Length
				'sport'		=> '0',		# Start Port
				'eport'		=> '65535',	# End Port
				'saddr'		=> 'read',	# Starting Address
				'eaddr'		=> 'read',	# Ending Address
			}
		]
	},
	{	# Traffic Selector - Responder
		'self'		=> 'TSr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 				'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'	=> '0',		# IP Protocol ID
				'selectorLen'	=> undef,	# Selector Length
				'sport'		=> '0',		# Start Port
				'eport'		=> '65535',	# End Port
				'saddr'		=> 'read',	# Starting Address
				'eaddr'		=> 'read',	# Ending Address
			}
		]
	}
];

$tunnel_gen_ike_auth_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> undef,		# Next Payload
		'major'		=> undef,		# Major Version
		'minor'		=> undef,		# Minor Version
		'exchType'	=> 'IKE_AUTH',		# Exchange Type
		'reserved1'	=> undef,		# Flags: X(reserved)
		'response'	=> undef,		# Flags: R(esponse)
		'higher'	=> undef,		# Flags: V(ersion)
		'initiator'	=> '1',			# Flags: I(nitiator)
		'reserved2'	=> undef,		# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrytpted Payloads
		'self'		=> 'E',		# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		# 'iv'		=> undef,	# Initialization Vector
		# 'pad'		=> undef,	# Padding
		# 'padlen'	=> undef,	# Pad Length
		# 'checksum'	=> undef,	# Integrity Checksum Data
	},
	{	# Identification Payloads
		'self'		=> 'IDi',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		# XXX: IPV4
		#'type'		=> 'IPV6_ADDR',		# ID Type
		'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					'IPV6_ADDR' : 'IPV4_ADDR',	# ID Type
							# (IPV6_ADDR, IPV4_ADDR, FQDN, RFC822_ADDR, KEY_ID)
		'reserved1'	=> undef,	# RESERVED
		'value'		=> 'read',	# Identification Data
						# (192.168.0.1, example.com, jsmith@example.com, XXX)
	},
	{	# Authentication Payload
		'self'		=> 'AUTH',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'method'	=> 'SK_MIC',	# Auth Method
		'reserved1'	=> undef,	# RESERVED
		'data'		=> 'generate'	# Authentication Data
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'		=> undef,	# 0 (last) or 2 (more)
				'reserved'		=> undef,	# RESERVED
				'proposalLen'		=> undef,	# Proposal Length
				'number'		=> undef,	# Proposal #
				'id'			=> 'ESP',	# Protocol ID
				'spiSize'		=> undef,	# SPI Size
				'transformCount'	=> undef,	# # of Transforms
				'spi'			=> 'generate',	# SPI
				'transforms'		=> [		# Transforms
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'ENCR',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'INTEG',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'ESN',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'No ESN',	# Transform ID
						'attributes' => [		# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Traffic Selector - Initiator
		'self'		=> 'TSi',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'	=> '0',		# IP Protocol ID
				'selectorLen'	=> undef,	# Selector Length
				'sport'		=> '0',		# Start Port
				'eport'		=> '65535',	# End Port
				'saddr'		=> 'read',	# Starting Address
				'eaddr'		=> 'read',	# Ending Address
			}
		]
	},
	{	# Traffic Selector - Responder
		'self'		=> 'TSr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 				'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'	=> '0',		# IP Protocol ID
				'selectorLen'	=> undef,	# Selector Length
				'sport'		=> '0',		# Start Port
				'eport'		=> '65535',	# End Port
				'saddr'		=> 'read',	# Starting Address
				'eaddr'		=> 'read',	# Ending Address
			}
		]
	}
]; # $tunnel_gen_ike_auth_req


#----------------------------------------------------------------------#
# (expectation) IKE_AUTH request                                       #
#----------------------------------------------------------------------#
$transport_exp_ike_auth_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> 'E',			# Next Payload
		'major'		=> '2',			# Major Version
		'minor'		=> '0',			# Minor Version
		'exchType'	=> 'IKE_AUTH',		# Exchange Type
		'reserved1'	=> '0',			# Flags: X(reserved)
		'initiator'	=> '1',			# Flags: I(nitiator)
		'higher'	=> '0',			# Flags: V(ersion)
		'response'	=> '0',			# Flags: R(esponse)
		'reserved2'	=> '0',			# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrypted Payload
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'		=> '0',		# outer Next Payload
		'innerType'		=> 'IDi',	# Next Payload
		'critical'		=> '0',		# Critical
		'reserved'		=> '0',		# RESERVED
		'enc_paylen'	=> undef,	# Payload Length
		'innerPayloads' => [
			{	# Identification Payload - Responder
				'self'		=> 'IDi',		# *** MUST BE HERE ***

				'nexttype'	=> 'AUTH',		# Next Payload
				'critical'	=> '0',			# Critical
				'reserved'	=> '0',			# RESERVED
				# XXX: IPV4
				#'length'	=> '24',		# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'24' : '12',	# Payload Length
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR',		# ID Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'IPV6_ADDR' : 'IPV4_ADDR',	# ID Type
				'reserved1'	=> '0',			# RESERVED
				'value'		=> 'read'		# Identification Data
			},
			{	# Authentication Payload
				'self'		=> 'AUTH',		# *** MUST BE HERE ***

				'nexttype'	=> 'N', 		# Next Payload
				'critical'	=> '0',			# Critical
				'reserved'	=> '0',			# RESERVED
				'length'	=> undef,		# Payload Length
				'method'	=> 'SK_MIC',		# Authentication Method
				'reserved1'	=> '0',			# RESERVED
				'data'		=> undef		# Authentication Data
			},
			{	# Notify Payload
				'self'		=> 'N',			# *** MUST BE HERE ***

				'nexttype'	=> 'SA', 		# Next Payload
				'critical'	=> '0',			# Critical
				'reserved'	=> '0',			# RESERVED
				'length'	=> '8',			# Payload Length
				'id'		=> '0',			# Protocol ID
				'spiSize'	=> '0',			# SPI Size
				'type'		=> 'USE_TRANSPORT_MODE',	# Notify Type
				'spi'		=> '',			# SPI
				'data'		=> ''			# Notification Data
			},
			{	# Security Association Payload
				'self'		=> 'SA',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSi', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> '40',	# Payload Length
				'proposals'	=> [		# Proposals
					{	# Proposal Substructure
						'nexttype'		=> '0',		# Next
						'reserved'		=> '0',		# RESERVED
						'proposalLen'		=> '36',	# Proposal Length
						'number'		=> '1',		# Proposal #
						'id'			=> 'ESP',	# Proposal ID
						'spiSize'		=> '4',		# SPI Size
						'transformCount'	=> '3',		# # of Transforms
						'spi'			=> undef,	# SPI
						'transforms'		=> [		# Transforms
							{	# Transform Substructure
								'nexttype'		=> '3',		# Next
								'reserved1'		=> '0',		# RESERVED
								'transformLen'		=> '8',		# Transform Length
								'type'			=> 'ENCR',	# Transform Type
								'reserved2'		=> '0',		# RESERVED
								'id'			=> '3DES',	# Transform ID
								'attributes'	=> [		# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'		=> '3',			# Next
								'reserved1'		=> '0',			# RESERVED
								'transformLen'		=> '8',			# Transform Length
								'type'			=> 'INTEG',		# Transform Type
								'reserved2'		=> '0',			# RESERVED
								'id'			=> 'HMAC_SHA1_96',	# Transform ID
								'attributes'	=> [				# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'		=> '0',		# Next
								'reserved1'		=> '0',		# RESERVED
								'transformLen'		=> '8',		# Transform Length
								'type'			=> 'ESN',	# Transform Type
								'reserved2'		=> '0',		# RESERVED
								'id'			=> 'No ESN',	# Transform ID
								'attributes'	=> [			# Transfom Attributes
								]
							}
						]
					}
				]
			},
			{	# Traffic Selector Payload - Initiator
				'self'		=> 'TSi',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSr',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 							'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',			# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',			# Start Port
						'eport'			=> '65535',		# End Port
						'saddr'			=> 'read',		# Starting Address
						'eaddr'			=> 'read'		# Ending Address
						# 'saddr'			=> undef,		# Starting Address
						# 'eaddr'			=> undef		# Ending Address
						#'saddr'			=> ipaddr_tobin(
						#				(IKEv2::ADDRESS_FAMILY == AF_INET6) ?
						#				'::': '0.0.0.0'),
						#'eaddr'			=> ipaddr_tobin(
						#				(IKEv2::ADDRESS_FAMILY == AF_INET6) ?
						#				'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff': '255.255.255.255'),
					}
				]
			},
			{	# Traffic Selector Payload - Responder
				'self'		=> 'TSr',	# *** MUST BE HERE ***

				'nexttype'	=> '0',		# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',			# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',			# Start Port
						'eport'			=> '65535',		# End Port
						'saddr'			=> 'read',		# Starting Address
						'eaddr'			=> 'read'		# Ending Address
						# 'saddr'			=> undef,		# Starting Address
						# 'eaddr'			=> undef		# Ending Address
						#'saddr'			=> ipaddr_tobin(
						#				(IKEv2::ADDRESS_FAMILY == AF_INET6) ?
						#				'::': '0.0.0.0'),
						#'eaddr'			=> ipaddr_tobin(
						#				(IKEv2::ADDRESS_FAMILY == AF_INET6) ?
						#				'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff': '255.255.255.255'),
					}
				]
			}
		]
	}
]; # $transport_exp_ike_auth_req

$tunnel_exp_ike_auth_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> 'E',			# Next Payload
		'major'		=> '2',			# Major Version
		'minor'		=> '0',			# Minor Version
		'exchType'	=> 'IKE_AUTH',		# Exchange Type
		'reserved1'	=> '0',			# Flags: X(reserved)
		'initiator'	=> '1',			# Flags: I(nitiator)
		'higher'	=> '0',			# Flags: V(ersion)
		'response'	=> '0',			# Flags: R(esponse)
		'reserved2'	=> '0',			# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrypted Payload
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'		=> '0',		# outer Next Payload
		'innerType'		=> 'IDi',	# Next Payload
		'critical'		=> '0',		# Critical
		'reserved'		=> '0',		# RESERVED
		'enc_paylen'	=> undef,	# Payload Length
		'innerPayloads' => [
			{	# Identification Payload - Responder
				'self'		=> 'IDi',		# *** MUST BE HERE ***

				'nexttype'	=> 'AUTH',		# Next Payload
				'critical'	=> '0',			# Critical
				'reserved'	=> '0',			# RESERVED
				# XXX: IPV4
				#'length'	=> '24',		# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'24' : '12',	# Payload Length
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR',		# ID Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'IPV6_ADDR' : 'IPV4_ADDR',	# ID Type
				'reserved1'	=> '0',			# RESERVED
				'value'		=> 'read'		# Identification Data
			},
			{	# Authentication Payload
				'self'		=> 'AUTH',		# *** MUST BE HERE ***

				'nexttype'	=> 'SA', 		# Next Payload
				'critical'	=> '0',			# Critical
				'reserved'	=> '0',			# RESERVED
				'length'	=> undef,		# Payload Length
				'method'	=> 'SK_MIC',		# Authentication Method
				'reserved1'	=> '0',			# RESERVED
				'data'		=> undef		# Authentication Data
			},
			{	# Security Association Payload
				'self'		=> 'SA',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSi', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> '40',	# Payload Length
				'proposals'	=> [		# Proposals
					{	# Proposal Substructure
						'nexttype'		=> '0',		# Next
						'reserved'		=> '0',		# RESERVED
						'proposalLen'		=> '36',	# Proposal Length
						'number'		=> '1',		# Proposal #
						'id'			=> 'ESP',	# Proposal ID
						'spiSize'		=> '4',		# SPI Size
						'transformCount'	=> '3',		# # of Transforms
						'spi'			=> undef,	# SPI
						'transforms'		=> [		# Transforms
							{	# Transform Substructure
								'nexttype'		=> '3',		# Next
								'reserved1'		=> '0',		# RESERVED
								'transformLen'		=> '8',		# Transform Length
								'type'			=> 'ENCR',	# Transform Type
								'reserved2'		=> '0',		# RESERVED
								'id'			=> '3DES',	# Transform ID
								'attributes'	=> [		# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'		=> '3',			# Next
								'reserved1'		=> '0',			# RESERVED
								'transformLen'		=> '8',			# Transform Length
								'type'			=> 'INTEG',		# Transform Type
								'reserved2'		=> '0',			# RESERVED
								'id'			=> 'HMAC_SHA1_96',	# Transform ID
								'attributes'	=> [				# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'		=> '0',		# Next
								'reserved1'		=> '0',		# RESERVED
								'transformLen'		=> '8',		# Transform Length
								'type'			=> 'ESN',	# Transform Type
								'reserved2'		=> '0',		# RESERVED
								'id'			=> 'No ESN',	# Transform ID
								'attributes'	=> [			# Transfom Attributes
								]
							}
						]
					}
				]
			},
			{	# Traffic Selector Payload - Initiator
				'self'		=> 'TSi',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSr',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 							'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',			# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',			# Start Port
						'eport'			=> '65535',		# End Port
						'saddr'			=> 'read',		# Starting Address
						'eaddr'			=> 'read'		# Ending Address
						# 'saddr'			=> undef,		# Starting Address
						# 'eaddr'			=> undef		# Ending Address
						#'saddr'			=> ipaddr_tobin(
						#				(IKEv2::ADDRESS_FAMILY == AF_INET6) ?
						#				'::': '0.0.0.0'),
						#'eaddr'			=> ipaddr_tobin(
						#				(IKEv2::ADDRESS_FAMILY == AF_INET6) ?
						#				'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff': '255.255.255.255'),
					}
				]
			},
			{	# Traffic Selector Payload - Responder
				'self'		=> 'TSr',	# *** MUST BE HERE ***

				'nexttype'	=> '0',		# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',			# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',			# Start Port
						'eport'			=> '65535',		# End Port
						'saddr'			=> 'read',		# Starting Address
						'eaddr'			=> 'read'		# Ending Address
						# 'saddr'			=> undef,		# Starting Address
						# 'eaddr'			=> undef		# Ending Address
						#'saddr'			=> ipaddr_tobin(
						#				(IKEv2::ADDRESS_FAMILY == AF_INET6) ?
						#				'::': '0.0.0.0'),
						#'eaddr'			=> ipaddr_tobin(
						#				(IKEv2::ADDRESS_FAMILY == AF_INET6) ?
						#				'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff': '255.255.255.255'),
					}
				]
			}
		]
	}
]; # $tunnel_exp_ike_auth_req



#----------------------------------------------------------------------#
# (generation) IKE_AUTH response                                       #
#----------------------------------------------------------------------#
$transport_gen_ike_auth_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',	# *** MUST BE HERE ***

		'initSPI'	=> 'read',	# Initiator's SPI
		'respSPI'	=> 'read',	# Responder's SPI
		'nexttype'	=> undef,	# Next Payload
		'major'		=> undef,	# Major Version
		'minor'		=> undef,	# Minor Version
		'exchType'	=> 'IKE_AUTH',	# Exchange Type
		'reserved1'	=> undef,	# Flags: X(reserved)
		'response'	=> '1',		# Flags: R(esponse)
		'higher'	=> undef,	# Flags: V(ersion)
		'initiator'	=> undef,	# Flags: I(nitiator)
		'reserved2'	=> undef,	# Flags: X(reserved)
		'messID'	=> 'read',	# Message ID
		'length'	=> undef	# Length
	},
	{	# Encrypted Payloads
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'		=> undef,	# Next Payload
		'critical'		=> undef,	# Critical
		'reserved'		=> undef,	# RESERVED
		'length'		=> undef,	# Payload Length
		# 'iv'			=> undef,	# Initialization Vector
		# 'pad'			=> undef,	# Padding
		# 'padlen'		=> undef,	# Pad Length
		# 'checksum'	=> undef,	# Integrity Checksum Data
	},
	{	# Identification Payloads
		'self'		=> 'IDr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		# XXX: IPV4
		#'type'		=> 'IPV6_ADDR',	# ID Type
		'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					'IPV6_ADDR' : 'IPV4_ADDR',	# ID Type
		'reserved1'	=> undef,	# RESERVED
		'value'		=> 'read',	# Identification Data
	},
	{	# Authentication Payload
		'self'		=> 'AUTH',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'method'	=> 'SK_MIC',	# Auth Method
		'reserved1'	=> undef,	# RESERVED
		'data'		=> 'generate'	# Authentication Data
	},
	{	# Notify Payload
		'self'		=> 'N',				# *** MUST BE HERE ***

		'nexttype'	=> undef,			# Next Payload
		'critical'	=> undef,			# Critical
		'reserved'	=> undef,			# RESERVED
		'length'	=> undef,			# Payload Length
		'id'		=> undef,			# Protocol ID
		'spiSize'	=> undef,			# SPI Size
		'type'		=> 'USE_TRANSPORT_MODE',	# Notify Message Type
		'spi'		=> undef,			# SPI
		'data'		=> undef			# Notification Data
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'		=> undef,		# 0 (last) or 2 (more)
				'reserved'		=> undef,		# RESERVED
				'proposalLen'		=> undef,		# Proposal Length
				'number'		=> undef,		# Proposal #
				'id'			=> 'ESP',		# Protocol ID
				'spiSize'		=> undef,		# SPI Size
				'transformCount'	=> undef,		# # of Transforms
				'spi'			=> 'generate',		# SPI
				'transforms'		=> [			# Transforms
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'ENCR',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'INTEG',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'ESN',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'No ESN',	# Transform ID
						'attributes' => [		# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Traffic Selector - Initiator
		'self'		=> 'TSi',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 				'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'	=> '0',		# IP Protocol ID
				'selectorLen'	=> undef,	# Selector Length
				'sport'		=> '0',		# Start Port
				'eport'		=> '65535',	# End Port
				'saddr'		=> 'read',	# Starting Address
				'eaddr'		=> 'read',	# Ending Address
			}
		]
	},
	{	# Traffic Selector - Responder
		'self'		=> 'TSr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 				'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'	=> '0',		# IP Protocol ID
				'selectorLen'	=> undef,	# Selector Length
				'sport'		=> '0',		# Start Port
				'eport'		=> '65535',	# End Port
				'saddr'		=> 'read',	# Starting Address
				'eaddr'		=> 'read',	# Ending Address
			}
		]
	}
]; # $transport_gen_ike_auth_resp

$tunnel_gen_ike_auth_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',	# *** MUST BE HERE ***

		'initSPI'	=> 'read',	# Initiator's SPI
		'respSPI'	=> 'read',	# Responder's SPI
		'nexttype'	=> undef,	# Next Payload
		'major'		=> undef,	# Major Version
		'minor'		=> undef,	# Minor Version
		'exchType'	=> 'IKE_AUTH',	# Exchange Type
		'reserved1'	=> undef,	# Flags: X(reserved)
		'response'	=> '1',		# Flags: R(esponse)
		'higher'	=> undef,	# Flags: V(ersion)
		'initiator'	=> undef,	# Flags: I(nitiator)
		'reserved2'	=> undef,	# Flags: X(reserved)
		'messID'	=> 'read',	# Message ID
		'length'	=> undef	# Length
	},
	{	# Encrypted Payloads
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'		=> undef,	# Next Payload
		'critical'		=> undef,	# Critical
		'reserved'		=> undef,	# RESERVED
		'length'		=> undef,	# Payload Length
		# 'iv'			=> undef,	# Initialization Vector
		# 'pad'			=> undef,	# Padding
		# 'padlen'		=> undef,	# Pad Length
		# 'checksum'	=> undef,	# Integrity Checksum Data
	},
	{	# Identification Payloads
		'self'		=> 'IDr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		# XXX: IPV4
		#'type'		=> 'IPV6_ADDR',	# ID Type
		'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					'IPV6_ADDR' : 'IPV4_ADDR',	# ID Type
		'reserved1'	=> undef,	# RESERVED
		'value'		=> 'read',	# Identification Data
	},
	{	# Authentication Payload
		'self'		=> 'AUTH',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'method'	=> 'SK_MIC',	# Auth Method
		'reserved1'	=> undef,	# RESERVED
		'data'		=> 'generate'	# Authentication Data
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'		=> undef,		# 0 (last) or 2 (more)
				'reserved'		=> undef,		# RESERVED
				'proposalLen'		=> undef,		# Proposal Length
				'number'		=> undef,		# Proposal #
				'id'			=> 'ESP',		# Protocol ID
				'spiSize'		=> undef,		# SPI Size
				'transformCount'	=> undef,		# # of Transforms
				'spi'			=> 'generate',		# SPI
				'transforms'		=> [			# Transforms
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'ENCR',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'INTEG',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'	=> undef,	# 0 (last) or 3 (more)
						'reserved1'	=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'		=> 'ESN',	# Transform Type
						'reserved2'	=> undef,	# RESERVED
						'id'		=> 'No ESN',	# Transform ID
						'attributes' => [		# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Traffic Selector - Initiator
		'self'		=> 'TSi',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 				'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'	=> '0',		# IP Protocol ID
				'selectorLen'	=> undef,	# Selector Length
				'sport'		=> '0',		# Start Port
				'eport'		=> '65535',	# End Port
				'saddr'		=> 'read',	# Starting Address
				'eaddr'		=> 'read',	# Ending Address
			}
		]
	},
	{	# Traffic Selector - Responder
		'self'		=> 'TSr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 				'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'	=> '0',		# IP Protocol ID
				'selectorLen'	=> undef,	# Selector Length
				'sport'		=> '0',		# Start Port
				'eport'		=> '65535',	# End Port
				'saddr'		=> 'read',	# Starting Address
				'eaddr'		=> 'read',	# Ending Address
			}
		]
	}
]; # $tunnel_gen_ike_auth_resp



#----------------------------------------------------------------------#
# (expectation) IKE_AUTH response                                      #
#----------------------------------------------------------------------#
$transport_exp_ike_auth_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> 'E',			# Next Payload
		'major'		=> '2',			# Major Version
		'minor'		=> '0',			# Minor Version
		'exchType'	=> 'IKE_AUTH',		# Exchange Type
		'reserved1'	=> '0',			# Flags: X(reserved)
		'response'	=> '1',			# Flags: R(esponse)
		'higher'	=> '0',			# Flags: V(ersion)
		'initiator'	=> '0',			# Flags: I(nitiator)
		'reserved2'	=> '0',			# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrypted Payload
		'self'		=> 'E',		# *** MUST BE HERE ***

		'nexttype'	=> '0',		# outer Next Payload
		'innerType'	=> 'IDr',	# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'enc_paylen'	=> undef,	# Payload Length
		'innerPayloads' => [
			{	# Identification Payload - Responder
				'self'		=> 'IDr',		# *** MUST BE HERE ***

				'nexttype'	=> 'AUTH',		# Next Payload
				'critical'	=> '0',			# Critical
				'reserved'	=> '0',			# RESERVED
				# XXX IPV4
				#'length'	=> '24',		# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'24' : '12',	# Payload Length
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR',	# ID Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'IPV6_ADDR' : 'IPV4_ADDR',	# ID Type
				'reserved1'	=> '0',			# RESERVED
				'value'		=> 'read'		# Identification Data
			},
			{	# Authentication Payload
				'self'		=> 'AUTH',	# *** MUST BE HERE ***

				'nexttype'	=> 'N', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> undef,	# Payload Length
				'method'	=> 'SK_MIC',	# Authentication Method
				'reserved1'	=> '0',		# RESERVED
				'data'		=> undef	# Authentication Data
			},
			{	# Notify Payload
				'self'		=> 'N',		# *** MUST BE HERE ***

				'nexttype'	=> 'SA', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> '8',		# Payload Length
				'id'		=> '0',		# Protocol ID
				'spiSize'	=> '0',		# SPI Size
				'type'		=> 'USE_TRANSPORT_MODE',	# Notify Type
				'spi'		=> '',		# SPI
				'data'		=> ''		# Notification Data
			},
			{	# Security Association Payload
				'self'		=> 'SA',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSi', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> '40',	# Payload Length
				'proposals'	=> [		# Proposals
					{	# Proposal Substructure
						'nexttype'		=> '0',		# Next
						'reserved'		=> '0',		# RESERVED
						'proposalLen'		=> '36',	# Proposal Length
						'number'		=> '1',		# Proposal #
						'id'			=> 'ESP',	# Proposal ID
						'spiSize'		=> '4',		# SPI Size
						'transformCount'	=> '3',		# # of Transforms
						'spi'				=> undef,	# SPI
						'transforms'		=> [		# Transforms
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ENCR',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> '3DES',	# Transform ID
								'attributes'	=> [		# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'INTEG',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'HMAC_SHA1_96',	# Transform ID
								'attributes'	=> [		# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '0',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ESN',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'No ESN',	# Transform ID
								'attributes'	=> [		# Transfom Attributes
								]
							}
						]
					}
				]
			},
			{	# Traffic Selector Payload - Initiator
				'self'		=> 'TSi',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSr',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 				'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'	=> '0',		# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',	# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',	# Selector Length
						'sport'		=> '0',		# Start Port
						'eport'		=> '65535',	# End Port
						'saddr'		=> 'read',	# Starting Address
						'eaddr'		=> 'read'	# Ending Address
					}
				]
			},
			{	# Traffic Selector Payload - Responder
				'self'		=> 'TSr',	# *** MUST BE HERE ***

				'nexttype'	=> '0',		# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 				'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'	=> '0',		# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',	# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',	# Selector Length
						'sport'		=> '0',		# Start Port
						'eport'		=> '65535',	# End Port
						'saddr'		=> 'read',	# Starting Address
						'eaddr'		=> 'read'	# Ending Address
					}
				]
			}
		]
	}
]; # $transport_exp_ike_auth_resp

$tunnel_exp_ike_auth_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> 'E',			# Next Payload
		'major'		=> '2',			# Major Version
		'minor'		=> '0',			# Minor Version
		'exchType'	=> 'IKE_AUTH',		# Exchange Type
		'reserved1'	=> '0',			# Flags: X(reserved)
		'response'	=> '1',			# Flags: R(esponse)
		'higher'	=> '0',			# Flags: V(ersion)
		'initiator'	=> '0',			# Flags: I(nitiator)
		'reserved2'	=> '0',			# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrypted Payload
		'self'		=> 'E',		# *** MUST BE HERE ***

		'nexttype'	=> '0',		# outer Next Payload
		'innerType'	=> 'IDr',	# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'enc_paylen'	=> undef,	# Payload Length
		'innerPayloads' => [
			{	# Identification Payload - Responder
				'self'		=> 'IDr',		# *** MUST BE HERE ***

				'nexttype'	=> 'AUTH',		# Next Payload
				'critical'	=> '0',			# Critical
				'reserved'	=> '0',			# RESERVED
				# XXX IPV4
				#'length'	=> '24',		# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'24' : '12',	# Payload Length
				# XXX: IPV4
				#'type'		=> 'IPV6_ADDR',	# ID Type
				'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'IPV6_ADDR' : 'IPV4_ADDR',	# ID Type
				'reserved1'	=> '0',			# RESERVED
				'value'		=> 'read'		# Identification Data
			},
			{	# Authentication Payload
				'self'		=> 'AUTH',	# *** MUST BE HERE ***

				'nexttype'	=> 'SA', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> undef,	# Payload Length
				'method'	=> 'SK_MIC',	# Authentication Method
				'reserved1'	=> '0',		# RESERVED
				'data'		=> undef	# Authentication Data
			},
			{	# Security Association Payload
				'self'		=> 'SA',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSi', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> '40',	# Payload Length
				'proposals'	=> [		# Proposals
					{	# Proposal Substructure
						'nexttype'		=> '0',		# Next
						'reserved'		=> '0',		# RESERVED
						'proposalLen'		=> '36',	# Proposal Length
						'number'		=> '1',		# Proposal #
						'id'			=> 'ESP',	# Proposal ID
						'spiSize'		=> '4',		# SPI Size
						'transformCount'	=> '3',		# # of Transforms
						'spi'				=> undef,	# SPI
						'transforms'		=> [		# Transforms
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ENCR',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> '3DES',	# Transform ID
								'attributes'	=> [		# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'INTEG',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'HMAC_SHA1_96',	# Transform ID
								'attributes'	=> [		# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '0',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ESN',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'No ESN',	# Transform ID
								'attributes'	=> [		# Transfom Attributes
								]
							}
						]
					}
				]
			},
			{	# Traffic Selector Payload - Initiator
				'self'		=> 'TSi',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSr',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 				'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'	=> '0',		# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',	# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',	# Selector Length
						'sport'		=> '0',		# Start Port
						'eport'		=> '65535',	# End Port
						'saddr'		=> 'read',	# Starting Address
						'eaddr'		=> 'read'	# Ending Address
					}
				]
			},
			{	# Traffic Selector Payload - Responder
				'self'		=> 'TSr',	# *** MUST BE HERE ***

				'nexttype'	=> '0',		# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'		=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'		=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 				'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'	=> '0',		# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',	# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',	# Selector Length
						'sport'		=> '0',		# Start Port
						'eport'		=> '65535',	# End Port
						'saddr'		=> 'read',	# Starting Address
						'eaddr'		=> 'read'	# Ending Address
					}
				]
			}
		]
	}
]; # $tunnel_exp_ike_auth_resp



#----------------------------------------------------------------------#
# (generation) CREATE_CHILD_SA request                                 #
#----------------------------------------------------------------------#
$transport_gen_create_child_sa_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> undef,		# Next Payload
		'major'		=> undef,		# Major Version
		'minor'		=> undef,		# Minor Version
		'exchType'	=> 'CREATE_CHILD_SA',	# Exchange Type
		'reserved1'	=> undef,		# Flags: X(reserved)
		'response'	=> undef,		# Flags: R(esponse)
		'higher'	=> undef,		# Flags: V(ersion)
		'initiator'	=> 'read',		# Flags: I(nitiator)
		'reserved2'	=> undef,		# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrypted Payloads
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'		=> undef,	# Next Payload
		'critical'		=> undef,	# Critical
		'reserved'		=> undef,	# RESERVED
		'length'		=> undef,	# Payload Length
		# 'iv'			=> undef,	# Initialization Vector
		# 'pad'			=> undef,	# Padding
		# 'padlen'		=> undef,	# Pad Length
		# 'checksum'	=> undef,	# Integrity Checksum Data
	},
	{	# Notify Payload
		'self'		=> 'N',						# *** MUST BE HERE ***

		'nexttype'	=> undef,					# Next Payload
		'critical'	=> undef,					# Critical
		'reserved'	=> undef,					# RESERVED
		'length'	=> undef,					# Payload Length
		'id'		=> undef,					# Protocol ID
		'spiSize'	=> undef,					# SPI Size
		'type'		=> 'USE_TRANSPORT_MODE',	# Notify Message Type
		'spi'		=> undef,					# SPI
		'data'		=> undef					# Notification Data
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'			=> undef,		# 0 (last) or 2 (more)
				'reserved'			=> undef,		# RESERVED
				'proposalLen'		=> undef,		# Proposal Length
				'number'			=> undef,		# Proposal #
				'id'				=> 'ESP',		# Protocol ID
				'spiSize'			=> undef,		# SPI Size
				'transformCount'	=> undef,		# # of Transforms
				'spi'				=> 'generate',	# SPI
				'transforms'		=> [			# Transforms
					{
						'nexttype'		=> undef,	# 0 (last) or 3 (more)
						'reserved1'		=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'			=> 'ENCR',	# Transform Type
						'reserved2'		=> undef,	# RESERVED
						'id'			=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'		=> undef,			# 0 (last) or 3 (more)
						'reserved1'		=> undef,			# RESERVED
						'transformLen'	=> undef,			# Transform Length
						'type'			=> 'INTEG',			# Transform Type
						'reserved2'		=> undef,			# RESERVED
						'id'			=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [				# Transform Attributes
						]
					},
					{
						'nexttype'		=> undef,		# 0 (last) or 3 (more)
						'reserved1'		=> undef,		# RESERVED
						'transformLen'	=> undef,		# Transform Length
						'type'			=> 'ESN',		# Transform Type
						'reserved2'		=> undef,		# RESERVED
						'id'			=> 'No ESN',	# Transform ID
						'attributes' => [				# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Nonce Payload
		'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,		# Next Payload
		'critical'	=> undef,		# Critical
		'reserved'	=> undef,		# RESERVED
		'length'	=> undef,		# Payload Length
		'nonce'		=> 'generate'	# Nonce Data
	},
	{	# Traffic Selector - Initiator
		'self'		=> 'TSi',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'		=> '0',					# IP Protocol ID
				'selectorLen'	=> undef,				# Selector Length
				'sport'			=> '0',					# Start Port
				'eport'			=> '65535',				# End Port
				'saddr'			=> 'read',				# Starting Address
				'eaddr'			=> 'read',				# Ending Address
			}
		]
	},
	{	# Traffic Selector - Responder
		'self'		=> 'TSr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'		=> '0',					# IP Protocol ID
				'selectorLen'	=> undef,				# Selector Length
				'sport'			=> '0',					# Start Port
				'eport'			=> '65535',				# End Port
				'saddr'			=> 'read',				# Starting Address
				'eaddr'			=> 'read',				# Ending Address
			}
		]
	}
]; # $transport_gen_create_child_sa_req

$tunnel_gen_create_child_sa_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> undef,		# Next Payload
		'major'		=> undef,		# Major Version
		'minor'		=> undef,		# Minor Version
		'exchType'	=> 'CREATE_CHILD_SA',	# Exchange Type
		'reserved1'	=> undef,		# Flags: X(reserved)
		'response'	=> undef,		# Flags: R(esponse)
		'higher'	=> undef,		# Flags: V(ersion)
		'initiator'	=> 'read',		# Flags: I(nitiator)
		'reserved2'	=> undef,		# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrypted Payloads
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'		=> undef,	# Next Payload
		'critical'		=> undef,	# Critical
		'reserved'		=> undef,	# RESERVED
		'length'		=> undef,	# Payload Length
		# 'iv'			=> undef,	# Initialization Vector
		# 'pad'			=> undef,	# Padding
		# 'padlen'		=> undef,	# Pad Length
		# 'checksum'	=> undef,	# Integrity Checksum Data
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'			=> undef,		# 0 (last) or 2 (more)
				'reserved'			=> undef,		# RESERVED
				'proposalLen'		=> undef,		# Proposal Length
				'number'			=> undef,		# Proposal #
				'id'				=> 'ESP',		# Protocol ID
				'spiSize'			=> undef,		# SPI Size
				'transformCount'	=> undef,		# # of Transforms
				'spi'				=> 'generate',	# SPI
				'transforms'		=> [			# Transforms
					{
						'nexttype'		=> undef,	# 0 (last) or 3 (more)
						'reserved1'		=> undef,	# RESERVED
						'transformLen'	=> undef,	# Transform Length
						'type'			=> 'ENCR',	# Transform Type
						'reserved2'		=> undef,	# RESERVED
						'id'			=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'		=> undef,			# 0 (last) or 3 (more)
						'reserved1'		=> undef,			# RESERVED
						'transformLen'	=> undef,			# Transform Length
						'type'			=> 'INTEG',			# Transform Type
						'reserved2'		=> undef,			# RESERVED
						'id'			=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [				# Transform Attributes
						]
					},
					{
						'nexttype'		=> undef,		# 0 (last) or 3 (more)
						'reserved1'		=> undef,		# RESERVED
						'transformLen'	=> undef,		# Transform Length
						'type'			=> 'ESN',		# Transform Type
						'reserved2'		=> undef,		# RESERVED
						'id'			=> 'No ESN',	# Transform ID
						'attributes' => [				# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Nonce Payload
		'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,		# Next Payload
		'critical'	=> undef,		# Critical
		'reserved'	=> undef,		# RESERVED
		'length'	=> undef,		# Payload Length
		'nonce'		=> 'generate'	# Nonce Data
	},
	{	# Traffic Selector - Initiator
		'self'		=> 'TSi',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'		=> '0',					# IP Protocol ID
				'selectorLen'	=> undef,				# Selector Length
				'sport'			=> '0',					# Start Port
				'eport'			=> '65535',				# End Port
				'saddr'			=> 'read',				# Starting Address
				'eaddr'			=> 'read',				# Ending Address
			}
		]
	},
	{	# Traffic Selector - Responder
		'self'		=> 'TSr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'		=> '0',					# IP Protocol ID
				'selectorLen'	=> undef,				# Selector Length
				'sport'			=> '0',					# Start Port
				'eport'			=> '65535',				# End Port
				'saddr'			=> 'read',				# Starting Address
				'eaddr'			=> 'read',				# Ending Address
			}
		]
	}
]; # $tunnel_gen_create_child_sa_req



#----------------------------------------------------------------------#
# (expectation) CREATE_CHILD_SA request                                #
#----------------------------------------------------------------------#
$transport_exp_create_child_sa_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',	# Initiator's SPI
		'respSPI'	=> 'read',	# Responder's SPI
		'nexttype'	=> 'E',		# Next Payload
		'major'		=> '2',		# Major Version
		'minor'		=> '0',		# Minor Version
		'exchType'	=> 'CREATE_CHILD_SA',	# Exchange Type
		'reserved1'	=> '0',		# Flags: X(reserved)
		'initiator'	=> 'read',	# Flags: I(nitiator)
		'higher'	=> '0',		# Flags: V(ersion)
		'response'	=> '0',		# Flags: R(esponse)
		'reserved2'	=> '0',		# Flags: X(reserved)
		'messID'	=> undef,	# Message ID
		'length'	=> undef	# Length
	},
	{	# Encrypted Payload
		'self'		=> 'E',		# *** MUST BE HERE ***

		'nexttype'	=> '0',		# outer Next Payload
		'innerType'	=> 'N',		# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'enc_paylen'	=> undef,	# Payload Length
		'innerPayloads' => [
			{	# Notify Payload
				'self'		=> 'N',				# *** MUST BE HERE ***

				'nexttype'	=> 'SA', 			# Next Payload
				'critical'	=> '0',				# Critical
				'reserved'	=> '0',				# RESERVED
				'length'	=> '8',				# Payload Length
				'id'		=> '0',				# Protocol ID
				'spiSize'	=> '0',				# SPI Size
				'type'		=> 'USE_TRANSPORT_MODE',	# Notify Type
				'spi'		=> '',				# SPI
				'data'		=> ''				# Notification Data
			},
			{	# Security Association Payload
				'self'		=> 'SA',	# *** MUST BE HERE ***

				'nexttype'	=> 'Ni, Nr', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> '40',	# Payload Length
				'proposals'	=> [ # Proposals
					{	# Proposal Substructure
						'nexttype'	=> '0',		# Next
						'reserved'	=> '0',		# RESERVED
						'proposalLen'	=> '36',	# Proposal Length
						'number'	=> '1',		# Proposal #
						'id'		=> 'ESP',	# Proposal ID
						'spiSize'	=> '4',		# SPI Size
						'transformCount'=> undef,		# # of Transforms
						'spi'		=> undef,	# SPI
						'transforms' => [	# Transforms
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ENCR',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> '3DES',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'INTEG',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'HMAC_SHA1_96',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '0',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ESN',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'No ESN',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
						],
					},
				],
			},
			{	# Nonce Payload
				'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSi',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> [20, 260],	# Payload Length
				'length_comparator'	=> 'range',	# Payload Length
				'nonce'		=> undef,	# Nonce Data
			},
			{	# Traffic Selector Payload - Initiator
				'self'		=> 'TSi',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSr',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',					# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',					# Start Port
						'eport'			=> '65535',				# End Port
						'saddr'			=> 'read',				# Starting Address
						'eaddr'			=> 'read'				# Ending Address
					}
				]
			},
			{	# Traffic Selector Payload - Responder
				'self'		=> 'TSr',	# *** MUST BE HERE ***

				'nexttype'	=> '0',		# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',					# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',					# Start Port
						'eport'			=> '65535',				# End Port
						'saddr'			=> 'read',				# Starting Address
						'eaddr'			=> 'read'				# Ending Address
					}
				]
			}
		],
	},
]; # $transport_exp_create_child_sa_req

$tunnel_exp_create_child_sa_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',	# Initiator's SPI
		'respSPI'	=> 'read',	# Responder's SPI
		'nexttype'	=> 'E',		# Next Payload
		'major'		=> '2',		# Major Version
		'minor'		=> '0',		# Minor Version
		'exchType'	=> 'CREATE_CHILD_SA',	# Exchange Type
		'reserved1'	=> '0',		# Flags: X(reserved)
		'initiator'	=> 'read',	# Flags: I(nitiator)
		'higher'	=> '0',		# Flags: V(ersion)
		'response'	=> '0',		# Flags: R(esponse)
		'reserved2'	=> '0',		# Flags: X(reserved)
		'messID'	=> undef,	# Message ID
		'length'	=> undef	# Length
	},
	{	# Encrypted Payload
		'self'		=> 'E',		# *** MUST BE HERE ***

		'nexttype'	=> '0',		# outer Next Payload
		'innerType'	=> 'SA',	# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'enc_paylen'	=> undef,	# Payload Length
		'innerPayloads' => [
			{	# Security Association Payload
				'self'		=> 'SA',	# *** MUST BE HERE ***

				'nexttype'	=> 'Ni, Nr', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> '40',	# Payload Length
				'proposals'	=> [ # Proposals
					{	# Proposal Substructure
						'nexttype'	=> '0',		# Next
						'reserved'	=> '0',		# RESERVED
						'proposalLen'	=> '36',	# Proposal Length
						'number'	=> '1',		# Proposal #
						'id'		=> 'ESP',	# Proposal ID
						'spiSize'	=> '4',		# SPI Size
						'transformCount'=> undef,		# # of Transforms
						'spi'		=> undef,	# SPI
						'transforms' => [	# Transforms
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ENCR',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> '3DES',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'INTEG',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'HMAC_SHA1_96',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '0',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ESN',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'No ESN',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
						],
					},
				],
			},
			{	# Nonce Payload
				'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSi',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> [20, 260],	# Payload Length
				'length_comparator'	=> 'range',	# Payload Length
				'nonce'		=> undef,	# Nonce Data
			},
			{	# Traffic Selector Payload - Initiator
				'self'		=> 'TSi',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSr',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',					# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',					# Start Port
						'eport'			=> '65535',				# End Port
						'saddr'			=> 'read',				# Starting Address
						'eaddr'			=> 'read'				# Ending Address
					}
				]
			},
			{	# Traffic Selector Payload - Responder
				'self'		=> 'TSr',	# *** MUST BE HERE ***

				'nexttype'	=> '0',		# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',					# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',					# Start Port
						'eport'			=> '65535',				# End Port
						'saddr'			=> 'read',				# Starting Address
						'eaddr'			=> 'read'				# Ending Address
					}
				]
			}
		],
	},
]; # $tunnel_exp_create_child_sa_req



#----------------------------------------------------------------------#
# (generation) CREATE_CHILD_SA response                                #
#----------------------------------------------------------------------#
$transport_gen_create_child_sa_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> undef,		# Next Payload
		'major'		=> undef,		# Major Version
		'minor'		=> undef,		# Minor Version
		'exchType'	=> 'CREATE_CHILD_SA',	# Exchange Type
		'reserved1'	=> undef,		# Flags: X(reserved)
		'response'	=> '1',			# Flags: R(esponse)
		'higher'	=> undef,		# Flags: V(ersion)
		'initiator'	=> 'read',		# Flags: I(nitiator)
		'reserved2'	=> undef,		# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrypted Payloads
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'		=> undef,	# Next Payload
		'critical'		=> undef,	# Critical
		'reserved'		=> undef,	# RESERVED
		'length'		=> undef,	# Payload Length
		# 'iv'			=> undef,	# Initialization Vector
		# 'pad'			=> undef,	# Padding
		# 'padlen'		=> undef,	# Pad Length
		# 'checksum'	=> undef,	# Integrity Checksum Data
	},
	{	# Notify Payload
		'self'		=> 'N',				# *** MUST BE HERE ***

		'nexttype'	=> undef,			# Next Payload
		'critical'	=> undef,			# Critical
		'reserved'	=> undef,			# RESERVED
		'length'	=> undef,			# Payload Length
		'id'		=> undef,			# Protocol ID
		'spiSize'	=> undef,			# SPI Size
		'type'		=> 'USE_TRANSPORT_MODE',	# Notify Message Type
		'spi'		=> undef,			# SPI
		'data'		=> undef			# Notification Data
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'		=> undef,	# 0 (last) or 2 (more)
				'reserved'		=> undef,	# RESERVED
				'proposalLen'		=> undef,	# Proposal Length
				'number'		=> undef,	# Proposal #
				'id'			=> 'ESP',	# Protocol ID
				'spiSize'		=> undef,	# SPI Size
				'transformCount'	=> undef,	# # of Transforms
				'spi'			=> 'generate',	# SPI
				'transforms'		=> [		# Transforms
					{
						'nexttype'		=> undef,	# 0 (last) or 3 (more)
						'reserved1'		=> undef,	# RESERVED
						'transformLen'	=> undef,		# Transform Length
						'type'			=> 'ENCR',	# Transform Type
						'reserved2'		=> undef,	# RESERVED
						'id'			=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'		=> undef,		# 0 (last) or 3 (more)
						'reserved1'		=> undef,		# RESERVED
						'transformLen'	=> undef,			# Transform Length
						'type'			=> 'INTEG',		# Transform Type
						'reserved2'		=> undef,		# RESERVED
						'id'			=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [				# Transform Attributes
						]
					},
					{
						'nexttype'		=> undef,	# 0 (last) or 3 (more)
						'reserved1'		=> undef,	# RESERVED
						'transformLen'	=> undef,		# Transform Length
						'type'			=> 'ESN',	# Transform Type
						'reserved2'		=> undef,	# RESERVED
						'id'			=> 'No ESN',	# Transform ID
						'attributes' => [			# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Nonce Payload
		'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'nonce'		=> 'generate'	# Nonce Data
	},
	{	# Traffic Selector - Initiator
		'self'		=> 'TSi',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'		=> '0',			# IP Protocol ID
				'selectorLen'	=> undef,			# Selector Length
				'sport'			=> '0',			# Start Port
				'eport'			=> '65535',		# End Port
				'saddr'			=> 'read',		# Starting Address
				'eaddr'			=> 'read',		# Ending Address
			}
		]
	},
	{	# Traffic Selector - Responder
		'self'		=> 'TSr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'		=> '0',			# IP Protocol ID
				'selectorLen'	=> undef,			# Selector Length
				'sport'			=> '0',			# Start Port
				'eport'			=> '65535',		# End Port
				'saddr'			=> 'read',		# Starting Address
				'eaddr'			=> 'read',		# Ending Address
			}
		]
	}
]; # $transport_gen_create_child_sa_resp

$tunnel_gen_create_child_sa_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> undef,		# Next Payload
		'major'		=> undef,		# Major Version
		'minor'		=> undef,		# Minor Version
		'exchType'	=> 'CREATE_CHILD_SA',	# Exchange Type
		'reserved1'	=> undef,		# Flags: X(reserved)
		'response'	=> '1',			# Flags: R(esponse)
		'higher'	=> undef,		# Flags: V(ersion)
		'initiator'	=> 'read',		# Flags: I(nitiator)
		'reserved2'	=> undef,		# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrypted Payloads
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'		=> undef,	# Next Payload
		'critical'		=> undef,	# Critical
		'reserved'		=> undef,	# RESERVED
		'length'		=> undef,	# Payload Length
		# 'iv'			=> undef,	# Initialization Vector
		# 'pad'			=> undef,	# Padding
		# 'padlen'		=> undef,	# Pad Length
		# 'checksum'	=> undef,	# Integrity Checksum Data
	},
	{	# Security Association Payload
		'self'		=> 'SA',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'proposals'	=> [		# Proposals
			{	# Proposal Substructure
				'nexttype'		=> undef,	# 0 (last) or 2 (more)
				'reserved'		=> undef,	# RESERVED
				'proposalLen'		=> undef,	# Proposal Length
				'number'		=> undef,	# Proposal #
				'id'			=> 'ESP',	# Protocol ID
				'spiSize'		=> undef,	# SPI Size
				'transformCount'	=> undef,	# # of Transforms
				'spi'			=> 'generate',	# SPI
				'transforms'		=> [		# Transforms
					{
						'nexttype'		=> undef,	# 0 (last) or 3 (more)
						'reserved1'		=> undef,	# RESERVED
						'transformLen'	=> undef,		# Transform Length
						'type'			=> 'ENCR',	# Transform Type
						'reserved2'		=> undef,	# RESERVED
						'id'			=> '3DES',	# Transform ID
						'attributes'	=> [		# Transform Attributes
						]
					},
					{
						'nexttype'		=> undef,		# 0 (last) or 3 (more)
						'reserved1'		=> undef,		# RESERVED
						'transformLen'	=> undef,			# Transform Length
						'type'			=> 'INTEG',		# Transform Type
						'reserved2'		=> undef,		# RESERVED
						'id'			=> 'HMAC_SHA1_96',	# Transform ID
						'attributes'	=> [				# Transform Attributes
						]
					},
					{
						'nexttype'		=> undef,	# 0 (last) or 3 (more)
						'reserved1'		=> undef,	# RESERVED
						'transformLen'	=> undef,		# Transform Length
						'type'			=> 'ESN',	# Transform Type
						'reserved2'		=> undef,	# RESERVED
						'id'			=> 'No ESN',	# Transform ID
						'attributes' => [			# Transform Attributes
						]
					}
				]
			}
		]
	},
	{	# Nonce Payload
		'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'nonce'		=> 'generate'	# Nonce Data
	},
	{	# Traffic Selector - Initiator
		'self'		=> 'TSi',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'		=> '0',			# IP Protocol ID
				'selectorLen'	=> undef,			# Selector Length
				'sport'			=> '0',			# Start Port
				'eport'			=> '65535',		# End Port
				'saddr'			=> 'read',		# Starting Address
				'eaddr'			=> 'read',		# Ending Address
			}
		]
	},
	{	# Traffic Selector - Responder
		'self'		=> 'TSr',	# *** MUST BE HERE ***

		'nexttype'	=> undef,	# Next Payload
		'critical'	=> undef,	# Critical
		'reserved'	=> undef,	# RESERVED
		'length'	=> undef,	# Payload Length
		'count'		=> undef,	# Number of TSs
		'reserved1'	=> undef,	# RESERVED
		'selectors'	=> [		# Traffic Selectors
			{	# Traffic Selector
				'self'		=> 'TS',	# *** MUST BE HERE ***
				# XXX: IPV4
				#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
				'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
			 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
				'protocol'		=> '0',			# IP Protocol ID
				'selectorLen'	=> undef,			# Selector Length
				'sport'			=> '0',			# Start Port
				'eport'			=> '65535',		# End Port
				'saddr'			=> 'read',		# Starting Address
				'eaddr'			=> 'read',		# Ending Address
			}
		]
	}
]; # $tunnel_gen_create_child_sa_resp



#----------------------------------------------------------------------#
# (expectation) CREATE_CHILD_SA response                               #
#----------------------------------------------------------------------#
$transport_exp_create_child_sa_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',	# Initiator's SPI
		'respSPI'	=> 'read',	# Responder's SPI
		'nexttype'	=> 'E',		# Next Payload
		'major'		=> '2',		# Major Version
		'minor'		=> '0',		# Minor Version
		'exchType'	=> 'CREATE_CHILD_SA',	# Exchange Type
		'reserved1'	=> '0',		# Flags: X(reserved)
		'initiator'	=> 'read',	# Flags: I(nitiator)
		'higher'	=> '0',		# Flags: V(ersion)
		'response'	=> '1',		# Flags: R(esponse)
		'reserved2'	=> '0',		# Flags: X(reserved)
		'messID'	=> undef,	# Message ID
		'length'	=> undef	# Length
	},
	{	# Encrypted Payload
		'self'		=> 'E',		# *** MUST BE HERE ***

		'nexttype'	=> '0',		# outer Next Payload
		'innerType'	=> 'N',		# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'enc_paylen'	=> undef,	# Payload Length
		'innerPayloads' => [
			{	# Notify Payload
				'self'		=> 'N',				# *** MUST BE HERE ***

				'nexttype'	=> 'SA', 			# Next Payload
				'critical'	=> '0',				# Critical
				'reserved'	=> '0',				# RESERVED
				'length'	=> '8',				# Payload Length
				'id'		=> '0',				# Protocol ID
				'spiSize'	=> '0',				# SPI Size
				'type'		=> 'USE_TRANSPORT_MODE',	# Notify Type
				'spi'		=> '',				# SPI
				'data'		=> ''				# Notification Data
			},
			{	# Security Association Payload
				'self'		=> 'SA',	# *** MUST BE HERE ***

				'nexttype'	=> 'Ni, Nr', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> '40',	# Payload Length
				'proposals'	=> [ # Proposals
					{	# Proposal Substructure
						'nexttype'	=> '0',		# Next
						'reserved'	=> '0',		# RESERVED
						'proposalLen'	=> '36',	# Proposal Length
						'number'	=> '1',		# Proposal #
						'id'		=> 'ESP',	# Proposal ID
						'spiSize'	=> '4',		# SPI Size
						'transformCount'=> undef,		# # of Transforms
						'spi'		=> undef,	# SPI
						'transforms' => [	# Transforms
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ENCR',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> '3DES',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'INTEG',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'HMAC_SHA1_96',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '0',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ESN',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'No ESN',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
						],
					},
				],
			},
			{	# Nonce Payload
				'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSi',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> [20, 260],	# Payload Length
				'length_comparator'	=> 'range',	# Payload Length
				'nonce'		=> undef,	# Nonce Data
			},
			{	# Traffic Selector Payload - Initiator
				'self'		=> 'TSi',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSr',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',					# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',					# Start Port
						'eport'			=> '65535',				# End Port
						'saddr'			=> 'read',				# Starting Address
						'eaddr'			=> 'read'				# Ending Address
					}
				]
			},
			{	# Traffic Selector Payload - Responder
				'self'		=> 'TSr',	# *** MUST BE HERE ***

				'nexttype'	=> '0',		# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',					# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',					# Start Port
						'eport'			=> '65535',				# End Port
						'saddr'			=> 'read',				# Starting Address
						'eaddr'			=> 'read'				# Ending Address
					}
				]
			}
		],
	},
]; # $transport_exp_create_child_sa_resp

$tunnel_exp_create_child_sa_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',	# Initiator's SPI
		'respSPI'	=> 'read',	# Responder's SPI
		'nexttype'	=> 'E',		# Next Payload
		'major'		=> '2',		# Major Version
		'minor'		=> '0',		# Minor Version
		'exchType'	=> 'CREATE_CHILD_SA',	# Exchange Type
		'reserved1'	=> '0',		# Flags: X(reserved)
		'initiator'	=> 'read',	# Flags: I(nitiator)
		'higher'	=> '0',		# Flags: V(ersion)
		'response'	=> '1',		# Flags: R(esponse)
		'reserved2'	=> '0',		# Flags: X(reserved)
		'messID'	=> undef,	# Message ID
		'length'	=> undef	# Length
	},
	{	# Encrypted Payload
		'self'		=> 'E',		# *** MUST BE HERE ***

		'nexttype'	=> '0',		# outer Next Payload
		'innerType'	=> 'SA',	# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'enc_paylen'	=> undef,	# Payload Length
		'innerPayloads' => [
			{	# Security Association Payload
				'self'		=> 'SA',	# *** MUST BE HERE ***

				'nexttype'	=> 'Ni, Nr', 	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> '40',	# Payload Length
				'proposals'	=> [ # Proposals
					{	# Proposal Substructure
						'nexttype'	=> '0',		# Next
						'reserved'	=> '0',		# RESERVED
						'proposalLen'	=> '36',	# Proposal Length
						'number'	=> '1',		# Proposal #
						'id'		=> 'ESP',	# Proposal ID
						'spiSize'	=> '4',		# SPI Size
						'transformCount'=> undef,		# # of Transforms
						'spi'		=> undef,	# SPI
						'transforms' => [	# Transforms
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ENCR',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> '3DES',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '3',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'INTEG',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'HMAC_SHA1_96',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
							{	# Transform Substructure
								'nexttype'	=> '0',		# Next
								'reserved1'	=> '0',		# RESERVED
								'transformLen'	=> '8',		# Transform Length
								'type'		=> 'ESN',	# Transform Type
								'reserved2'	=> '0',		# RESERVED
								'id'		=> 'No ESN',	# Transform ID
								'attributes'	=> [	# Transfom Attributes
								]
							},
						],
					},
				],
			},
			{	# Nonce Payload
				'self'		=> 'Ni, Nr',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSi',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				'length'	=> [20, 260],	# Payload Length
				'length_comparator'	=> 'range',	# Payload Length
				'nonce'		=> undef,	# Nonce Data
			},
			{	# Traffic Selector Payload - Initiator
				'self'		=> 'TSi',	# *** MUST BE HERE ***

				'nexttype'	=> 'TSr',	# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',					# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',					# Start Port
						'eport'			=> '65535',				# End Port
						'saddr'			=> 'read',				# Starting Address
						'eaddr'			=> 'read'				# Ending Address
					}
				]
			},
			{	# Traffic Selector Payload - Responder
				'self'		=> 'TSr',	# *** MUST BE HERE ***

				'nexttype'	=> '0',		# Next Payload
				'critical'	=> '0',		# Critical
				'reserved'	=> '0',		# RESERVED
				# XXX: IPV4
				#'length'	=> '48',	# Payload Length
				'length'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
							'48' : '24',	# Payload Length
				'count'		=> '1',		# Number of TSs
				'reserved1'	=> '0',		# RESERVED
				'selectors'	=> [		# Traffic Selectors
					{	# Traffic Selector
						'self'		=> 'TS',	# *** MUST BE HERE ***
						# XXX: IPV4
						#'type'			=> 'IPV6_ADDR_RANGE',	# TS Type
						'type'			=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
					 					'IPV6_ADDR_RANGE' : 'IPV4_ADDR_RANGE',	# TS Type
						'protocol'		=> '0',					# IP Protocol ID
						# XXX: IPV4
						#'selectorLen'	=> '40',				# Selector Length
						'selectorLen'	=> (IKEv2::ADDRESS_FAMILY == AF_INET6) ?
									'40' : '16',				# Selector Length
						'sport'			=> '0',					# Start Port
						'eport'			=> '65535',				# End Port
						'saddr'			=> 'read',				# Starting Address
						'eaddr'			=> 'read'				# Ending Address
					}
				]
			}
		],
	},
]; # $tunnel_exp_create_child_sa_resp



#----------------------------------------------------------------------#
# (generation) INFORMATIONAL request                                   #
#----------------------------------------------------------------------#
$default_gen_informational_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> undef,		# Next Payload
		'major'		=> undef,		# Major Version
		'minor'		=> undef,		# Minor Version
		'exchType'	=> 'INFORMATIONAL',	# Exchange Type
		'reserved1'	=> undef,		# Flags: X(reserved)
		'response'	=> undef,		# Flags: R(esponse)
		'higher'	=> undef,		# Flags: V(ersion)
		'initiator'	=> 'read',		# Flags: I(nitiator)
		'reserved2'	=> undef,		# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrypted Payloads
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'		=> undef,	# Next Payload
		'critical'		=> undef,	# Critical
		'reserved'		=> undef,	# RESERVED
		'length'		=> undef,	# Payload Length
		# 'iv'			=> undef,	# Initialization Vector
		# 'pad'			=> undef,	# Padding
		# 'padlen'		=> undef,	# Pad Length
		# 'checksum'	=> undef,	# Integrity Checksum Data
	},
];



#----------------------------------------------------------------------#
# (expectation) INFORMATIONAL request                                  #
#----------------------------------------------------------------------#
$default_exp_informational_req =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',	# Initiator's SPI
		'respSPI'	=> 'read',	# Responder's SPI
		'nexttype'	=> 'E',		# Next Payload
		'major'		=> '2',		# Major Version
		'minor'		=> '0',		# Minor Version
		'exchType'	=> 'INFORMATIONAL',	# Exchange Type
		'reserved1'	=> '0',		# Flags: X(reserved)
		'initiator'	=> 'read',	# Flags: I(nitiator)
		'higher'	=> '0',		# Flags: V(ersion)
		'response'	=> '0',		# Flags: R(esponse)
		'reserved2'	=> '0',		# Flags: X(reserved)
		'messID'	=> undef,	# Message ID
		'length'	=> undef,	# Length
	},
	{	# Encrypted Payload
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'	=> '0',		# outer Next Payload
		'innerType'	=> '0',		# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'enc_paylen'	=> undef,	# Payload Length
		'innerPayloads' => [
		],
	},
];



#----------------------------------------------------------------------#
# (generation) INFORMATIONAL response                                  #
#----------------------------------------------------------------------#
$default_gen_informational_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',		# Initiator's SPI
		'respSPI'	=> 'read',		# Responder's SPI
		'nexttype'	=> undef,		# Next Payload
		'major'		=> undef,		# Major Version
		'minor'		=> undef,		# Minor Version
		'exchType'	=> 'INFORMATIONAL',	# Exchange Type
		'reserved1'	=> undef,		# Flags: X(reserved)
		'response'	=> '1',			# Flags: R(esponse)
		'higher'	=> undef,		# Flags: V(ersion)
		'initiator'	=> 'read',		# Flags: I(nitiator)
		'reserved2'	=> undef,		# Flags: X(reserved)
		'messID'	=> 'read',		# Message ID
		'length'	=> undef		# Length
	},
	{	# Encrypted Payloads
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'		=> undef,	# Next Payload
		'critical'		=> undef,	# Critical
		'reserved'		=> undef,	# RESERVED
		'length'		=> undef,	# Payload Length
		# 'iv'			=> undef,	# Initialization Vector
		# 'pad'			=> undef,	# Padding
		# 'padlen'		=> undef,	# Pad Length
		# 'checksum'	=> undef,	# Integrity Checksum Data
	},
];



#----------------------------------------------------------------------#
# (expectation) INFORMATIONAL response                                 #
#----------------------------------------------------------------------#
$default_exp_informational_resp =
[
	{	# The IKE Header
		'self'		=> 'HDR',		# *** MUST BE HERE ***

		'initSPI'	=> 'read',	# Initiator's SPI
		'respSPI'	=> 'read',	# Responder's SPI
		'nexttype'	=> 'E',		# Next Payload
		'major'		=> '2',		# Major Version
		'minor'		=> '0',		# Minor Version
		'exchType'	=> 'INFORMATIONAL',	# Exchange Type
		'reserved1'	=> '0',		# Flags: X(reserved)
		'initiator'	=> 'read',	# Flags: I(nitiator)
		'higher'	=> '0',		# Flags: V(ersion)
		'response'	=> '1',		# Flags: R(esponse)
		'reserved2'	=> '0',		# Flags: X(reserved)
		'messID'	=> undef,	# Message ID
		'length'	=> undef,	# Length
	},
	{	# Encrypted Payload
		'self'			=> 'E',		# *** MUST BE HERE ***

		'nexttype'	=> '0',		# outer Next Payload
		'innerType'	=> '0',		# Next Payload
		'critical'	=> '0',		# Critical
		'reserved'	=> '0',		# RESERVED
		'enc_paylen'	=> undef,	# Payload Length
		'innerPayloads' => [
		],
	},
];



#--------------------------------------#
# Operation Structures                 #
#--------------------------------------#
# IKE_SA_INIT request
our $operation_ike_sa_init_req = undef;
# IKE_SA_INIT response
our $operation_ike_sa_init_resp = undef;
## operation for SA Proposals in IKE_SA_INIT message
our $operation_ike_sa_init_sa_proposals = undef;

# IKE_AUTH request
our $operation_ike_auth_req = undef;
# IKE_AUTH response
our $operation_ike_auth_resp = undef;
## operation for SA Proposals in IKE_AUTH message
our $operation_ike_auth_sa_proposals = undef;
## operation for Traffic Selectors - Initiator in IKE_AUTH message
our $operation_ike_auth_tsi = undef;
## operation for Traffic Selectors - Responder in IKE_AUTH message
our $operation_ike_auth_tsr = undef;

# CREATE_CHILD_SA response
our $operation_create_child_sa_resp = undef;
## operation for SA Proposals in CREATE_CHILD_SA message
our $operation_create_child_sa_sa_proposals = undef;
## operation for Traffic Selectors - Initiator in CREATE_CHILD_SA message
our $operation_create_child_sa_tsi = undef;
## operation for Traffic Selectors - Responder in CREATE_CHILD_SA message
our $operation_create_child_sa_tsr = undef;

# INFORMATIONAL request
our $operation_informational_req = undef;
#  INFORMATIONAL response
our $operation_informational_resp = undef;

#--------------------------------------#
# Operation Structures Definition      #
#--------------------------------------#
## operation for SA Proposals in IKE_SA_INIT message
$operation_ike_sa_init_sa_proposals = {
	'operation' => 'comb',
	'array' => [
		{	# proposals
			'transforms'	=> {
				'operation'	=> 'comb',
				'array'	=> [	# transforms
					{
						'type'	=> 'ENCR',
						'id'	=> '3DES',
						'attributes'	=> {
							'operation'	=> 'comb',
							'array'	=> [
							]
						}
					},
					{
						'type' => 'PRF',
						'id' => 'HMAC_SHA1',
						'attributes' => {
							'operation'	=> 'comb',
							'array'	=> [
							]
						}
					},
					{
						'type'	=> 'INTEG',
						'id'	=> 'HMAC_SHA1_96',
						'attributes'	=> {
							'operation'	=> 'comb',
							'array'	=> [
							]
						}
					},
					{
						'type'	=> 'D-H',
						'id'	=> '1024 MODP Group',
						'attributes'	=> {
							'operation'	=> 'comb',
							'array'	=> [
							]
						}
					}
				]
			}
		}
	]
};

## operation for SA Proposals in IKE_AUTH message
$operation_ike_auth_sa_proposals = {
	operation => 'comb',
	array => [
		{	# proposals
			id => 'ESP',
			transforms =>
			{
				operation => 'comb',
				array => [	# transforms
					{
						type => 'ENCR',
						id => '3DES',
						attributes =>
						{
							operation => 'comb',
							array => [ ],
						}
					},
					{
						type => 'INTEG',
						id => 'HMAC_SHA1_96',
						attributes =>
						{
							operation => 'comb',
							array => [ ]
						}
					},
					{
						type => 'ESN',
						id => 'No ESN',
						attributes =>
						{
							operation => 'comb',
							array => [ ]
						}
					}
				]
			}
		},
	]
};

## operation for Traffic Selectors - Initiator in IKE_AUTH message
$operation_ike_auth_tsi = { # TSi
	operation => 'comb', # 'comb', #
};

## operation for Traffic Selectors - Responder in IKE_AUTH message
$operation_ike_auth_tsr = { # TSr
	operation => 'comb', # 'comb', #
};

## operation for SA Proposals in CREATE_CHILD_SA message
$operation_create_child_sa_sa_proposals = {
	operation => 'comb',
	array => [
		{	# proposals
			id => 'ESP',
			transforms =>
			{
				operation => 'comb',
				array => [	# transforms
					{
						type => 'ENCR',
						id => '3DES',
						attributes =>
						{
							operation => 'comb',
							array => [ ],
						}
					},
					{
						type => 'INTEG',
						id => 'HMAC_SHA1_96',
						attributes =>
						{
							operation => 'comb',
							array => [ ]
						}
					},
					{
						type => 'ESN',
						id => 'No ESN',
						attributes =>
						{
							operation => 'comb',
							array => [ ]
						}
					}
				]
			}
		},
	]
};

## operation for Traffic Selectors - Initiator in CREATE_CHILD_SA message
$operation_create_child_sa_tsi = { # TSi
	operation => 'comb', # 'comb', #
};

## operation for Traffic Selectors - Responder in CREATE_CHILD_SA message
$operation_create_child_sa_tsr = { # TSr
	operation => 'comb', # 'comb', #
};


## operation structure for IKE_SA_INIT request
our $operation_ike_sa_init_req = {
	'common_remote_index'	=> {
		SA => $operation_ike_sa_init_sa_proposals,
	}
};

## operation structure for IKE_SA_INIT response
our $operation_ike_sa_init_resp = {
	'common_remote_index'	=> {
		SA => $operation_ike_sa_init_sa_proposals,
	}
};

## operation structure for IKE_AUTH request
our $operation_ike_auth_req = {
	'common_remote_index'	=> {
		SA => $operation_ike_auth_sa_proposals,
		TSi => $operation_ike_auth_tsi,
		TSr => $operation_ike_auth_tsr,
	}
};

## operation structure for IKE_AUTH response
our $operation_ike_auth_resp = {
	'common_remote_index'	=> {
		SA => $operation_ike_auth_sa_proposals,
		TSi => $operation_ike_auth_tsi,
		TSr => $operation_ike_auth_tsr,
	}
};

## operation structure for CREATE_CHILD_SA request
our $operation_create_child_sa_req = {
	'common_remote_index'	=> {
		SA => $operation_create_child_sa_sa_proposals,
		TSi => $operation_create_child_sa_tsi,
		TSr => $operation_create_child_sa_tsr,
	}
};

## operation structure for CREATE_CHILD_SA response
our $operation_create_child_sa_resp = {
	'common_remote_index'	=> {
		SA => $operation_create_child_sa_sa_proposals,
		TSi => $operation_create_child_sa_tsi,
		TSr => $operation_create_child_sa_tsr,
	}
};

## operation structure for INFORMATIONAL request
our $operation_informational_req = {
	'common_remote_index'	=> {
	}
};

## operation structure for INFORMATIONAL response
our $operation_informational_resp = {
	'common_remote_index'	=> {
	}
};

