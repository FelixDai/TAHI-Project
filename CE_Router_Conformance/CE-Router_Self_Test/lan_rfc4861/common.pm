#!/usr/bin/perl -w
#
# Copyright (C) 2013, 2014
# Chunghwa Telecommunication Labratories (CHT-TL)
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
# $CHT-TL: common.pm,v 1.1 2014/05/19 weifen Exp $
#
########################################################################

package common;

use Exporter;
use V6evalTool;
require './config.pl';

BEGIN {
	$V6evalTool::TestVersion	= '$Name: CE-Router_Self_Test_1_0_5 $';
}

END   {}

@ISA = qw(Exporter);

@EXPORT = qw(
	$wait_rebootcmd
	$sleep_after_reboot
	%pktdesc
	%tn2_mcast_nd_offlink
	%tn2_mcast_nd_onlink
	%tn2_mcast_nd_onlinkX
	%tn2_mcast_nd_common
	%tr1_mcast_nd_common
	%tr2_mcast_nd_common
	%tr3_mcast_nd_common
	%tn2_ucast_nd_common
	%tr1_ucast_nd_common
	%tr2_ucast_nd_common
	%tn2_ucast_nd_diff
	%tr1_ucast_nd_diff
	%tr2_ucast_nd_diff
	$true
	$false
	$Link0
	$Link1
	$TimeOut
	$RETRANS_TIMER
	$DELAY_FIRST_PROBE_TIME
	$MAX_UNICAST_SOLICIT
	$MAX_MULTICAST_SOLICIT
	$MAX_INITIAL_RTR_ADVERT_INTERVAL
	$MAX_INITIAL_RTR_ADVERTISEMENTS
	$MAX_RA_DELAY_TIME
	$MIN_DELAY_BETWEEN_RAS
	$MAX_FINAL_RTR_ADVERTISEMENTS
	$MAX_RTR_SOLICITATIONS
	$RTR_SOLICITATION_INTERVAL
	$MAX_RTR_SOLICITATION_DELAY
	$REACHABLE_TIME
	$MAX_RANDOM_FACTOR
	$min_MaxRtrAdvInterval
	$max_MaxRtrAdvInterval
	$min_MinRtrAdvInterval
	$max_MinRtrAdvInterval
	$min_AdvLinkMTU
	$max_AdvLinkMTU
	$min_AdvReachableTime
	$max_AdvReachableTime
	$min_AdvRetransTimer
	$max_AdvRetransTimer
	$min_AdvCurHopLimit
	$max_AdvCurHopLimit
	$min_AdvDefaultLifetime
	$max_AdvDefaultLifetime
	$min_AdvValidLifetime
	$max_AdvValidLifetime
	$min_AdvPreferredLifetime
	$max_AdvPreferredLifetime
	ignoreDAD
	$nut_rtime
	$nut_chlim
	$tr1_default
	$tr1_prefix
	$tr1_change_param
	$tr2_change_param
	$tr3_change_param
	$tr1_force
	$tr2_force
	$tr3_force
	$force_reboot
	$tr1_cache
	$tn2_offlink_cache
	$tn2_onlink_cache
	$tn2_onlink_cacheX
	$tr2_default
	$tr2_prefix
	$tn2_cache
	$tn2_cache_link1
	$tr2_cache
	$tr3_default
	$tr3_prefix
	$tr3_cache
	$rut_rtadvd
	$rut_ipv6_forwarding_disable
	$rut_rtadvd_param_change
	$use_slave_interface
	tn2_none_to_incomplete
	tr1_none_to_incomplete
	tr2_none_to_incomplete
	tn2_none_to_reachable
	tr1_none_to_reachable
	tr2_none_to_reachable
	tn2_none_to_stale
	tr1_none_to_stale
	tr2_none_to_stale
	tn2_none_to_probe
	tr1_none_to_probe
	is_tn2_incomplete
	is_tr2_incomplete
	is_tn2_stale
	is_tr1_stale
	is_tr2_stale
	is_tn2_stale_diff
	is_tr1_stale_diff
	is_tr2_stale_diff
	is_tn2_reachable
	is_tn2_probe
	stopToRtAdv
	startIPv6forwarding
	register
);

push(@EXPORT, sort(@V6evalTool::EXPORT));



#------------------------------#
# global constants             #
#------------------------------#
$true					= 1;
$false					= 0;
$Link0					= 'Link0';
$Link1					= 'Link1';
$RETRANS_TIMER				= 1;
$MAX_RTR_SOLICITATION_DELAY		= 1;
$DELAY_FIRST_PROBE_TIME			= 5;
$MAX_MULTICAST_SOLICIT			= 3;
$MAX_UNICAST_SOLICIT			= 3;
$DupAddrDetectTransmits			= 1;
$MAX_INITIAL_RTR_ADVERT_INTERVAL	= 16;
$MAX_INITIAL_RTR_ADVERTISEMENTS		= 3;
$MAX_RA_DELAY_TIME			= 0.5;
$MIN_DELAY_BETWEEN_RAS			= 3;
$MAX_FINAL_RTR_ADVERTISEMENTS		= 3;
$MAX_RTR_SOLICITATIONS			= 3;
$RTR_SOLICITATION_INTERVAL		= 4;
$REACHABLE_TIME				= 30;
$MAX_RANDOM_FACTOR			= 1.5;

%tr1_mcast_nd_common	= (
	'tr1_mcast_ns_linklocal_common'	=> 'tr1_na_linklocal_common',
	'tr1_mcast_ns_global_common'	=> 'tr1_na_global_common',
);

%tn2_mcast_nd_common	= (
	'tn2_mcast_ns_linklocal_common'	=> 'tn2_na_linklocal_common',
	'tn2_mcast_ns_global_common'	=> 'tn2_na_global_common',
);

%tr2_mcast_nd_common	= (
	'tr2_mcast_ns_linklocal_common'	=> 'tr2_na_linklocal_common',
	'tr2_mcast_ns_global_common'	=> 'tr2_na_global_common',
);

%tr3_mcast_nd_common	= (
	'tr3_mcast_ns_linklocal_common'	=> 'tr3_na_linklocal_common',
	'tr3_mcast_ns_global_common'	=> 'tr3_na_global_common',
);

%tr1_ucast_nd_common	= (
	'tr1_ucast_ns_linklocal'	=> 'tr1_na_linklocal_common',
	'tr1_ucast_ns_linklocal_sll'	=> 'tr1_na_linklocal_common',
	'tr1_ucast_ns_global'		=> 'tr1_na_global_common',
	'tr1_ucast_ns_global_sll'	=> 'tr1_na_global_common',
);

%tn2_ucast_nd_common	= (
	'tn2_ucast_ns_linklocal'	=> 'tn2_na_linklocal_common',
	'tn2_ucast_ns_linklocal_sll'	=> 'tn2_na_linklocal_common',
	'tn2_ucast_ns_global'		=> 'tn2_na_global_common',
	'tn2_ucast_ns_global_sll'	=> 'tn2_na_global_common',
);

%tr2_ucast_nd_common	= (
	'tr2_ucast_ns_linklocal'	=> 'tr2_na_linklocal_common',
	'tr2_ucast_ns_linklocal_sll'	=> 'tr2_na_linklocal_common',
	'tr2_ucast_ns_global'		=> 'tr2_na_global_common',
	'tr2_ucast_ns_global_sll'	=> 'tr2_na_global_common',
);

%tn2_ucast_nd_diff	= (
	'tn2_ucast_ns_linklocal_diff'		=> 'tn2_na_linklocal_diff',
	'tn2_ucast_ns_linklocal_sll_diff'	=> 'tn2_na_linklocal_diff',
	'tn2_ucast_ns_global_diff'		=> 'tn2_na_global_diff',
	'tn2_ucast_ns_global_sll_diff'		=> 'tn2_na_global_diff',
);

%tr1_ucast_nd_diff	= (
	'tr1_ucast_ns_linklocal_diff'		=> 'tr1_na_linklocal_diff',
	'tr1_ucast_ns_linklocal_sll_diff'	=> 'tr1_na_linklocal_diff',
	'tr1_ucast_ns_global_diff'		=> 'tr1_na_global_diff',
	'tr1_ucast_ns_global_sll_diff'		=> 'tr1_na_global_diff',
);

%tr2_ucast_nd_diff	= (
	'tr2_ucast_ns_linklocal_diff'		=> 'tr2_na_linklocal_diff',
	'tr2_ucast_ns_linklocal_sll_diff'	=> 'tr2_na_linklocal_diff',
	'tr2_ucast_ns_global_diff'		=> 'tr2_na_linklocal_diff',
	'tr2_ucast_ns_global_sll_diff'		=> 'tr2_na_linklocal_diff',
);

%tn2_mcast_nd_offlink	= (
	'tn2_mcast_ns_linklocal_offlink'	=> 'tn2_na_linklocal_offlink',
	'tn2_mcast_ns_global_offlink'		=> 'tn2_na_global_offlink',
);

%tn2_mcast_nd_onlink	= (
	'tn2_mcast_ns_linklocal_onlink'	=> 'tn2_na_linklocal_onlink',
	'tn2_mcast_ns_global_onlink'	=> 'tn2_na_global_onlink',
);

%tn2_mcast_nd_onlinkX	= (
	'tn2_mcast_ns_linklocal_onlinkX'	=> 'tn2_na_linklocal_onlinkX',
	'tn2_mcast_ns_global_onlinkX'		=> 'tn2_na_global_onlinkX',
);


#------------------------------#
# global variables             #
#------------------------------#
$TimeOut			= $RETRANS_TIMER + 1;
$master_interface		= $Link0;
$slave_interface		= $Link1;

$nut_rtime			= $false;
$nut_chlim			= $false;
$tr1_default			= $false;
$tr1_prefix			= $false;
$tr1_change_param		= $false;
$tr2_change_param		= $false;
$tr3_change_param		= $false;
$tr1_force			= $false;
$tr2_force			= $false;
$tr3_force			= $false;
$force_reboot			= $false;
$tr1_cache			= $false;
$tn2_cache			= $false;
$tn2_cache_link1		= $false;
$tn2_offlink_cache		= $false;
$tn2_onlink_cache		= $false;
$tn2_onlink_cacheX		= $false;
$tr2_default			= $false;
$tr2_prefix			= $false;
$tr2_cache			= $false;
$tr3_default			= $false;
$tr3_prefix			= $false;
$tr3_cache			= $false;
$rut_rtadvd			= $false;
$rut_ipv6_forwarding_disable	= $false;
$rut_rtadvd_param_change	= $false;
$use_slave_interface		= $false;



%pktdesc        = (
	'tn2_na_linklocal_diff'
		=> '    Send NA (RSO) w/ TLL (diff): '.
			'TN2 (link-local) -&gt; NUT (link-local)',

	'tn2_na_global_diff'
		=> '    Send NA (RSO) w/ TLL (diff): '.
			'TN2 (link-local) -&gt; NUT (global)',

	'tn2_ucast_ns_linklocal_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TN2 (link-local)',

	'tn2_ucast_ns_global_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TN2 (link-local)',

	'tn2_ucast_ns_linklocal_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TN2 (link-local)',

	'tn2_ucast_ns_global_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TN2 (link-local)',

	'tn2_ereq_diff'
		=> '    Send Echo Request: '.
			'TN2 (link-local) -&gt; NUT (link-local)',

	'tn2_erep_diff'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN2 (link-local)',

	'tr1_ra_common'
		=> '    Send RA w/o SLL: '.
			'TR1 (link-local) -&gt; all-nodes multicast address',

	'ra_2_2_13_A'
		=> '    Send RA (rtime=600000) w/o SLL: '.
			'TR1 (link-local) -&gt; all-nodes multicast address',

	'tr1_mcast_ns_linklocal_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; '.
			'TR1 (link-local) solicited-node multicast address',

	'tr1_na_linklocal_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR1 (link-local) -&gt; NUT (link-local)',

	'tr1_mcast_ns_global_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; '.
			'TR1 (link-local) solicited-node multicast address',

	'tr1_na_global_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR1 (link-local) -&gt; NUT (global)',

	'tr1_ereq_common'
		=> '    Send Echo Request: '.
			'TR1 (link-local) -&gt; NUT (link-local)',

	'tn2_erep_common'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN2 (link-local)',

	'tr1_erep_common'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr1_ra_cleanup'
		=> '    Send RA (rltime=0, vltime=0, pltime=0) w/o SLL: '.
			'TR1 (link-local) -&gt; all-nodes multicast address',

	'tr1_ra_force_cleanup'
		=> '    Send RA (rltime=0, rtime=30000, retrans=1000, '.
			'vltime=0, pltime=0) w/o SLL: '.
			'TR1 (link-local) -&gt; all-nodes multicast address',

	'tr1_na_cleanup'
		=> '    Send NA (RsO) w/ TLL (diff): '.
			'TR1 (link-local) -&gt; all-nodes multicast address',

	'tr1_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TR1 (link-local) -&gt; NUT (link-local)',

	'tr1_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr2_ra_common'
		=> '    Send RA w/o SLL: '.
			'TR2 (link-local) -&gt; all-nodes multicast address',

	'tr3_ra_common'
		=> '    Send RA w/o SLL: '.
			'TR3 (link-local) -&gt; all-nodes multicast address',

	'tr2_ra_common_sll'
		=> '    Send RA w/ SLL: '.
			'TR2 (link-local) -&gt; all-nodes multicast address',

	'tr2_mcast_ns_linklocal_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; '.
			'TR2 (link-local) solicited-node multicast address',

	'tn2_mcast_ns_linklocal_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; '.
			'TN2 (link-local) solicited-node multicast address',

	'tr2_na_linklocal_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR2 (link-local) -&gt; NUT (link-local)',

	'tr3_na_linklocal_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR3 (link-local) -&gt; NUT (link-local)',

	'tn2_na_linklocal_common'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN2 (link-local) -&gt; NUT (link-local)',

	'tr1_na_linklocal_diff'
		=> '    Send NA (RSO) w/ TLL (diff): '.
			'TR1 (link-local) -&gt; NUT (link-local)',

	'tr1_na_global_diff'
		=> '    Send NA (RSO) w/ TLL (diff): '.
			'TR1 (link-local) -&gt; NUT (global)',

	'tr2_na_linklocal_diff'
		=> '    Send NA (RSO) w/ TLL (diff): '.
			'TR2 (link-local) -&gt; NUT (link-local)',

	'tr2_na_global_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR2 (link-local) -&gt; NUT (global)',

	'tr3_na_global_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR3 (link-local) -&gt; NUT (global)',

	'tn2_na_global_common'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN2 (link-local) -&gt; NUT (global)',

	'tr2_mcast_ns_global_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; '.
			'TR2 (link-local) solicited-node multicast address',

	'tn2_mcast_ns_global_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; '.
			'TN2 (link-local) solicited-node multicast address',

	'tr1_ucast_ns_linklocal'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr1_ucast_ns_global'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TR1 (link-local)',

	'tn2_ucast_ns_linklocal'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TN2 (link-local)',

	'tn2_ucast_ns_global'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TN2 (link-local)',

	'tn2_ucast_ns_linklocal_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TN2 (link-local)',

	'tn2_ucast_ns_global_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TN2 (link-local)',

	'tr2_ucast_ns_linklocal'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr2_ucast_ns_global'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TR2 (link-local)',

	'tr1_ucast_ns_linklocal_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr1_ucast_ns_global_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TR1 (link-local)',

	'tr2_ucast_ns_linklocal_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr2_ucast_ns_global_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TR2 (link-local)',

	'tr1_ucast_ns_linklocal_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr1_ucast_ns_global_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TR1 (link-local)',

	'tr2_ucast_ns_linklocal_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr2_ucast_ns_global_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TR2 (link-local)',

	'tr1_ucast_ns_linklocal_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr1_ucast_ns_global_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TR1 (link-local)',

	'tr2_ucast_ns_linklocal_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr2_ucast_ns_global_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TR2 (link-local)',

	'tr2_ra_cleanup'
		=> '    Send RA (rltime=0, vltime=0, pltime=0) w/o SLL: '.
			'TR2 (link-local) -&gt; all-nodes multicast address',

	'tr2_ra_force_cleanup'
		=> '    Send RA (rltime=0, rtime=30000, retrans=1000, '.
			'vltime=0, pltime=0) w/o SLL: '.
			'TR2 (link-local) -&gt; all-nodes multicast address',

	'tr3_ra_force_cleanup'
		=> '    Send RA (rltime=0, rtime=30000, retrans=1000, '.
			'vltime=0, pltime=0) w/o SLL: '.
			'TR3 (link-local) -&gt; all-nodes multicast address',

	'tr2_na_cleanup'
		=> '    Send NA (RsO) w/ TLL (diff): '.
			'TR2 (link-local) -&gt; all-nodes multicast address',

	'tn2_ereq_common'
		=> '    Send Echo Request: '.
			'TN2 (link-local) -&gt; NUT (link-local)',

	'tr2_ereq_common'
		=> '    Send Echo Request: '.
			'TR2 (link-local) -&gt; NUT (link-local)',

	'tr3_ereq_common'
		=> '    Send Echo Request: '.
			'TR3 (link-local) -&gt; NUT (link-local)',

	'tr2_erep_common'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr3_erep_common'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR3 (link-local)',

	'tr1_erep_diff'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr2_erep_diff'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr2_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TR2 (link-local) -&gt; NUT (link-local)',

	'tr2_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr3_ra_common_sll'
		=> '    Send RA w/ SLL: '.
			'TR3 (link-local) -&gt; all-nodes multicast address',

	'tr3_ra_cleanup'
		=> '    Send RA (rltime=0, vltime=0, pltime=0) w/o SLL: '.
			'TR3 (link-local) -&gt; all-nodes multicast address',

	'tr3_mcast_ns_linklocal_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; '.
			'TR3 (link-local) solicited-node multicast address',

	'tr3_mcast_ns_global_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; '.
			'TR3 (link-local) solicited-node multicast address',

	'tr3_na_cleanup'
		=> '    Send NA (RsO) w/ TLL (diff): '.
			'TR3 (link-local) -&gt; all-nodes multicast address',

	'tr3_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TR3 (link-local) -&gt; NUT (link-local)',

	'tr3_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR3 (link-local)',

	'tn2_mcast_ns_linklocal_offlink'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; '.
			'TN2 (off-link global) '.
			'solicited-node multicast address',

	'tn2_na_linklocal_offlink'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN2 (off-link global) -&gt; NUT (link-local)',

	'tn2_mcast_ns_global_offlink'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; '.
			'TN2 (off-link global) '.
			'solicited-node multicast address',

	'tn2_na_global_offlink'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN2 (off-link global) -&gt; NUT (global)',

	'tn2_offlink_na_cleanup'
		=> '    Send NA (rsO) w/ TLL (diff): '.
			'TN2 (link-local) -&gt; all-nodes multicast address',

	'tn2_offlink_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TN2 (off-link global) -&gt; NUT (link-local)',

	'tn2_offlink_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN2 (off-link global)',

	'tn2_mcast_ns_linklocal_onlink'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TN2 (global) '.
			'solicited-node multicast address',

	'tn2_mcast_ns_linklocal_onlinkX'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TN2 (global) '.
			'solicited-node multicast address',

	'tn2_na_linklocal_onlink'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN2 (global) -&gt; NUT (link-local)',

	'tn2_na_linklocal_onlinkX'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN2 (global) -&gt; NUT (link-local)',

	'tn2_mcast_ns_global_onlink'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TN2 (global) '.
			'solicited-node multicast address',

	'tn2_mcast_ns_global_onlinkX'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TN2 (global) '.
			'solicited-node multicast address',

	'tn2_na_global_onlink'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN2 (global) -&gt; NUT (global)',

	'tn2_na_global_onlinkX'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN2 (global) -&gt; NUT (global)',

	'tn2_onlink_na_cleanup'
		=> '    Send NA (rsO) w/ TLL (diff): '.
			'TN2 (link-local) -&gt; all-nodes multicast address',

	'tn2_onlink_na_cleanupX'
		=> '    Send NA (rsO) w/ TLL (diff): '.
			'TN2 (link-local) -&gt; all-nodes multicast address',

	'tn2_onlink_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TN2 (global) -&gt; NUT (link-local)',

	'tn2_onlink_ereq_cleanupX'
		=> '    Send Echo Request: '.
			'TN2 (global) -&gt; NUT (link-local)',

	'tn2_onlink_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN2 (global)',

	'tn2_onlink_erep_cleanupX'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN2 (global)',

	'tn2_na_cleanup'
		=> '    Send NA (rsO) w/ TLL (diff): '.
			'TN2 (link-local) -&gt; all-nodes multicast address',

	'tn2_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TN2 (link-local) -&gt; NUT (link-local)',

	'tn2_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN2 (link-local)',
);


#------------------------------#
# ignoreDAD()                  #
#------------------------------#
sub
ignoreDAD($)
{
	my ($Link) = @_;

	vRecv($Link,
		$MAX_RTR_SOLICITATION_DELAY +
			$TimeOut * $DupAddrDetectTransmits,
		0, 0);

	return;
}

#------------------------------#
# tn2_none_to_incomplete()     # 
#------------------------------#
sub
tn2_none_to_incomplete($)
{
	my ($Link) = @_;

	my @frames	= sort(keys(%tn2_mcast_nd_common));

	vSend($Link, 'tn2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return($false);
}



#------------------------------#
# tr1_none_to_incomplete()     # 
#------------------------------#
sub
tr1_none_to_incomplete($)
{
	my ($Link) = @_;

	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return($false);
}



#------------------------------#
# tr2_none_to_incomplete()     # 
#------------------------------#
sub
tr2_none_to_incomplete($)
{
	my ($Link) = @_;

	my @frames	= sort(keys(%tr2_mcast_nd_common));

	vSend($Link, 'tr2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return($false);
}



#------------------------------#
# tn2_none_to_reachable()      # 
#------------------------------#
sub
tn2_none_to_reachable($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tn2_mcast_nd_common));

	vSend($Link, 'tn2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tn2_mcast_nd_common{$frame});
			$tn2_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn2_erep_common');
	unless($ret{'recvFrame'} eq 'tn2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# tr1_none_to_reachable()      # 
#------------------------------#
sub
tr1_none_to_reachable($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# tr2_none_to_reachable()      # 
#------------------------------#
sub
tr2_none_to_reachable($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_mcast_nd_common));

	vSend($Link, 'tr2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr2_mcast_nd_common{$frame});
			$tr2_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# tr1_none_to_probe()          # 
#------------------------------#
sub
tr1_none_to_probe($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR, 0, 0);

	vSend($Link, 'tr1_ereq_common');
	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	@frames	= sort(keys(%tr1_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>'.
		'Could\'t observe NS'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# tn2_none_to_probe()          # 
#------------------------------#
sub
tn2_none_to_probe($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tn2_mcast_nd_common));

	vSend($Link, 'tn2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tn2_mcast_nd_common{$frame});
			$tn2_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn2_erep_common');
	unless($ret{'recvFrame'} eq 'tn2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR, 0, 0);

	vSend($Link, 'tn2_ereq_common');
	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn2_erep_common');
	unless($ret{'recvFrame'} eq 'tn2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	@frames	= sort(keys(%tn2_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>'.
		'Could\'t observe NS'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# tr1_none_to_stale()          # 
#------------------------------#
sub
tr1_none_to_stale($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR, 0, 0);

	return($true);
}



#------------------------------#
# tr2_none_to_stale()          # 
#------------------------------#
sub
tr2_none_to_stale($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_mcast_nd_common));

	vSend($Link, 'tr2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr2_mcast_nd_common{$frame});
			$tr2_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR, 0, 0);

	return($true);
}



#------------------------------#
# tn2_none_to_stale()          # 
#------------------------------#
sub
tn2_none_to_stale($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tn2_mcast_nd_common));

	vSend($Link, 'tn2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tn2_mcast_nd_common{$frame});
			$tn2_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn2_erep_common');
	unless($ret{'recvFrame'} eq 'tn2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR, 0, 0);

	return($true);
}



#------------------------------#
# is_tn2_incomplete()          #
#------------------------------#
sub
is_tn2_incomplete($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tn2_mcast_nd_common));

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
		0, 0);

	$tn2_cache = $false;

	return($true);
}



#------------------------------#
# is_tr2_incomplete()          #
#------------------------------#
sub
is_tr2_incomplete($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_mcast_nd_common));

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
		0, 0);

	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# is_tn2_stale()               #
#------------------------------#
sub
is_tn2_stale($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn2_erep_common');
	unless($ret{'recvFrame'} eq 'tn2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tn2_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tn2_cache = $false;

	return($true);
}



#------------------------------#
# is_tr1_stale()               #
#------------------------------#
sub
is_tr1_stale($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tr1_cache = $false;

	return($true);
}



#------------------------------#
# is_tr2_stale()               #
#------------------------------#
sub
is_tr2_stale($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# is_tn2_stale_diff()          #
#------------------------------#
sub
is_tn2_stale_diff($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn2_erep_diff');
	unless($ret{'recvFrame'} eq 'tn2_erep_diff') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tn2_ucast_nd_diff));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tn2_cache = $false;

	return($true);
}



#------------------------------#
# is_tr1_stale_diff()          #
#------------------------------#
sub
is_tr1_stale_diff($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_diff');
	unless($ret{'recvFrame'} eq 'tr1_erep_diff') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_ucast_nd_diff));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tr1_cache = $false;

	return($true);
}



#------------------------------#
# is_tr2_stale_diff()          #
#------------------------------#
sub
is_tr2_stale_diff($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_diff');
	unless($ret{'recvFrame'} eq 'tr2_erep_diff') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_ucast_nd_diff));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# is_tn2_reachable()           #
#------------------------------#
sub
is_tn2_reachable($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn2_erep_common');
	unless($ret{'recvFrame'} eq 'tn2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tn2_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		return($true);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tn2_cache = $false;

	vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'observed NS</B></FONT><BR>');

	return($false);
}



#------------------------------#
# is_tn2_probe()               #
#------------------------------#
sub
is_tn2_probe($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tn2_ucast_nd_common));

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tn2_cache = $false;

	return($true);
}



#------------------------------#
# stopToRtAdv                  #
#------------------------------#
sub
stopToRtAdv($)
{
	my ($Link) = @_;

	if(vRemote('racontrol.rmt', 'mode=stop')) {
		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t stop to send RA</B></FONT><BR>');

		exitFail($Link);
		#NOTREACHED
	}

	vRecv($Link,
		$MAX_INITIAL_RTR_ADVERT_INTERVAL *
			$MAX_INITIAL_RTR_ADVERTISEMENTS +
			$MIN_DELAY_BETWEEN_RAS + 1,
		0, 0);

	$rut_rtadvd = $false;

	return($true);
}



#------------------------------#
# startIPv6forwarding          #
#------------------------------#
sub
startIPv6forwarding($)
{
	my ($Link) = @_;

	if(vRemote('sysctl.rmt',
		'name=net.inet6.ip6.forwarding',
		'value=1')) {

		vLogHTML('<FONT COLOR="#FF0000"><B>sysctl.rmt: '.
			'Could\'t set kernel state</B></FONT><BR>');

		exitFail($Link);
		#NOTREACHED
	}

	return($true);
}



#------------------------------#
# register                     #
#------------------------------#
sub
register($$)
{
	my ($master, $slave) = @_;

	$master_interface	= $master;
	$slave_interface	= $slave;

	vCapture($master_interface);
	vCapture($slave_interface);

	$use_slave_interface = $true;

	return($true);
}



1;
