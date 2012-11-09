#!/usr/bin/perl
# 
# Copyright (C) IPv6 Promotion Council, NTT Advanced Technology Corporation
# (NTT-AT), Yokogwa Electoric Corporation and YASKAWA INFORMATION SYSTEMS
# Corporation All rights reserved.
# 
# Redistribution and use of this software in source and binary forms, with
# or without modification, are permitted provided that the following
# conditions and disclaimer are agreed and accepted by the user:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# 
# 3. Neither the names of the copyrighters, the name of the project which
# is related to this software (hereinafter referred to as "project") nor
# the names of the contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
# 
# 4. No merchantable use may be permitted without prior written
# notification to the copyrighters. However, using this software for the
# purpose of testing or evaluating any products including merchantable
# products may be permitted without any notification to the copyrighters.
# 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING
# BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE
# COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT,STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
# THE POSSIBILITY OF SUCH DAMAGE.
# 
###############################################################################
# PACKAGE NAME
package MLDv2L;

# EXPORT PACKAGE
use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	$DEBUG
	$RES_OK
	$RES_NG
	$RES_WAR

	$CONF_TXT_PATH
	$CONF_DEF_PATH
	%CONF_DATA
	%CONF_ATTR
	@CONF_FOR_DEF

	@UMSG

	%pktdesc

	%SOURCES
	%SOURCE_LISTS

	%T_REQ
	%T_CONF
	@T_LINK
	@T_NODE
	%T_SEQ

	@STACK_LINK0_QG
	@STACK_LINK0_R
	@STACK_LINK1_QG
	@STACK_LINK1_R
	%STACK_S

	InfoError
	InfoWarning
	InfoDebug

	vLog0
	vLog1
	vLog2
	vLogRed
	vLogBlue
	vLogGreen

	Setup
	Term

	ConfProc
	BootProc
	EnableProc
	ListenerProc
	BaseProc
	SendProc
	RecvProc

	JudgeCommon
	JudgeStackMsgIDandNum
	JudgeGeneralReport
	JudgeStackReportRecord
	JudgeReportRecord
	JudgeSplitReport
);

# Use module
use strict;
use warnings;
#use Time::Local;
use V6evalTool;

#------------------------------------------------------------------------------
# The flag for a debugging
#------------------------------------------------------------------------------
# The display level of debugging information
#   0: no display.
#   1: nothing
#   2: display 1 + function call.
#   3: display 2 + detail.
our $DEBUG = 0;

# Discontinuation of a process
#   1: End of Setup
#   2: End of ConfProc
our $PROC = 0;

#------------------------------------------------------------------------------
# Result ID
#------------------------------------------------------------------------------
our $RES_OK = 0;
our $RES_NG = -1;
our $RES_WAR = -2;

#------------------------------------------------------------------------------
# Configuration file.
#------------------------------------------------------------------------------
our $CONF_TXT_PATH = "./config.txt";
our $CONF_DEF_PATH = "./config.def";

#------------------------------------------------------------------------------
# Configuration data and initial value
#------------------------------------------------------------------------------
our %CONF_DATA = (
	# IPv6 Ready Logo.
	# CHECK_CONFIG_LOGO     => 0, # Automatic check of Logo requirement

	# The configuration of functional requirements.
	#   0: false, 1: true
	FUNC_SUPPRESS_REPORT => 1, # Suppresses MLDv2 Report by MLDv1 Report
	FUNC_SPECIFIC_SSM    => 1, # Specific SSM range

	FUNC_2_INTERFACES    => 0, # HUT has 2 interfaces

	# HUT has the lilmit of source list on service interface.
	SI_SRCLST_INCLUDE_UNDER45   => 0,
	SI_SRCLST_INCLUDE_UNDER90   => 0,
	SI_SRCLST_EXCLUDE_UNDER45   => 0,
	SI_SRCLST_EXCLUDE_UNDER90   => 0,

	# HUT has the limit of source list in internal resource.
	IN_SRCLST_INCLUDE_UNDER90   => 0,

	# The configuration of default value.
	#   -1: autoconfig, !=-1: default
	RV    => 2,   # 9.1  Robustness Variable
	QI    => 125, # 9.2  Query Interval
	QRI   => 10,  # 9.3  Query Response Interval
	MALI  => -1,  # 9.4  Multicast Address Listening Interval
	OQPT  => -1,  # 9.5  Other Querier Present Timeout
	SQI   => -1,  # 9.6  Startup Query Interval
	SQC   => -1,  # 9.7  Startup Query Count
	LLQI  => 1,   # 9.8  Last Listener Query Interval
	LLQC  => -1,  # 9.9  Last Listener Query Count
	LLQT  => -1,  # 9.10 Last Listener Query Time
	URI   => 1,   # 9.11 Unsolicited Report Interval
	OVQPT => -1,  # 9.12 Older Version Querier Present Timeout
	OVHPT => -1,  # 9.13 Older Version Host Present Timeout
	DupAddrDetectTransmits => 1, # The number of NS-DAD messages
	SRV   => -1,  # The number of MLDv2 Report messages before NS-DAD (original)

	# Network prefix
	NETWORK0 => "3ffe:501:ffff:100::", # Link0
	NETWORK1 => "3ffe:501:ffff:101::", # Link1
	NETWORKX => "3ffe:501:ffff:300::", # Multicast source node in

	# RUT link local address
	HUT0_LLOCAL => "fe80::", # Link0 link local address
	HUT1_LLOCAL => "fe80::", # Link1 link local address

	# HUT solicited node multicast address
	HUT0_SOL_MCAST => "ff02::1:ff00:0", # Link0 solicited multicast address
	HUT1_SOL_MCAST => "ff02::1:ff00:0", # Link1 solicited multicast address

	# Multicast address (other than SSM range(s))
	MCAST1 => "ff3e:40:3ffe:501:ffff:300:0:1", # Multicast Address 0
	MCAST2 => "ff3e:40:3ffe:501:ffff:300:0:2", # Multicast Address 1

	# SSM range other than IANA standard.
	SSM_RANGE             => 0,                     # The flag of a specification SSM test
	SSM_RANGE_P_ADDR      => "ff3e::9000:0000/100", # The address prefix for SSM range
	SSM_RANGE_ST_OUT_ADDR => "ff3e::8fff:ffff",     # The under address of SSM minimum address
	SSM_RANGE_ST_ADDR     => "ff3e::9000:0001",     # The SSM minimum address
	SSM_RANGE_ED_ADDR     => "ff3e::9fff:ffff",     # The SSM maximum address
	SSM_RANGE_ED_OUT_ADDR => "ff3e::a000:0001",     # The over address of SSM maximum
	# HUT Interface ID
	IF0 => "dummy", # Link0 Interface ID
	IF1 => "dummy", # Link1 Interface ID

	# The field in TN Query
	MLDQG_MRD           => -1, #
	MLDQM_MRD           => -1, #

	# The field which cheats a check for debugging.
	#   -1: check, !=-1: Fix value or "any"
	HUT_MLDR_HOP        => -1, # MLDv1 Report Hop Limit
	HUT_MLDR_CODE       => -1, # MLDv1 Report Code
	HUT_MLDR_CHECKSUM   => -1, # MLDv1 Report Checksum
	HUT_MLDR_MRD        => -1, # MLDv1 Report Max Response Delay
	HUT_MLDR_RESERVED   => -1, # MLDv1 Report Reserved

	HUT_MLDv2R_HOP      => -1, # MLDv2 Report Hop Limit
	HUT_MLDv2R_CODE     => -1, # MLDv2 Report Code
	HUT_MLDv2R_CHECKSUM => -1, # MLDv2 Report Checksum
	HUT_MLDv2R_RESERVED => -1, # MLDv2 Report Reserved

	# The message which avoids a check for debugging.
	#   0: uncheck, 1: check
	CHECK_UNEXPECT_REPORT => 1, # Unexpected report
	CHECK_UNEXPECT_QUERY  => 1, # Unexpected query
	CHECK_STARTUP_REPORT  => 1, # Startup MLD Report
	CHECK_GENERAL_REPORT  => 1, # General MLD Report

	# Adjustment relevant to the performance of HUT.
	ENABLE_TIME => 5, # 
	MARGIN_TIME => 2, # 
	CHECK_TIME  => 2, # 

	# The count which reruns a test with a timing matter.
	RETRY_COUNT => 5, #

	# Control of remote files
	mldv2DisableHUT     => 1, # MLDv2 listener function is stopped.
	mldv2SetHUT         => 1, # The parameters of MLDv2 are set to HUT.
	reboot              => 1, # HUT is rebooted. Or HUT is initialized.
	mldv2EnableHUT      => 1, # MLDv2 listener function is enabled.
	mldv2ListenerAPI    => 1, # Listener API
	FUNC_ENABLE_REPORT  => 1, # Enable MLDv2 Report

	# Simple initialization
	STOP_LISETENING     => 0, # Stop listening

	# The flag for displaying detailed tester behavior.
	DEBUG => 0,
);

#------------------------------------------------------------------------------
# Attribute of configuration data
#------------------------------------------------------------------------------
#   0: String/Address/Unknown insert in ""
#   1: Numerical value
#   2: Milli second
our %CONF_ATTR = (
	# CHECK_CONFIG_LOGO     => 1,

	FUNC_SUPPRESS_REPORT => 1,
	FUNC_SPECIFIC_SSM    => 1,

	FUNC_2_INTERFACES    => 1,

	SI_SRCLST_INCLUDE_UNDER45   => 1,
	SI_SRCLST_INCLUDE_UNDER90   => 1,
	SI_SRCLST_EXCLUDE_UNDER45   => 1,
	SI_SRCLST_EXCLUDE_UNDER90   => 1,

	IN_SRCLST_INCLUDE_UNDER90   => 1,

	RV    => 1,
	QI    => 1,
	QRI   => 2,
	MALI  => 1,
	OQPT  => 1,
	SQI   => 1,
	SQC   => 1,
	LLQI  => 2,
	LLQC  => 1,
	LLQT  => 1,
	URI   => 1,
	OVQPT => 1,
	OVHPT => 1,

	DupAddrDetectTransmits => 1,
	SRV   => 1,

	NETWORK0 => 0,
	NETWORK1 => 0,
	NETWORKX => 0,

	HUT0_LLOCAL => 0,
	HUT1_LLOCAL => 0,

	HUT0_SOL_MCAST => 0,
	HUT1_SOL_MCAST => 0,

	MCAST1 => 0,
	MCAST2 => 0,

	SSM_RANGE             => 1,
	SSM_RANGE_P_ADDR      => 0,
	SSM_RANGE_ST_OUT_ADDR => 0,
	SSM_RANGE_ST_ADDR     => 0,
	SSM_RANGE_ED_ADDR     => 0,
	SSM_RANGE_ED_OUT_ADDR => 0,

	IF0 => 0,
	IF1 => 0,

	MLDQG_MRD => 2,
	MLDQM_MRD => 2,

	HUT0_SOL_MCAST => 0,
	HUT1_SOL_MCAST => 0,

	HUT_MLDR_HOP      => 1,
	HUT_MLDR_CODE     => 1,
	HUT_MLDR_CHECKSUM => 0,
	HUT_MLDR_MRD      => 1,
	HUT_MLDR_RESERVED => 1,

	HUT_MLDv2R_HOP      => 1,
	HUT_MLDv2R_CODE     => 1,
	HUT_MLDv2R_CHECKSUM => 0,
	HUT_MLDv2R_RESERVED => 1,

	CHECK_UNEXPECT_REPORT => 1,
	CHECK_UNEXPECT_QUERY  => 1,
	CHECK_STARTUP_REPORT  => 1,
	CHECK_GENERAL_REPORT => 1,

	ENABLE_TIME => 1,
	MARGIN_TIME => 1,
	CHECK_TIME  => 1,

	mldv2DisableHUT     => 1,
	mldv2SetHUT         => 1,
	reboot              => 1,
	mldv2EnableHUT      => 1,
	mldv2ListenerAPI    => 1,
	FUNC_ENABLE_REPORT  => 1,

	STOP_LISETENING     => 1,

	RETRY_COUNT => 1,

	DEBUG => 1,
);

#------------------------------------------------------------------------------
# Configure to define file through all the tests
#------------------------------------------------------------------------------
our @CONF_FOR_DEF = (
	"NETWORK0", "NETWORK1", "NETWORKX",

	"MCAST1", "MCAST2",

	"SSM_RANGE_P_ADDR",
	"SSM_RANGE_ST_OUT_ADDR", "SSM_RANGE_ST_ADDR",
	"SSM_RANGE_ED_ADDR", "SSM_RANGE_ED_OUT_ADDR",

	# in HUT MLDv1 Report
	"HUT_MLDR_HOP", "HUT_MLDR_CODE", "HUT_MLDR_CHECKSUM",
	"HUT_MLDR_MRD", "HUT_MLDR_RESERVED",

	# in HUT MLDv2 Report
	"HUT_MLDv2R_HOP", "HUT_MLDv2R_CODE", "HUT_MLDv2R_CHECKSUM",
	"HUT_MLDv2R_RESERVED",
);

#------------------------------------------------------------------------------
# Configure to define file by CPP for every test
#------------------------------------------------------------------------------
our @CONF_FOR_CPP = (
	"MLDQG_MRD", "MLDQM_MRD",
);

#------------------------------------------------------------------------------
# Configure to HUT by rmt for every test
#------------------------------------------------------------------------------
# standard
our @CONF_FOR_RMT = (
	"DupAddrDetectTransmits",
	"RV", "QI", "QRI", "URI",
);

# special
our @CONF_FOR_RMT_2 = ();

# SSM
our @CONF_FOR_RMT_3 = (
	"SSM_RANGE_P_ADDR", "SSM_RANGE_ST_ADDR", "SSM_RANGE_ED_ADDR",
);

#------------------------------------------------------------------------------
# Neighbor node data
#------------------------------------------------------------------------------
our %TR1 = (
	IF     => "Link0",
	LLOCAL => "fe80::200:ff:fe00:1",
	GLOBAL => "3ffe:501:ffff:100:200:ff:fe00:1",
	RA     => "RA_tr1l_allnodes",
	NAL    => "NA_tr1l_allnodes",
	NAG    => "NA_tr1g_allnodes",
);

our %TR2 = (
	IF     => "Link0",
	LLOCAL => "fe80::200:ff:fe00:2",
	GLOBAL => "3ffe:501:ffff:100:200:ff:fe00:2",
	RA     => "RA_tr2l_allnodes",
	NAL    => "NA_tr2l_allnodes",
	NAG    => "NA_tr2g_allnodes",
);

our %TR3 = (
	IF     => "Link0",
	LLOCAL => "fe80::200:ff:fe00:3",
	GLOBAL => "3ffe:501:ffff:100:200:ff:fe00:3",
	RA     => "RA_tr3l_allnodes",
	NAL    => "NA_tr3l_allnodes",
	NAG    => "NA_tr3g_allnodes",
);

our %TR4 = (
	IF     => "Link0",
	LLOCAL => "fe80::200:ff:fe00:4",
	GLOBAL => "3ffe:501:ffff:101:200:ff:fe00:4",
	RA     => "RA_tr4l_allnodes",
	NAL    => "NA_tr4l_allnodes",
	NAG    => "NA_tr4g_allnodes",
);

our %TN1 = (
	IF     => "Link0",
	LLOCAL => "fe80::200:ff:fe00:0011",
	GLOBAL => "3ffe:501:ffff:100:200:ff:fe00:11",
	NAL    => "NA_tn1l_allnodes",
	NAG    => "NA_tn1g_allnodes",
);

#------------------------------------------------------------------------------
# Automatic processing data
#------------------------------------------------------------------------------
# our @UMSG = ("MLDv2R_any_any", "MLDv2Q_any_any");
our @UMSG = ("MLDv2R_any_any");

our %AUTO_MSG = (
	Link0 => [
		"RS_any_any", "NS_any_any", "RA_any_any", "NA_any_any",
		"MLDv2R_any_any",
#		"MLDv2Q_any_any",
	],
	Link1 => [
		"RS_any_any", "NS_any_any", "RA_any_any", "NA_any_any",
		"MLDv2R_any_any",
#		"MLDv2Q_any_any",
	],
);

our %AUTO_PROC = (
	Link0 => {
		RS_any_any => "AutoProc_RS",
		NS_any_any => "AutoProc_NS",
		RA_any_any => "AutoProc_RA",
		NA_any_any => "AutoProc_NA",
		MLDv2R_any_any => "AutoProc_Rany",
#		MLDv2Q_any_any => "AutoProc_Qany",
	},
	Link1 => {
		RS_any_any => "AutoProc_RS",
		NS_any_any => "AutoProc_NS",
		RA_any_any => "AutoProc_RA",
		NA_any_any => "AutoProc_NA",
		MLDv2R_any_any => "AutoProc_Rany",
#		MLDv2Q_any_any => "AutoProc_Qany",
	},
);

#------------------------------------------------------------------------------
# The frame of packet structure
#------------------------------------------------------------------------------
our $FRAME_IPv6   = "Frame_Ether.Packet_IPv6.Hdr_IPv6";
our $FRAME_MLDv2R = "Frame_Ether.Packet_IPv6.ICMPv6_MLDv2Report";
our $FRAME_MLDv2Q = "Frame_Ether.Packet_IPv6.ICMPv6_MLDv2Query";

#------------------------------------------------------------------------------
# packet describe
#------------------------------------------------------------------------------
our %pktdesc = (
	#--------------------------------------------------------------------------
	# RS
	#--------------------------------------------------------------------------
	# RS: HUT -> any
	RS_any_any        => "Recv: any -> any, RS",

	#--------------------------------------------------------------------------
	# RA
	#--------------------------------------------------------------------------
	# RA: HUT -> any
	RA_any_any        => "Recv: any -> any, RA any",

	#--------------------------------------------------------------------------
	# RA: TR1 -> All Nodes Address
	RA_tr1l_allnodes  => "Send: TR1 -> All Nodes Address, RA Network0",

	#--------------------------------------------------------------------------
	# RA: TR2 -> All Nodes Address
	RA_tr2l_allnodes  => "Send: TR2 -> All Nodes Address, RA Network0",

	#--------------------------------------------------------------------------
	# RA: TR3 -> All Nodes Address
	RA_tr3l_allnodes  => "Send: TR3 -> All Nodes Address, RA Network0",

	#--------------------------------------------------------------------------
	# RA: TR4 -> All Nodes Address
	RA_tr4l_allnodes  => "Send: TR4 -> All Nodes Address, RA Network1",

	#--------------------------------------------------------------------------
	# NS
	#--------------------------------------------------------------------------
	# NS: HUT -> any
	NS_any_any        => "Recv: any -> any, NS any",

	#--------------------------------------------------------------------------
	# NA
	#--------------------------------------------------------------------------
	# NA: HUT -> any
	NA_any_any        => "Recv: any -> any, NA any",

	#--------------------------------------------------------------------------
	# NA: TR1 -> All Nodes Address
	NA_tr1l_allnodes  => "Send: TR1 -> All Nodes Address, NA link-local",
	NA_tr1g_allnodes  => "Send: TR1 -> All Nodes Address, NA global",

	#--------------------------------------------------------------------------
	# NA: TR2 -> All Nodes Address
	NA_tr2l_allnodes  => "Send: TR2 -> All Nodes Address, NA link-local",
	NA_tr2g_allnodes  => "Send: TR2 -> All Nodes Address, NA global",

	#--------------------------------------------------------------------------
	# NA: TR3 -> All Nodes Address
	NA_tr3l_allnodes  => "Send: TR3 -> All Nodes Address, NA link-local",
	NA_tr3g_allnodes  => "Send: TR3 -> All Nodes Address, NA global",

	#--------------------------------------------------------------------------
	# NA: TR4 -> All Nodes Address
	NA_tr4l_allnodes  => "Send: TR4 -> All Nodes Address, NA link-local",
	NA_tr4g_allnodes  => "Send: TR4 -> All Nodes Address, NA global",

	#--------------------------------------------------------------------------
	# NA: TN1 -> All Nodes Address
	NA_tn1l_allnodes  => "Send: TN1 -> All Nodes Address, NA link-local",
	NA_tn1g_allnodes  => "Send: TN1 -> All Nodes Address, NA global",

	#--------------------------------------------------------------------------
	# MLDv2 Query, any (HUT)
	#--------------------------------------------------------------------------
	# MLDv2 Query: any -> any
#	MLDv2Q_any_any              =>  "Recv: any -> any, MLDv2 Query any",
#	MLDv2Q_any_any_except_qg    =>  "Recv: any -> any, MLDv2 Query any",

	#--------------------------------------------------------------------------
	# MLDv2 Query: TR1
	#--------------------------------------------------------------------------
	# MLDv2 Query: TR1 -> All Nodes Address
	MLDv2Q_tr1l_allnodes_m0     =>  "Send: TR1 -> All Nodes Address, MLDv2 Query (G)",

	#--------------------------------------------------------------------------
	# MLDv2 Query: TR1 -> M1
	MLDv2Q_tr1l_mcast1_m1n0     =>  "Send: TR1 -> M1, MLDv2 Query (M1,{null})",

	MLDv2Q_tr1l_mcast1_m1n1s1   =>  "Send: TR1 -> M1, MLDv2 Query (M1,{S1})",
	MLDv2Q_tr1l_mcast1_m1n2s13  =>  "Send: TR1 -> M1, MLDv2 Query (M1,{S1,S3})",
	MLDv2Q_tr1l_mcast1_m1n3s123 =>  "Send: TR1 -> M1, MLDv2 Query (M1,{S1,S2,S3})",

	#--------------------------------------------------------------------------
	# MLDv2 Query: TR1 -> M2
	MLDv2Q_tr1l_mcast2_m2n0     =>  "Send: TR1 -> M2, MLDv2 Query (M2,{null})",

	#--------------------------------------------------------------------------
	# MLDv1 Query: TR1
	#--------------------------------------------------------------------------
	# MLDv1 Query: TR1 -> All Nodes Address
	MLDv1Q_tr1l_allnodes_m0     =>  "Send: TR1 -> All Nodes Address, MLDv1 Query (G)",

	# MLDv1 Query: TR1 -> M1
	MLDv1Q_tr1l_mcast1_m1       =>  "Send: TR1 -> M1, MLDv1 Query (M1)",

	#--------------------------------------------------------------------------
	# MLDv2 Report: any (HUT)
	#--------------------------------------------------------------------------
	# MLDv2 Report: any -> any
	MLDv2R_any_any                    => "Recv: any -> any, MLDv2 Report any",

	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> any
	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> any
#	MLDv2R_hut0l_any                  => "Recv: HUT0 -> any, MLDv2 Report any",

	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers, any
	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_any            => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report any",

	# MLDv2 Report: HUT0 -> All MLDv2-capable routers, 1 Record
	MLDv2R_hut0l_mld2r_r1_any         => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report 1 Record",

	# MLDv2 Report: HUT0 -> All MLDv2-capable routers, 2 Records
	MLDv2R_hut0l_mld2r_r2_any         => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report 2 Record",

	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers, IS_IN
	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t1m1n1s1    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report IS_IN(M1,{S1})",


	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers, IS_EX
	#--------------------------------------------------------------------------
	MLDv2R_hut0l_mld2r_r1_t2m1n0      => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report IS_EX(M1,{NULL})",

	MLDv2R_hut0l_mld2r_r1_t2m1n1s1    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report IS_EX(M1,{S1})",


	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers, TO_IN
	#--------------------------------------------------------------------------
	MLDv2R_hut0l_mld2r_r1_t3m1n0      => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report TO_IN(M1,{NULL})",

	MLDv2R_hut0l_mld2r_r1_t3m1n1s1    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report TO_IN(M1,{S1})",


	#--------------------------------------------------------------------------
	# MLDv2 Report: 0 (HUT) -> All MLDv2-capable routers, TO_EX
	#--------------------------------------------------------------------------
	# MLDv2 Report: any -> All MLDv2-capable routers
	MLDv2R_0_mld2r_r1_t4hut0sn0       => "Recv: 0 -> All MLDv2-capable routers, MLDv2 Report TO_EX(HUT0 solicited-node multicast,{NULL})",

	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers, TO_EX
	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t4hut0sn0   => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report TO_EX(HUT0 solicited-node multicast,{NULL})",

	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut1l_mld2r_r1_t4hut1sn0   => "Recv: HUT1 -> All MLDv2-capable routers, MLDv2 Report TO_EX(HUT1 solicited-node multicast,{NULL})",

	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t4m1n0      => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report TO_EX(M1,{NULL})",

	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t4m1n1s1    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report TO_EX(M1,{S1})",

	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t4m1n1s2    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report TO_EX(M1,{S2})",

	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers, ALLOW
	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t5m1n1s1    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report ALLOW(M1,{S1})",

	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t5m1n1s2    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report ALLOW(M1,{S2})",

	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t5m1n1s3    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report ALLOW(M1,{S3})",

	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers, BLOCK
	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t6m1n1s1    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report BLOCK(M1,{S1})",

	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t6m1n1s2    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report BLOCK(M1,{S2})",

	# MLDv2 Report: HUT0 -> All MLDv2-capable routers
	MLDv2R_hut0l_mld2r_r1_t6m1n1s3    => "Recv: HUT0 -> All MLDv2-capable routers, MLDv2 Report BLOCK(M1,{S3})",

	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT1
	#--------------------------------------------------------------------------
	# MLDv2 Report: HUT1 -> any
#	MLDv2R_hut1l_any                  => "Recv: HUT1 -> any, MLDv2 Report any",

	#--------------------------------------------------------------------------
	# MLDv2 Report: TN1
	#--------------------------------------------------------------------------
	# MLDv2 Report: TN1 -> All MLDv2-capable routers
	MLDv2R_tn1l_mld2r_r1_t1m1n1s1     => "Send: TN1 -> All MLDv2-capable routers, MLDv2 Report IS_IN(M1,{S1})",
);

#------------------------------------------------------------------------------
# Verification data
#------------------------------------------------------------------------------
our %SOURCES = ();
our %SOURCE_LISTS = ();

#==============================================================================
# The variable specified by a test sequence
#==============================================================================
# Requirement
our %T_REQ = ();

# Fixed configuration for every test
our %T_CONF = ();

# Topology
our @T_LINK = ();
our @T_NODE = ();

# Sequence
our %T_SEQ = ();

# Boot flag in BootProc()
our $BOOT = 0;

# 2in1 flag
our $TowInOne = 0;

#------------------------------------------------------------------------------
# Loging data
#------------------------------------------------------------------------------
our @STACK_LINK0_QG =();
our @STACK_LINK1_QG =();

our @STACK_LINK0_R =();
our @STACK_LINK1_R =();

our %STACK_S = ();

#------------------------------------------------------------------------------
# Current multicast data
#------------------------------------------------------------------------------
our %STACK_MCAST = ();

#------------------------------------------------------------------------------
# Subroutine
#------------------------------------------------------------------------------
sub InfoError($$$);
sub InfoWarning($$$);
sub InfoDebug($$$);

sub vLog0($);
sub vLog1($);
sub vLog2($);
sub vLogRed($);
sub vLogBlue($);
sub vLogGreen($);

sub Setup();
sub ReadConfTxt();
sub ReadNutDef();
sub SetupTN();
sub SetupData();

sub Term($);
sub StopListening();

sub ConfProc($);
sub BootProc($);
sub EnableProc($);
sub ListenerProc($);
sub BaseProc($);
sub SendProc($);
sub RecvProc($);

sub AutoProc_RS($%);
sub AutoProc_NS($%);
sub AutoProc_RA($%);
sub AutoProc_NA($%);
sub AutoProc_Qany($%);
sub AutoProc_Rany($%);

sub JudgeCommon();
sub JudgeStackMsgIDandNum($$@);
# sub JudgeGeneralQueryInterval($);
sub JudgeStartupReport($$);
sub JudgeGeneralReport(%$);
sub JudgeStackReportRecord($$$$$);
sub JudgeReportRecord(%$$$$);
sub JudgeSplitReport($$$$$$);
# sub JudgeStackQuerySeclist($$);
# sub JudgeQuerySrclist(%$);
# sub JudgeSplitQuery($$$);

sub GetReportRcd(%);
# sub GetQuerySrclist(%);
sub CompRecord(%$$$$);
sub CompLst(@@);

#------------------------------------------------------------------------------
# InfoError
# InfoWarning
# InfoDebug
#   Output the internal information to the stdout.
#   <IN>    file   : __FILE__
#           line   : __LINE__
#           str    : string
#------------------------------------------------------------------------------
sub InfoError($$$) {
my ($file, $line, $str) = @_;
	print "	ERROR($file,$line) $str\n";
}

sub InfoWarning($$$) {
my ($file, $line, $str) = @_;
	print "	WARNING($file,$line) $str\n";
}

sub InfoDebug($$$) {
my ($file, $line, $str) = @_;
	print "		DEBUG($file,$line) $str\n";
}

#------------------------------------------------------------------------------
# vLog
#   vLog is already exist in v6eval. vlog("$str") is vLogHTML("$str<BR>").
# vLog0
# vLog1
# vLog2
# vLogRed
# vLogBlue
# vLogGreen
#   Output the message to the stdout and the log (<Test Sequence NO.>.html).
#   <IN>    str: string
#------------------------------------------------------------------------------
sub vLog0($) {
my ($str) = @_;
	vLogHTML("$str<BR>\n");
}

sub vLog1($) {
my ($str) = @_;
	vLogHTML("<B>---------- $str ----------</B><BR>\n");
}

sub vLog2($) {
my ($str) = @_;
	vLogHTML("<B>========== $str ==========</B><BR>\n");
}

sub vLogRed($) {
my ($str) = @_;
	vLogHTML("<FONT COLOR='#FF0000'>$str</FONT><BR>\n");
}

sub vLogBlue($) {
my ($str) = @_;
	vLogHTML("<FONT COLOR='#0000FF'>$str</FONT><BR>\n");
}

sub vLogGreen($) {
my ($str) = @_;
	vLogHTML("<FONT COLOR='#00FF00'>$str</FONT><BR>\n");
}

#------------------------------------------------------------------------------
# Setup
#   The main function of the setup.
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub Setup() {
my $rtn;
my $ckey;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "Setup()");
	}

	# Read the configuration file.
	$rtn = ReadConfTxt();
	if ($rtn != $RES_OK) {
		return $rtn;
	}

	# Read the nut.def
	$rtn = ReadNutDef();
	if ($rtn != $RES_OK) {
		return $rtn;
	}

	# Setup the tester.
	$rtn = SetupTN();

	# Display configuration.
	foreach $ckey (sort keys %CONF_DATA) {
		vLog0("	$ckey => $CONF_DATA{$ckey}");
	}

	# End of setup
	if ($PROC == 1) {
		vLog2("Procedure");
		exit $V6evalTool::exitPass;
	}

	return $rtn;
}

#------------------------------------------------------------------------------
# ReadConfTxt
#   Read the configuration file (config.txt) and update to %CONF_DATA.
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub ReadConfTxt() {
my $rtn = $RES_OK;
my $line;
my $ckey;
my $cvalue;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "ReadConfTxt()");
	}

	# Open the configuration file.
	unless (open(IN_F, $CONF_TXT_PATH)) {
		vLogRed("FAIL: open($CONF_TXT_PATH), $!.");
		exit $V6evalTool::exitFail;
	}

	# Read the configuration file and update CONFIG_DATA.
	for ($line = 0; <IN_F>; $line++) {
		# Comment or empty
		if (($_ =~ /^#/) || ($_ =~ /^\n/)) {
			next;
		}

		# Extract the config data.
		unless ($_ =~ /^\s*(\S+)\s+(\S+)\s*$/) {
			vLogRed("FAIL: $CONF_TXT_PATH($line), $_ is a strange form.");
			exit $V6evalTool::exitFail;
		}
		$ckey   = $1;
		$cvalue = $2;
		if ($DEBUG > 2) {
			InfoDebug(__FILE__, __LINE__, "$CONF_TXT_PATH($line), $ckey => $cvalue.");
		}

		# Check the key about the internal inconsistency.
		unless (defined $CONF_DATA{$ckey}) {
			vLogRed("FAIL: $CONF_TXT_PATH($line), $ckey is an unknown item.");
			exit $V6evalTool::exitFail;
		}

		# Update CONF_DATA.
		$CONF_DATA{$ckey} = $cvalue;
	}

	# Close the configuration file.
	close(IN_F);

	#--------------------------------------------------------------------------
	# Analysis of DEBUG
	#--------------------------------------------------------------------------
	# Specification of PROC to stop
	$PROC = int($CONF_DATA{DEBUG} / 10);
	# Specification of the internal information level to display
	$DEBUG = $CONF_DATA{DEBUG} = $CONF_DATA{DEBUG} % 10;

	#--------------------------------------------------------------------------
	# In order to make a common definition (@CONF_FOR_DEF for MLDv2Lconfdef.pl),
	# these members were moved from SetupData().
	#--------------------------------------------------------------------------
	# HUT1
	if (($CONF_DATA{FUNC_2_INTERFACES} != 0) && ($CONF_DATA{IF1} eq "dummy")){
		vLogRed("FAULT: If two interfaces are tested, please set up Link1 in nut.def.");
		vLogRed("       If it does not make, please specify zero as FUNC_2_INTERFACES in config.txt.");
		exit $V6evalTool::exitFail;
	}

	# NETWORK

	# MCAST

	# SSM

	#--------------------------------------------------------------------------
	# The field which cheats a check for debugging.
	# MLDv1 Report HopLimit
	if ($CONF_DATA{HUT_MLDR_HOP} == -1) {
		$CONF_DATA{HUT_MLDR_HOP} = 1;
	}

	# MLDv1 Report Code
	if ($CONF_DATA{HUT_MLDR_CODE} == -1) {
		$CONF_DATA{HUT_MLDR_CODE} = 0;
	}

	# MLDv1 Report Checksum
	if ($CONF_DATA{HUT_MLDR_CHECKSUM} == -1) {
		$CONF_DATA{HUT_MLDR_CHECKSUM} = "auto";
	}
	elsif (($CONF_DATA{HUT_MLDR_CHECKSUM} ne "any") ||
	       ($CONF_DATA{HUT_MLDR_CHECKSUM} ne "auto")) {
		vLogRed("FAIL: The value of HUT_MLDR_CHECKSUM is not suitable, $CONF_DATA{HUT_MLDR_CHECKSUM}.");
		$rtn = $RES_NG;
	}

	# MLDv1 Report Max Response Delay
	if ($CONF_DATA{HUT_MLDR_MRD} == -1) {
		$CONF_DATA{HUT_MLDR_MRD} = 0;
	}

	# MLDv1 Report Reserved
	if ($CONF_DATA{HUT_MLDR_RESERVED} == -1) {
		$CONF_DATA{HUT_MLDR_RESERVED} = 0;
	}

	# MLDv2 Report HopLimit
	if ($CONF_DATA{HUT_MLDv2R_HOP} == -1) {
		$CONF_DATA{HUT_MLDv2R_HOP} = 1;
	}

	# MLDv2 Report Code
	if ($CONF_DATA{HUT_MLDv2R_CODE} == -1) {
		$CONF_DATA{HUT_MLDv2R_CODE} = 0;
	}

	# MLDv2 Report Checksum
	if ($CONF_DATA{HUT_MLDv2R_CHECKSUM} == -1) {
		$CONF_DATA{HUT_MLDv2R_CHECKSUM} = "auto";
	}
	elsif (($CONF_DATA{HUT_MLDv2R_CHECKSUM} ne "any") ||
	       ($CONF_DATA{HUT_MLDv2R_CHECKSUM} ne "auto")) {
		vLogRed("FAIL: The value of HUT_MLDv2R_CHECKSUM is not suitable, $CONF_DATA{HUT_MLDv2R_CHECKSUM}.");
		$rtn = $RES_NG;
	}

	# MLDv2 Report Reserved
	if ($CONF_DATA{HUT_MLDv2R_RESERVED} == -1) {
		$CONF_DATA{HUT_MLDv2R_RESERVED} = 0;
	}

	#--------------------------------------------------------------------------
	# It checks configurations corresponding to IPv6 Ready Logo.
	#--------------------------------------------------------------------------
	# if ($CONF_DATA{CHECK_CONFIG_LOGO} == 1) {
	# }

	if ($rtn != $RES_OK) {
		exit $V6evalTool::exitFail;
	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# ReadNutDef
#   Read the nut.def and update to %CONF_DATA.
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub ReadNutDef() {
my $mac;
my @mac_el;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "ReadNutDef()");
	}

	# Check the device type.
	if ($V6evalTool::NutDef{Type} ne 'host') {
		vLogRed("FAULT: This test tool is for the MLDv2 host only.");
		vLogRed("       If you want to execute this test tool, set 'host' to 'type' in nut.def.");
		exit $V6evalTool::exitHostOnly;
	}

	# Check the interface 0 as HUT0
	unless (defined $V6evalTool::NutDef{Link0_device}) {
		vLogRed("FAULT: Interface information to be examined is necessary.");
		vLogRed("       Please set up 'Link0' in nut.def.");
		exit $V6evalTool::exitFail;
	}

	# HUT0 Interface ID
	$CONF_DATA{IF0} = $V6evalTool::NutDef{Link0_device};

	# HUT0 mac
	$mac = lc($V6evalTool::NutDef{Link0_addr});
	unless ($mac =~ /([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9])/) {
		vLogRed("FAIL: Link0 in nut.def is a strange form.");
		exit $V6evalTool::exitFail;
	}
	@mac_el = ($1, $2, $3, $4, $5, $6);

	# HUT0 link local address
	$CONF_DATA{HUT0_LLOCAL} = sprintf "fe80::%x%s:%02xff:fe%02x:%x", hex("$mac_el[0]")^0x2, $mac_el[1],
		hex("$mac_el[2]"), hex("$mac_el[3]"), hex("$mac_el[4]$mac_el[5]");

	# HUT0 solicited multicast address
	$CONF_DATA{HUT0_SOL_MCAST} = sprintf "ff02::1:ff%2.2x:%x", hex("$mac_el[3]"), hex("$mac_el[4]$mac_el[5]");

	# Check the interface 1 as HUT1
	unless (defined $V6evalTool::NutDef{Link1_device}) {
		# dummy data
		$V6evalTool::NutDef{Link1_device} = "dummy";
		$V6evalTool::NutDef{Link1_addr} = "00:00:00:00:00:00";
	}

	# HUT1 Interface ID
	$CONF_DATA{IF1} = $V6evalTool::NutDef{Link1_device};

	# HUT1 mac
	$mac = lc($V6evalTool::NutDef{Link1_addr});
	unless ($mac =~ /([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9]):([a-f0-9][a-f0-9])/) {
		vLogRed("FAIL: Link1 in nut.def is a strange form.");
		exit $V6evalTool::exitFail;
	}
	@mac_el = ($1, $2, $3, $4, $5, $6);

	# HUT1 link local address
	$CONF_DATA{HUT1_LLOCAL} = sprintf "fe80::%x%s:%02xff:fe%02x:%x", hex("$mac_el[0]")^0x2, $mac_el[1],
		hex("$mac_el[2]"), hex("$mac_el[3]"), hex("$mac_el[4]$mac_el[5]");

	# HUT1 solicited multicast address
	$CONF_DATA{HUT1_SOL_MCAST} = sprintf "ff02::1:ff%2.2x:%x", hex("$mac_el[3]"), hex("$mac_el[4]$mac_el[5]");

	if ($DEBUG > 2) {
		InfoDebug(__FILE__, __LINE__, "HUT0 IF  = $CONF_DATA{IF0}.");
		InfoDebug(__FILE__, __LINE__, "HUT0 LL  = $CONF_DATA{HUT0_LLOCAL}.");
		InfoDebug(__FILE__, __LINE__, "HUT0 SOL = $CONF_DATA{HUT0_SOL_MCAST}.");
		InfoDebug(__FILE__, __LINE__, "HUT1 IF  = $CONF_DATA{IF1}.");
		InfoDebug(__FILE__, __LINE__, "HUT1 LL  = $CONF_DATA{HUT1_LLOCAL}.");
		InfoDebug(__FILE__, __LINE__, "HUT1 SOL = $CONF_DATA{HUT1_SOL_MCAST}.");
	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# SetupTN
#   Reflect the particular specification in this test to CONF_DATA and 
#   synchronize with the define file (<*>.def).
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub SetupTN() {
my $rtn;
my $ckey;
my $cpp;
my $cvalue;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "SetupTN()");
	}

	# Check the requirement.
	foreach $ckey (keys %T_REQ) {
		if ($DEBUG > 2) {
			InfoDebug(__FILE__, __LINE__, "T_REQ{$ckey} = $T_REQ{$ckey}.");
		}

		# Check the key about the internal inconsistency.
		unless (defined $CONF_DATA{$ckey}) {
			vLogRed("INTERNAL ERROR: SetupTN(), T_REQ{ $ckey } is an unknown item.");
			exit $V6evalTool::exitFatal;
		}

		# Check whether the requirement.
		if ($T_REQ{$ckey} == 0) {
			next;
		}

		# Check whether configuring satisfies the requirement.
		if ($T_REQ{$ckey} != $CONF_DATA{$ckey}) {
			vLogGreen("SKIP: This test requirement does not suit with your configuration.");
			vLogGreen("      If you want to execute this test entry, set '$T_REQ{$ckey}' to '$ckey' in $CONF_TXT_PATH.");
			exit $V6evalTool::exitIgnore;
		}
	}

	# Read the specified configuration.
	foreach $ckey (keys %T_CONF) {
		if ($DEBUG > 2) {
			InfoDebug(__FILE__, __LINE__, "T_CONF{$ckey} = $T_CONF{$ckey}.");
		}

		# Check the key about the internal inconsistency.
		unless (defined $CONF_DATA{$ckey}) {
			vLogRed("INTERNAL ERROR: SetupTN(), T_CONF{ $ckey } is an unknown item.");
			exit $V6evalTool::exitFatal;
		}

		# Update CONF_DATA
		$CONF_DATA{$ckey} = $T_CONF{$ckey};
	}

	# Setup other configuration and data.
	$rtn = SetupData();
	if ($rtn != $RES_OK) {
		return $rtn;
	}

	# Synchronize with the define file.
	foreach $ckey (@CONF_FOR_CPP) {
		# Check the key about the internal inconsistency.
		unless (defined $CONF_DATA{$ckey}) {
			vLogRed("INTERNAL ERROR: SetupTN(), CONF_FOR_CPP{ $ckey } is an unknown item.");
			exit $V6evalTool::exitFatal;
		}
		$cvalue = $CONF_DATA{$ckey};

		if (($cvalue eq "any") || ($cvalue eq "auto")) {
			$cpp .= "-D$ckey=$cvalue ";
		}
		elsif ($CONF_ATTR{$ckey} == 1) {
			# Create the argument.
			$cpp .= "-D$ckey=$cvalue ";
		}
		elsif ($CONF_ATTR{$ckey} == 2) {
			# Create the argument.
			$cvalue *= 1000;
			$cpp .= "-D$ckey=$cvalue ";
		}
		else {
			# Create the argument.
			$cpp .= "-D$ckey=\"$cvalue\" ";
		}
	}
	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "vCPP($cpp)");
	}
	vCPP($cpp);
	# If an error causes, it terminates freely with exitFatal.

	return $rtn;
}

#------------------------------------------------------------------------------
# SetupData
#   Setup other configuration data and update to %CONF_DATA.
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub SetupData() {
my $rtn = $RES_OK;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "SetupData()");
	}

	# RV
	if (($CONF_DATA{RV} < 2) || ($CONF_DATA{RV} > 8)) {
		vLogRed("FAIL: The value of RV is not suitable, $CONF_DATA{RV}.");
		$rtn = $RES_NG;
	}

	# QI
	if (($CONF_DATA{QI} < 16) || ($CONF_DATA{QI} > 31744)) {
		vLogRed("FAIL: The value of QI is not suitable, $CONF_DATA{QI}.");
		$rtn = $RES_NG;
	}

	# QRI
	if (($CONF_DATA{QRI} < 4) || ($CONF_DATA{QRI} > $CONF_DATA{QI})) {
		vLogRed("FAIL: The value of QRI is not suitable, $CONF_DATA{QRI}.");
		$rtn = $RES_NG;
	}

	# MALI = (RV * QI) + QRI
	$CONF_DATA{MALI} = $CONF_DATA{RV} * $CONF_DATA{QI} + $CONF_DATA{QRI};

	# OQPT = (RV * QI) + (QRI / 2)
	$CONF_DATA{OQPT} = $CONF_DATA{RV} * $CONF_DATA{QI} + $CONF_DATA{QRI} / 2;

	# SQI = (QI / 4)
	if ($CONF_DATA{SQI} == -1) {
		$CONF_DATA{SQI} = $CONF_DATA{QI} / 4;
	}
	elsif (($CONF_DATA{SQI} < 4) || ($CONF_DATA{SQI} < $CONF_DATA{QRI})) {
		vLogRed("FAIL: The value of SQI is not suitable, $CONF_DATA{SQI}.");
		$rtn = $RES_NG;
	}

	# SQC = RV
	if ($CONF_DATA{SQC} == -1) {
		$CONF_DATA{SQC} = $CONF_DATA{RV};
	}
	elsif (($CONF_DATA{SQC} < 2) || ($CONF_DATA{SQC} > 8)) {
		vLogRed("FAIL: The value of SQC is not suitable, $CONF_DATA{SQC}.");
		$rtn = $RES_NG;
	}

	# LLQI
	if (($CONF_DATA{LLQI} < 1) || ($CONF_DATA{LLQI} > $CONF_DATA{QRI})) {
		vLogRed("FAIL: The value of LLQI is not suitable, $CONF_DATA{LLQI}.");
		$rtn = $RES_NG;
	}

	# LLQC = RV
	if ($CONF_DATA{LLQC} == -1) {
		$CONF_DATA{LLQC} = $CONF_DATA{RV};
	}
	elsif (($CONF_DATA{LLQC} < 2) || ($CONF_DATA{LLQC} > 8)) {
		vLogRed("FAIL: The value of LLQC is not suitable, $CONF_DATA{LLQC}.");
		$rtn = $RES_NG;
	}

	# LLQT = (LLQI * LLQC)
	$CONF_DATA{LLQT} = $CONF_DATA{LLQI} * $CONF_DATA{LLQC};

	# URI
	if (($CONF_DATA{URI} < 1)) {
		vLogRed("FAIL: The value of URI is not suitable, $CONF_DATA{URI}.");
		$rtn = $RES_NG;
	}

	# OVQPT = (RV * QI) + QRI
	$CONF_DATA{OVQPT} = $CONF_DATA{RV} * $CONF_DATA{QI} + $CONF_DATA{QRI};

	# OVHPT = RV * QI + QRI
	$CONF_DATA{OVHPT} = $CONF_DATA{RV} * $CONF_DATA{QI} + $CONF_DATA{QRI};

	# DupAddrDetectTransmits
	if (($CONF_DATA{DupAddrDetectTransmits} < 0) || ($CONF_DATA{DupAddrDetectTransmits} > 8)) {
		vLogRed("FAIL: The value of DupAddrDetectTransmits is not suitable, $CONF_DATA{DupAddrDetectTransmits}.");
		$rtn = $RES_NG;
	}

	# SRV = RV
	if ($CONF_DATA{SRV} == -1) {
		$CONF_DATA{SRV} = $CONF_DATA{RV};
	}
	elsif (($CONF_DATA{SRV} < 0) || ($CONF_DATA{SRV} > 8)) {
		vLogRed("FAIL: The value of SRV is not suitable, $CONF_DATA{SRV}.");
		$rtn = $RES_NG;
	}

	# General Query MaxResponseDelay
	if ($CONF_DATA{MLDQG_MRD} < 1) {
		$CONF_DATA{MLDQG_MRD} = $CONF_DATA{QRI};
	}

	# Specific Query MaxResponseDelay
	if ($CONF_DATA{MLDQM_MRD} < 1) {
		$CONF_DATA{MLDQM_MRD} = 1;
	}

	# 
	if ($rtn != $RES_OK) {
		exit $V6evalTool::exitFail;
	}

	# Network of a multicast source
	my $networkx = $CONF_DATA{NETWORKX};

	$networkx =~ s/::/:200:ff:fe00:/;

	# Multicast source address
	%SOURCES = (
		MSRC_01 => "$networkx" . "1",  MSRC_02 => "$networkx" . "2",
		MSRC_03 => "$networkx" . "3",  MSRC_04 => "$networkx" . "4",
		MSRC_05 => "$networkx" . "5",  MSRC_06 => "$networkx" . "6",
		MSRC_07 => "$networkx" . "7",  MSRC_08 => "$networkx" . "8",
		MSRC_09 => "$networkx" . "9",  MSRC_10 => "$networkx" . "10",
		MSRC_11 => "$networkx" . "11", MSRC_12 => "$networkx" . "12",
		MSRC_13 => "$networkx" . "13", MSRC_14 => "$networkx" . "14",
		MSRC_15 => "$networkx" . "15", MSRC_16 => "$networkx" . "16",
		MSRC_17 => "$networkx" . "17", MSRC_18 => "$networkx" . "18",
		MSRC_19 => "$networkx" . "19", MSRC_20 => "$networkx" . "20",
		MSRC_21 => "$networkx" . "21", MSRC_22 => "$networkx" . "22",
		MSRC_23 => "$networkx" . "23", MSRC_24 => "$networkx" . "24",
		MSRC_25 => "$networkx" . "25", MSRC_26 => "$networkx" . "26",
		MSRC_27 => "$networkx" . "27", MSRC_28 => "$networkx" . "28",
		MSRC_29 => "$networkx" . "29", MSRC_30 => "$networkx" . "30",
		MSRC_31 => "$networkx" . "31", MSRC_32 => "$networkx" . "32",
		MSRC_33 => "$networkx" . "33", MSRC_34 => "$networkx" . "34",
		MSRC_35 => "$networkx" . "35", MSRC_36 => "$networkx" . "36",
		MSRC_37 => "$networkx" . "37", MSRC_38 => "$networkx" . "38",
		MSRC_39 => "$networkx" . "39", MSRC_40 => "$networkx" . "40",
		MSRC_41 => "$networkx" . "41", MSRC_42 => "$networkx" . "42",
		MSRC_43 => "$networkx" . "43", MSRC_44 => "$networkx" . "44",
		MSRC_45 => "$networkx" . "45", MSRC_46 => "$networkx" . "46",
		MSRC_47 => "$networkx" . "47", MSRC_48 => "$networkx" . "48",
		MSRC_49 => "$networkx" . "49", MSRC_50 => "$networkx" . "50",
		MSRC_51 => "$networkx" . "51", MSRC_52 => "$networkx" . "52",
		MSRC_53 => "$networkx" . "53", MSRC_54 => "$networkx" . "54",
		MSRC_55 => "$networkx" . "55", MSRC_56 => "$networkx" . "56",
		MSRC_57 => "$networkx" . "57", MSRC_58 => "$networkx" . "58",
		MSRC_59 => "$networkx" . "59", MSRC_60 => "$networkx" . "60",
		MSRC_61 => "$networkx" . "61", MSRC_62 => "$networkx" . "62",
		MSRC_63 => "$networkx" . "63", MSRC_64 => "$networkx" . "64",
		MSRC_65 => "$networkx" . "65", MSRC_66 => "$networkx" . "66",
		MSRC_67 => "$networkx" . "67", MSRC_68 => "$networkx" . "68",
		MSRC_69 => "$networkx" . "69", MSRC_70 => "$networkx" . "70",
		MSRC_71 => "$networkx" . "71", MSRC_72 => "$networkx" . "72",
		MSRC_73 => "$networkx" . "73", MSRC_74 => "$networkx" . "74",
		MSRC_75 => "$networkx" . "75", MSRC_76 => "$networkx" . "76",
		MSRC_77 => "$networkx" . "77", MSRC_78 => "$networkx" . "78",
		MSRC_79 => "$networkx" . "79", MSRC_80 => "$networkx" . "80",
		MSRC_81 => "$networkx" . "81", MSRC_82 => "$networkx" . "82",
		MSRC_83 => "$networkx" . "83", MSRC_84 => "$networkx" . "84",
		MSRC_85 => "$networkx" . "85", MSRC_86 => "$networkx" . "86",
		MSRC_87 => "$networkx" . "87", MSRC_88 => "$networkx" . "88",
		MSRC_89 => "$networkx" . "89", MSRC_90 => "$networkx" . "90",
	);

	%SOURCE_LISTS = (
		NULL => [ ],
		S1 => [ $SOURCES{MSRC_01} ],
		S2 => [ $SOURCES{MSRC_02} ],
		S3 => [ $SOURCES{MSRC_03} ],
		S4 => [ $SOURCES{MSRC_04} ],
		S5 => [ $SOURCES{MSRC_05} ],
		S12 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_02} ],
		S13 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_03} ],
		S14 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_04} ],
		S15 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_05} ],
		S23 => [ $SOURCES{MSRC_02}, $SOURCES{MSRC_03} ],
		S24 => [ $SOURCES{MSRC_02}, $SOURCES{MSRC_04} ],
		S25 => [ $SOURCES{MSRC_02}, $SOURCES{MSRC_05} ],
		S34 => [ $SOURCES{MSRC_03}, $SOURCES{MSRC_04} ],
		S35 => [ $SOURCES{MSRC_03}, $SOURCES{MSRC_05} ],
		S45 => [ $SOURCES{MSRC_04}, $SOURCES{MSRC_05} ],
		S123 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_02}, $SOURCES{MSRC_03} ],
		S124 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_02}, $SOURCES{MSRC_04} ],
		S125 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_02}, $SOURCES{MSRC_05} ],
		S134 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_03}, $SOURCES{MSRC_04} ],
		S135 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_03}, $SOURCES{MSRC_05} ],
		S145 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_04}, $SOURCES{MSRC_05} ],
		S234 => [ $SOURCES{MSRC_02}, $SOURCES{MSRC_03}, $SOURCES{MSRC_04} ],
		S235 => [ $SOURCES{MSRC_02}, $SOURCES{MSRC_03}, $SOURCES{MSRC_05} ],
		S245 => [ $SOURCES{MSRC_02}, $SOURCES{MSRC_04}, $SOURCES{MSRC_05} ],
		S345 => [ $SOURCES{MSRC_03}, $SOURCES{MSRC_04}, $SOURCES{MSRC_05} ],
		S1234 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_02}, $SOURCES{MSRC_03}, $SOURCES{MSRC_04} ],
		S1235 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_02}, $SOURCES{MSRC_03}, $SOURCES{MSRC_05} ],
		S1245 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_02}, $SOURCES{MSRC_04}, $SOURCES{MSRC_05} ],
		S1345 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_03}, $SOURCES{MSRC_04}, $SOURCES{MSRC_05} ],
		S2345 => [ $SOURCES{MSRC_02}, $SOURCES{MSRC_03}, $SOURCES{MSRC_04}, $SOURCES{MSRC_05} ],
		S12345 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_02}, $SOURCES{MSRC_03}, $SOURCES{MSRC_04}, $SOURCES{MSRC_05} ],
		S1_45 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_02}, $SOURCES{MSRC_03}, $SOURCES{MSRC_04}, $SOURCES{MSRC_05},
		           $SOURCES{MSRC_06}, $SOURCES{MSRC_07}, $SOURCES{MSRC_08}, $SOURCES{MSRC_09}, $SOURCES{MSRC_10},
		           $SOURCES{MSRC_11}, $SOURCES{MSRC_12}, $SOURCES{MSRC_13}, $SOURCES{MSRC_14}, $SOURCES{MSRC_15},
		           $SOURCES{MSRC_16}, $SOURCES{MSRC_17}, $SOURCES{MSRC_18}, $SOURCES{MSRC_19}, $SOURCES{MSRC_20},
		           $SOURCES{MSRC_21}, $SOURCES{MSRC_22}, $SOURCES{MSRC_23}, $SOURCES{MSRC_24}, $SOURCES{MSRC_25},
		           $SOURCES{MSRC_26}, $SOURCES{MSRC_27}, $SOURCES{MSRC_28}, $SOURCES{MSRC_29}, $SOURCES{MSRC_30},
		           $SOURCES{MSRC_31}, $SOURCES{MSRC_32}, $SOURCES{MSRC_33}, $SOURCES{MSRC_34}, $SOURCES{MSRC_35},
		           $SOURCES{MSRC_36}, $SOURCES{MSRC_37}, $SOURCES{MSRC_38}, $SOURCES{MSRC_39}, $SOURCES{MSRC_40},
		           $SOURCES{MSRC_41}, $SOURCES{MSRC_42}, $SOURCES{MSRC_43}, $SOURCES{MSRC_44}, $SOURCES{MSRC_45}, ],
		S46_90 => [ $SOURCES{MSRC_46}, $SOURCES{MSRC_47}, $SOURCES{MSRC_48}, $SOURCES{MSRC_49}, $SOURCES{MSRC_50},
		            $SOURCES{MSRC_51}, $SOURCES{MSRC_52}, $SOURCES{MSRC_53}, $SOURCES{MSRC_54}, $SOURCES{MSRC_55},
		            $SOURCES{MSRC_56}, $SOURCES{MSRC_57}, $SOURCES{MSRC_58}, $SOURCES{MSRC_59}, $SOURCES{MSRC_60},
		            $SOURCES{MSRC_61}, $SOURCES{MSRC_62}, $SOURCES{MSRC_63}, $SOURCES{MSRC_64}, $SOURCES{MSRC_65},
		            $SOURCES{MSRC_66}, $SOURCES{MSRC_67}, $SOURCES{MSRC_68}, $SOURCES{MSRC_69}, $SOURCES{MSRC_70},
		            $SOURCES{MSRC_71}, $SOURCES{MSRC_72}, $SOURCES{MSRC_73}, $SOURCES{MSRC_74}, $SOURCES{MSRC_75},
		            $SOURCES{MSRC_76}, $SOURCES{MSRC_77}, $SOURCES{MSRC_78}, $SOURCES{MSRC_79}, $SOURCES{MSRC_80},
		            $SOURCES{MSRC_81}, $SOURCES{MSRC_82}, $SOURCES{MSRC_83}, $SOURCES{MSRC_84}, $SOURCES{MSRC_85},
		            $SOURCES{MSRC_86}, $SOURCES{MSRC_87}, $SOURCES{MSRC_88}, $SOURCES{MSRC_89}, $SOURCES{MSRC_90}, ],
		S1_90 => [ $SOURCES{MSRC_01}, $SOURCES{MSRC_02}, $SOURCES{MSRC_03}, $SOURCES{MSRC_04}, $SOURCES{MSRC_05},
		           $SOURCES{MSRC_06}, $SOURCES{MSRC_07}, $SOURCES{MSRC_08}, $SOURCES{MSRC_09}, $SOURCES{MSRC_10},
		           $SOURCES{MSRC_11}, $SOURCES{MSRC_12}, $SOURCES{MSRC_13}, $SOURCES{MSRC_14}, $SOURCES{MSRC_15},
		           $SOURCES{MSRC_16}, $SOURCES{MSRC_17}, $SOURCES{MSRC_18}, $SOURCES{MSRC_19}, $SOURCES{MSRC_20},
		           $SOURCES{MSRC_21}, $SOURCES{MSRC_22}, $SOURCES{MSRC_23}, $SOURCES{MSRC_24}, $SOURCES{MSRC_25},
		           $SOURCES{MSRC_26}, $SOURCES{MSRC_27}, $SOURCES{MSRC_28}, $SOURCES{MSRC_29}, $SOURCES{MSRC_30},
		           $SOURCES{MSRC_31}, $SOURCES{MSRC_32}, $SOURCES{MSRC_33}, $SOURCES{MSRC_34}, $SOURCES{MSRC_35},
		           $SOURCES{MSRC_36}, $SOURCES{MSRC_37}, $SOURCES{MSRC_38}, $SOURCES{MSRC_39}, $SOURCES{MSRC_40},
		           $SOURCES{MSRC_41}, $SOURCES{MSRC_42}, $SOURCES{MSRC_43}, $SOURCES{MSRC_44}, $SOURCES{MSRC_45},
		           $SOURCES{MSRC_46}, $SOURCES{MSRC_47}, $SOURCES{MSRC_48}, $SOURCES{MSRC_49}, $SOURCES{MSRC_50},
		           $SOURCES{MSRC_51}, $SOURCES{MSRC_52}, $SOURCES{MSRC_53}, $SOURCES{MSRC_54}, $SOURCES{MSRC_55},
		           $SOURCES{MSRC_56}, $SOURCES{MSRC_57}, $SOURCES{MSRC_58}, $SOURCES{MSRC_59}, $SOURCES{MSRC_60},
		           $SOURCES{MSRC_61}, $SOURCES{MSRC_62}, $SOURCES{MSRC_63}, $SOURCES{MSRC_64}, $SOURCES{MSRC_65},
		           $SOURCES{MSRC_66}, $SOURCES{MSRC_67}, $SOURCES{MSRC_68}, $SOURCES{MSRC_69}, $SOURCES{MSRC_70},
		           $SOURCES{MSRC_71}, $SOURCES{MSRC_72}, $SOURCES{MSRC_73}, $SOURCES{MSRC_74}, $SOURCES{MSRC_75},
		           $SOURCES{MSRC_76}, $SOURCES{MSRC_77}, $SOURCES{MSRC_78}, $SOURCES{MSRC_79}, $SOURCES{MSRC_80},
		           $SOURCES{MSRC_81}, $SOURCES{MSRC_82}, $SOURCES{MSRC_83}, $SOURCES{MSRC_84}, $SOURCES{MSRC_85},
		           $SOURCES{MSRC_86}, $SOURCES{MSRC_87}, $SOURCES{MSRC_88}, $SOURCES{MSRC_89}, $SOURCES{MSRC_90}, ],
	);

	return $RES_OK;
}

#------------------------------------------------------------------------------
# Term
#   Terminate the test sequence.
#   <IN>  rtn: Result ID
#------------------------------------------------------------------------------
sub Term($) {
my ($rtn) = @_;
my $link;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "Term($rtn)");
	}

	# Stop listening to operated multicasts.
	if ($CONF_DATA{STOP_LISETENING} != 0) {
		StopListening();
	}

	# Stop MLD on the HUT
	if ($CONF_DATA{mldv2DisableHUT} != 0) {
		if ($DEBUG > 1) {
			InfoDebug(__FILE__, __LINE__, "mldv2DisableHUT.rmt");
		}
		vRemote("mldv2DisableHUT.rmt");
		# ignore error here
	}

	# Stop the capture.
	foreach $link (@T_LINK) {
		vStop($link);
		# If an error causes, it terminates freely with exitFatal.
	}

	# Terminate with result ID.
	if ($rtn == $RES_OK) {
		vLogBlue("<BR><B>Total Result: PASS.</B>");
		exit $V6evalTool::exitPass;
	}
	elsif ($rtn == $RES_NG) {
		vLogRed("<BR><B>Total Result: FAIL.</B>");
		exit $V6evalTool::exitFail;
	}
	elsif ($rtn == $RES_WAR) {
		vLogGreen("<BR><B>Total Result: WARNING.</B>");
		exit $V6evalTool::exitWarn;
	}
	else {
		vLogRed("INTERNAL ERROR: Term(), Result ID $rtn is an unknown ID.");
		exit $V6evalTool::exitFatal;
	}
}

#------------------------------------------------------------------------------
# StopListening
#   Call ListenerAPI on the HUT by Remote.
#   <IN>  $seq   : Key of %T_SEQ
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub StopListening() {
my $socket;
my $if;
my $mcast;
my $arg;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "StopListening()");
	}

	# Output the caption.
	vLog1("Stop Listening");

	# all multicast
	if ($CONF_DATA{mldv2ListenerAPI} != 0) {
		foreach $socket (keys %STACK_MCAST) {
			($if, $mcast) = (@{$STACK_MCAST{$socket}});
			$arg .= "$socket,$if,$mcast,INCLUDE,0";
			vRemote("mldv2ListenerAPI.rmt", "arg=$arg");
		}
	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# ConfProc
#   Call the remote file (mldv2SetHUT.rmt) that sets up HUT.
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub ConfProc($) {
my ($seq) = @_;
my (%data) = %{$T_SEQ{$seq}};
my $caption;
my $rtn = $RES_OK;
my $ckey;
my $arg = "";

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "ConfProc($seq)");
	}

	# Output the caption.
	if (defined $data{caption}) {
		foreach $caption (@{$data{caption}}) {
			vLog1("$caption");
		}
	}

	# Stop MLD on the HUT
	if ($CONF_DATA{mldv2DisableHUT} != 0) {
		if ($DEBUG > 1) {
			InfoDebug(__FILE__, __LINE__, "mldv2DisableHUT.rmt");
		}
		$rtn = vRemote("mldv2DisableHUT.rmt");
		if ($rtn != $RES_OK) {
			vLogRed("FAIL: $V6evalTool::NutDef{System}/mldv2DisableHUT.rmt.");
			exit $V6evalTool::exitFail;
		}
	}

	# Create the argument of the remote.
	# MUST item
	foreach $ckey (@CONF_FOR_RMT) {
		# Check the key about the internal inconsistency.
		unless (defined $CONF_DATA{$ckey}) {
			vLogRed("INTERNAL ERROR: ConfProc(), CONF_FOR_RMT{ $ckey } is an unknown item.");
			exit $V6evalTool::exitFatal;
		}

		# Create the argument.
		$arg .= "$ckey,$CONF_DATA{$ckey},";
	}
	# Specific item
	foreach $ckey (@CONF_FOR_RMT_2) {
		# Check the key about the internal inconsistency.
		unless (defined $CONF_DATA{$ckey}) {
			vLogRed("INTERNAL ERROR: ConfProc(), CONF_FOR_RMT_2{ $ckey } is an unknown item.");
			exit $V6evalTool::exitFatal;
		}

		# Necessary, only when specified.
		unless (defined $T_CONF{$ckey}) {
			next;
		}
		# Create the argument.
		$arg .= "$ckey,$CONF_DATA{$ckey},";
	}
	# Specific SSM item
	if (defined $T_CONF{SSM_RANGE}) {
		foreach $ckey (@CONF_FOR_RMT_3) {
			# Check the key about the internal inconsistency.
			unless (defined $CONF_DATA{$ckey}) {
				vLogRed("INTERNAL ERROR: ConfProc(), CONF_FOR_RMT_3{ $ckey } is an unknown item.");
				exit $V6evalTool::exitFatal;
			}

			# Create the argument.
			$arg .= "$ckey,$CONF_DATA{$ckey},";
		}
	}
	substr($arg, -1) = "";

	# Setup MLD on the HUT.
	if ($CONF_DATA{mldv2SetHUT} != 0) {
		if ($DEBUG > 1) {
			InfoDebug(__FILE__, __LINE__, "mldv2SetHUT.rmt, $arg.");
		}
		$rtn = vRemote("mldv2SetHUT.rmt", "arg=$arg");
		if ($rtn != $RES_OK) {
			vLogRed("FAIL: $V6evalTool::NutDef{System}/mldv2SetHUT.rmt.");
			exit $V6evalTool::exitFail;
		}
	}

	# End of Configure
	if ($PROC == 2) {
		exit $V6evalTool::exitPass;
	}

	return $rtn;
}

#------------------------------------------------------------------------------
# BootProc
#   Boot the HUT.
#   <IN>  $seq   : Key of %T_SEQ
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub BootProc($) {
my ($seq) = @_;
my (%data) = %{$T_SEQ{$seq}};
my $caption;
my $link;
my $wk;
my $node;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "BootProc($seq)");
	}

	# Boot flag
	$BOOT = 1;

	# Output the caption.
	if (defined $data{caption}) {
		foreach $caption (@{$data{caption}}) {
			vLog1("$caption");
		}
	}

	# Start the capture.
	foreach $link (@T_LINK) {
		vCapture($link);
		# If an error causes, it terminates freely with exitFatal.
		vClear($link);
		# If an error causes, it terminates freely with exitFatal.
	}

	# Clear loging data
	# Some tests rerun. Therefore, previous log data are eliminated by this Proc.
	@STACK_LINK0_QG =();
	@STACK_LINK1_QG =();
	@STACK_LINK0_R =();
	@STACK_LINK1_R =();
	%STACK_S = ();

	# Reboot
	if ($CONF_DATA{reboot} != 0) {
		if ($DEBUG > 1) {
			InfoDebug(__FILE__, __LINE__, "reboot.rmt");
		}
		$wk = vRemote("reboot.rmt");
		if ($wk != $RES_OK) {
			vLogRed("FAIL: $V6evalTool::NutDef{System}/reboot.rmt.");
			exit $V6evalTool::exitFail;
		}
	}

	# Start MLD on HUT
	if ($CONF_DATA{mldv2EnableHUT} != 0) {
		if ($DEBUG > 1) {
			InfoDebug(__FILE__, __LINE__, "mldv2EnableHUT.rmt");
		}
		$wk = vRemote("mldv2EnableHUT.rmt");
		if ($wk != $RES_OK) {
			vLogRed("FAIL: $V6evalTool::NutDef{System}/mldv2EnableHUT.rmt.");
			exit $V6evalTool::exitFail;
		}
	}

	# Advertise the neighbor nodes.
	foreach $node (@T_NODE) {
		no strict 'refs';

		if (defined ${$node}{RA}) {
			vSend(${$node}{IF}, ${$node}{RA});
			# If an error causes, it terminates freely with exitFatal.
		}

		vSend(${$node}{IF}, ${$node}{NAL});
		# If an error causes, it terminates freely with exitFatal.
	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# EnableProc
#   Enable MLDv2 on the HUT.
#   <IN>  $seq   : Key of %T_SEQ
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub EnableProc($) {
my ($seq) = @_;
my (%data) = %{$T_SEQ{$seq}};
my $caption;
my $link;
my $wk;
my $node;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "EnableProc($seq)");
	}

	# Output the caption.
	if (defined $data{caption}) {
		foreach $caption (@{$data{caption}}) {
			vLog1("$caption");
		}
	}

	# Start the capture.
	foreach $link (@T_LINK) {
		vCapture($link);
		# If an error causes, it terminates freely with exitFatal.
		vClear($link);
		# If an error causes, it terminates freely with exitFatal.
	}

	# Clear loging data
	# Some tests rerun. Therefore, previous log data are eliminated by this Proc.
	@STACK_LINK0_QG =();
	@STACK_LINK1_QG =();
	@STACK_LINK0_R =();
	@STACK_LINK1_R =();
	%STACK_S = ();

	# Start MLD on the HUT
	if ($CONF_DATA{mldv2EnableHUT} != 0) {
		if ($DEBUG > 1) {
			InfoDebug(__FILE__, __LINE__, "mldv2EnableHUT.rmt");
		}
		$wk = vRemote("mldv2EnableHUT.rmt");
		if ($wk != $RES_OK) {
			vLogRed("FAIL: $V6evalTool::NutDef{System}/mldv2EnableHUT.rmt.");
			exit $V6evalTool::exitFail;
		}
	}

	# Advertise the neighbor nodes.
	foreach $node (@T_NODE) {
		no strict 'refs';

		if (defined ${$node}{RA}) {
			vSend(${$node}{IF}, ${$node}{RA});
			# If an error causes, it terminates freely with exitFatal.
		}

		vSend(${$node}{IF}, ${$node}{NAL});
		# If an error causes, it terminates freely with exitFatal.
	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# ListenerProc
#   Call ListenerAPI on the HUT by Remote.
#   <IN>  $seq   : Key of %T_SEQ
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub ListenerProc($) {
my ($seq) = @_;
my (%data) = %{$T_SEQ{$seq}};
my $socket = $data{socket};
my $if     = $CONF_DATA{$data{if}};
my $mcast  = $CONF_DATA{$data{mcast}};
my $filter = $data{filter};
my $srcnum = $data{srcnum};
my @source = @{$SOURCE_LISTS{$data{source}}};
my $caption;
my $arg = "";
my $src;
my $rtn;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "ListenerProc($seq)");
	}

	# Output the caption.
	if (defined $data{caption}) {
		foreach $caption (@{$data{caption}}) {
			vLog1("$caption");
		}
	}

	# In order to stop listening
	@{$STACK_MCAST{$socket}} = ($if, $mcast);

	# make argument
	$arg .= "$socket,$if,$mcast,$filter,$srcnum";
	foreach $src (@source) {
		$arg .= ",$src";
	}

	# Call ListenerAPI
	if ($CONF_DATA{mldv2ListenerAPI} != 0) {
		if ($DEBUG > 1) {
			InfoDebug(__FILE__, __LINE__, "--------------------------------------");
			InfoDebug(__FILE__, __LINE__, "ListenerAPI($arg)");
			InfoDebug(__FILE__, __LINE__, "--------------------------------------");
		}

		$rtn = vRemote("mldv2ListenerAPI.rmt", "arg=$arg");
		if ($rtn != $RES_OK) {
			vLogRed("FAIL: $V6evalTool::NutDef{System}/mldv2ListenerAPI.rmt.");
			exit $V6evalTool::exitFail;
		}
	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# BaseProc
#   Basic processing of a procedure.
#   It uses for the alternative processing at the time of the procedure change
#   by some option.
#   <IN>  $seq   : Key of %T_SEQ
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub BaseProc($) {
my ($seq) = @_;
my (%data) = %{$T_SEQ{$seq}};
my $caption;
my $link;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "BaseProc($seq)");
	}

	# Output the caption.
	if (defined $data{caption}) {
		foreach $caption (@{$data{caption}}) {
			vLog1("$caption");
		}
	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# SendProc
#   Send the message.
#   <IN>  $seq   : Key of %T_SEQ
#   <RTN> $RES_OK: Good.
#------------------------------------------------------------------------------
sub SendProc($) {
my ($seq) = @_;
my (%data) = %{$T_SEQ{$seq}};
my $caption;
my $link  = $data{link};
my @msgs  = @{$data{msgs}};
my $msg;
my %vrtn;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "SendProc($seq)");
	}

	# Output the caption.
	if (defined $data{caption}) {
		foreach $caption (@{$data{caption}}) {
			vLog1("$caption");
		}
	}

	# Send the message.
	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "--------------------------------------");
		InfoDebug(__FILE__, __LINE__, "vSend($link, @msgs)");
		InfoDebug(__FILE__, __LINE__, "--------------------------------------");
	}

	foreach $msg (@msgs) {
		%vrtn = vSend($link, $msg);
		# If an error causes, it terminates freely with exitFatal.
		$vrtn{Time}  = $vrtn{sentTime1};
		$vrtn{Frame} = "$msg";
		$vrtn{PKTNO} = ($V6evalTool::vSendPKT) - 1;

		# Store the message to STACK_S.
		if (defined $data{stack}) {
			if ($DEBUG > 2) {
				InfoDebug(__FILE__, __LINE__, "Store the message to STACK_S{$data{stack}}{$msg}.");
			}
			push @{$STACK_S{$data{stack}}}, {%vrtn};
		}
	}

	# Store the general query to STACK_QG_LINK.
	# Since a message does not have multiple, it places out of a loop.
#	if (defined $data{qg_str}) {
#		if ($link eq "Link0") {
#			if ($DEBUG > 2) {
#				InfoDebug(__FILE__, __LINE__, "Store the general query to STACK_LINK0_QG.");
#			}
#			push @STACK_LINK0_QG, {%vrtn};
#		}
#		elsif ($link eq "Link1") {
#			if ($DEBUG > 2) {
#				InfoDebug(__FILE__, __LINE__, "Store the general query to STACK_LINK1_QG.");
#			}
#			push @STACK_LINK1_QG, {%vrtn};
#		}
#	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# RecvProc
#   Receive the message.
#   <IN>  $seq   : Key of %T_SEQ
#   <RTN> $RES_OK: Good.
#         $RES_NG: No Good.
#         $RES_WR: No Good.
#------------------------------------------------------------------------------
sub RecvProc($) {
my ($seq) = @_;
my (%data) = %{$T_SEQ{$seq}};
my $caption;
my $link = $data{link};
my $count = $data{count};
my @msgs = @{$data{msgs}};
my %vrtn;
my %vref;
my $wk;
my $i;
my $strtime = 0;
my $wtime0;
my $wtime1;
my $curtime;
my $endtime;
my $diftime;
my $msg;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "RecvProc($seq)");
		
		# Internal Check
		if (($count > 1) && ($data{status} != 0)) {
			vLogRed("INTERNAL ERROR: RecvProc(), T_SEQ{ $seq }, count, status.");
		}
		if (($data{status} != 0) && (defined $data{stack})) {
			vLogRed("INTERNAL ERROR: RecvProc(), T_SEQ{ $seq }, status, stack.");
		}
	}

	# Output the caption.
	if (defined $data{caption}) {
		foreach $caption (@{$data{caption}}) {
			vLog1("$caption");
		}
	}

	# Synchronize with the define file.
	if (defined $data{cpp}) {
		if ($DEBUG > 1) {
			InfoDebug(__FILE__, __LINE__, "vCPP($data{cpp})");
		}
		vCPP($data{cpp});
		# If an error causes, it terminates freely with exitFatal.
	}

	# Get the start time.
	if (defined $data{stime}) {
		%vref = %{    $STACK_S{$data{stime}[0]}[$data{stime}[1]]};
		if (defined $vref{Time}) {
			$strtime = $vref{sentTime1};
		}
		else {
			vLogRed("INTERNAL ERROR: RecvProc(), Start time is not acquired, STACK_S{$1}[$2].");
			exit $V6evalTool::exitFatal;
		}
	}

	unless (defined $data{wtime}[0]) {
			vLogRed("INTERNAL ERROR: RecvProc(), Wait time is not specified.");
			exit $V6evalTool::exitFatal;
	}
	$wtime0 = $data{wtime}[0];
	$wtime1 = (defined $data{wtime}[1]) ? $data{wtime}[1]: $data{wtime}[0];

	if ($DEBUG > 2) {
		InfoDebug(__FILE__, __LINE__, "RecvProc(), $link, [$strtime], $wtime0 [$wtime1], $count, @msgs.");
	}

	# Repeat to the count.
	for ($i = 0; $i < $count; $i ++) {

		# Set working times.
		$curtime = time;
		if ($strtime == 0) {
			$strtime = $curtime;
		}
		if ($i == 0) {
			$endtime = $strtime + $wtime0;
		}
		else {
			$endtime = $strtime + $wtime1;
		}
#		if ($DEBUG > 2) {
#			InfoDebug(__FILE__, __LINE__, "vRecv(), strtime is $strtime.");
#			InfoDebug(__FILE__, __LINE__, "vRecv(), curtime is $curtime.");
#			InfoDebug(__FILE__, __LINE__, "vRecv(), endtime is $endtime.");
#		}
		$strtime = 0;

		if ($curtime > $endtime) {
			vLogRed("INTERNAL ERROR: RecvProc(), The Current time and end time are mismatching.");
			exit $V6evalTool::exitFatal;
		}

		# Repeat to end time.
		while ($curtime < $endtime) {
			# The remaining time.
			$diftime = $endtime - $curtime;

			# Receive some message.
			if ($DEBUG > 1) {
				InfoDebug(__FILE__, __LINE__, "--------------------------------------");
				InfoDebug(__FILE__, __LINE__, "vRecv($link, $diftime, 0, 1, @msgs)");
				InfoDebug(__FILE__, __LINE__, "--------------------------------------");
			}
			%vrtn = vRecv($link, $diftime, 0, 1, @msgs, @{$AUTO_MSG{$link}});
			$vrtn{Time}  = $vrtn{recvTime1};
			$vrtn{Frame} = $vrtn{recvFrame};
			$vrtn{PKTNO} = ($V6evalTool::vRecvPKT) - 1;

			if ($vrtn{status} == 0) {
				if ($DEBUG > 2) {
					InfoDebug(__FILE__, __LINE__, "vRecv() => $vrtn{recvTime1}, $vrtn{recvFrame}, $vrtn{PKTNO}.");
				}

				# Automatic processing.
				if (defined $AUTO_PROC{$link}{$vrtn{recvFrame}}) {
					no strict 'refs';
					$wk = &{$AUTO_PROC{$link}{$vrtn{recvFrame}}}($link, \%vrtn);
					if ($wk != $RES_OK) {
						$vrtn{status} = -1;
						last;
					}
				}

				# BINGO !!
				foreach $msg (@msgs) {
					if ($msg eq $vrtn{recvFrame}) {
						# Store the message to STACK_S.
						if (defined $data{stack}) {
							if ($DEBUG > 2) {
								InfoDebug(__FILE__, __LINE__, "Store the message to STACK_S{$data{stack}}.");
							}
							push @{$STACK_S{$data{stack}}}, {%vrtn};
						}
						goto RecvProc_1;
					}
				}

				# The target message has not been received yet.
				$curtime = ($vrtn{recvTime1} > $curtime) ? $vrtn{recvTime1}: $curtime;
				$vrtn{status} = 1;
			}
			elsif ($vrtn{status} == 1) {
				if ($DEBUG > 2) {
					InfoDebug(__FILE__, __LINE__, "vRecv() => $endtime, Timeout.");
				}
				$curtime = $endtime;
			}
			elsif ($vrtn{status} == 2) {
#				if ($DEBUG > 2) {
#					InfoDebug(__FILE__, __LINE__, "vRecv() => $vrtn{recvTime1}, Unexpect.");
#				}
				print "Recv: Unexpect packet\n";
				$curtime = $vrtn{recvTime1};
				$vrtn{status} = 1;
			}
			else {
				vLogRed("INTERNAL ERROR: RecvProc(), vRecv($link, $diftime, 0, 1, @msgs, @{$AUTO_MSG{$link}}) => $vrtn{status}.");
				exit $V6evalTool::exitFatal;
			}
		}

		# End judging
		RecvProc_1:
		if ($vrtn{status} != 0) {
			last;
		}
	}

	if ($vrtn{status} != $data{status}) {
		if ($vrtn{status} == 1) {
			if ($i == 0) {
				vLogRed("	FAIL: The assumed message with the assumed field value was not received within $wtime0 second(s) $count times.");
			}
			else {
				vLogRed("	FAIL: The assumed message with the assumed field value was not received within $wtime1 second(s) $count times.");
			}
			foreach $msg (@msgs) {
				($wk) = (split /:/, $pktdesc{$msg})[1];
				vLogRed("		Assumed message: $wk");
			}
		}
		elsif ($vrtn{status} == 0) {
			vLogRed("	FAIL: The unexpected message was received.");
		}
		elsif ($vrtn{status} == -1) {
			vLogRed("	FAIL: The unexpected message was received.");
		}
		else {
			vLogRed("	INTERNAL ERROR: RecvProc(), Unknown status ($vrtn{status}).");
			exit $V6evalTool::exitFatal;
		}
		return $RES_NG;
	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# AutoProc_RS
#   Automatic processing for received message.
#   <IN>  $link  : Link.
#         %vref  : Received message.
#   <RTN> $RES_OK: Good.
#         $RES_NG: No Good.
#         $RES_WR: No Good.
#------------------------------------------------------------------------------
sub AutoProc_RS($%) {
my ($link, $vref) = @_;
my $node;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "AutoProc_RS($link, $vref)");
	}

	# Send RA.
	foreach $node (@T_NODE) {
		no strict 'refs';
		if (${$node}{IF} eq $link) {
			if (defined ${$node}{RA}) {
				vSend(${$node}{IF}, ${$node}{RA});
				# If an error causes, it terminates freely with exitFatal.
			}
		}
	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# AutoProc_NS
#------------------------------------------------------------------------------
sub AutoProc_NS($%) {
my ($link, $vref) = @_;
my (%vref) = %{$vref};
my $node;
my $target;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "AutoProc_NS($link, $vref)");
	}

	# Get target address.
	unless (defined $vref{'Frame_Ether.Packet_IPv6.ICMPv6_NS.TargetAddress'}) {
		vLogRed("INTERNAL ERROR: AutoProc_NS(), There is no TargetAddress field.");
		exit $V6evalTool::exitFatal;
	}
	$target = $vref{'Frame_Ether.Packet_IPv6.ICMPv6_NS.TargetAddress'};
	if ($DEBUG > 2) {
		InfoDebug(__FILE__, __LINE__, "AutoProc_NS(), Target address is $target.");
	}

	# Send NA.
	foreach $node (@T_NODE) {
		no strict 'refs';
		if (${$node}{IF} eq $link) {
			if (${$node}{LLOCAL} eq $target) {
				vSend(${$node}{IF}, ${$node}{NAL});
				# If an error causes, it terminates freely with exitFatal.
				last;
			}
			elsif (${$node}{GLOBAL} eq $target) {
				vSend(${$node}{IF}, ${$node}{NAG});
				# If an error causes, it terminates freely with exitFatal.
				last;
			}
		}
	}

	return $RES_OK;
}

#------------------------------------------------------------------------------
# AutoProc_RA
#------------------------------------------------------------------------------
sub AutoProc_RA($%) {
my ($link, $vref) = @_;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "AutoProc_RA($link, $vref)");
	}

	# no reaction.

	return $RES_OK;
}

#------------------------------------------------------------------------------
# AutoProc_NA
#------------------------------------------------------------------------------
sub AutoProc_NA($%) {
my ($link, $vref) = @_;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "AutoProc_NA($link, $vref)");
	}

	# no reaction.

	return $RES_OK;
}

#------------------------------------------------------------------------------
# AutoProc_Qany
#------------------------------------------------------------------------------
sub AutoProc_Qany($%) {
my ($link, $vref) = @_;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "AutoProc_Qany($link, $vref)");
	}

	# This is unknown query.
	vLogRed("WARNING: The strange query is received.");

	# The message which avoids a check for debugging.
	if ($CONF_DATA{CHECK_UNEXPECT_QUERY} == 0) {
		return $RES_OK;
	}

	return $RES_WAR;
}

#------------------------------------------------------------------------------
# AutoProc_Rany
#------------------------------------------------------------------------------
sub AutoProc_Rany($%) {
my ($link, $vref) = @_;
my (%vref) = %{$vref};

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "AutoProc_Rany($link, $vref)");
	}

	# Store report message
	if ($link eq "Link0") {
		if ($DEBUG > 2) {
			InfoDebug(__FILE__, __LINE__, "Store the report to STACK_LINK0_R.");
		}
		push @STACK_LINK0_R, {%vref};
	}
	elsif ($link eq "Link1") {
		if ($DEBUG > 2) {
			InfoDebug(__FILE__, __LINE__, "Store the report to STACK_LINK1_R.");
		}
		push @STACK_LINK1_R, {%vref};
	}
	else {
		vLogRed("INTERNAL ERROR: AutoProc_Rany(), $link is an unknown link.");
		exit $V6evalTool::exitFatal;
	}

	# The message which avoids a check for debugging.
	if ($CONF_DATA{CHECK_UNEXPECT_REPORT} == 0) {
		return $RES_OK;
	}

	return $RES_WAR;
}

#------------------------------------------------------------------------------
# JudgeCommon
#   Check common result data.
#   <RTN> $RES_OK: Good.
#         $RES_NG: No Good.
#         $RES_WR: No Good.
#------------------------------------------------------------------------------
sub JudgeCommon() {
my $rtn = $RES_OK;
my $wk;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "JudgeCommon()");
	}

	# Check the startup report in link0.
#	$wk = JudgeStartupReport("Link0", "L0SR");
#	if (($wk != $RES_OK) && ($rtn == $RES_OK)) {
#		$rtn = $wk;
#	}

	# Check the startup report in link1.
#	if (@T_LINK == 2) {
#		$wk = JudgeStartupReport("Link1", "L1SR");
#		if (($wk != $RES_OK) && ($rtn == $RES_OK)) {
#			$rtn = $wk;
#		}
#	}

	return $rtn;
}

#------------------------------------------------------------------------------
#  JudgeStackMsgIDandNum
#   Judge the message ID and the number in a stack.
#   <IN>  $stackid: Key in %STACK_S{}
#         $count  : Count of each message
#         @msgs   : Message ID
#   <RTN> $RES_OK : Agreement.
#         $RES_NG : Disagreement.
#------------------------------------------------------------------------------
sub JudgeStackMsgIDandNum($$@) {
my ($stackid, $count, @msgs) = @_;
my $rtn = $RES_OK;
my $vref;
my %vref;
my $msg;
my $num;
my $wk;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "JudgeStackMsgIDandNum($stackid, $count, @msgs)");
	}

	# Judgment evasion

	# Caption
	# (Since there are details, it is a call side.)

	# Get target data.
	unless (defined $STACK_S{$stackid}) {
		vLogRed("	There is no message.");
		return $RES_NG;
	}

	# Check message ID
	foreach $vref (@{$STACK_S{$stackid}}) {
		%vref = %{$vref};

		# Caption msg
		unless (defined $vref{Frame}) {
			vLog0("	<A HREF=\"#vRecvPKT$vref{PKTNO}\">Non-target message.</A>");
			vLogRed("INTERNAL ERROR: JudgeStackMsgIDandNum(), STACK_S{$stackid} has a non-target message.");
			exit $V6evalTool::exitFatal;
		}
		vLog0("	<A HREF=\"#vRecvPKT$vref{PKTNO}\">$vref{Frame}</A>");

		# Create the separated stack.
		push @{$STACK_S{$stackid . "_" . $vref{Frame}}}, {%vref};
	}

	# Check message number
	foreach $msg (@msgs) {

		if (defined $STACK_S{$stackid . "_" . $msg}) {
			$num = @{$STACK_S{$stackid . "_" . $msg}};
		}
		else {
			$num = 0;
		}

		# Message name
		($wk) = (split /:/, $pktdesc{$msg})[1];

		# Judge
		vLog0("	INFO: Number of message $wk, $num.");
		if ($num < $count) {
			vLogRed("		FAIL: There are few reports compared with standard $count.");
			$rtn = $RES_NG;
		}
		elsif ($num > $count) {
			vLogRed("		FAIL: There are many reports compared with standard $count.");
			$rtn = $RES_NG;
		}
	}

	return $rtn;
}

#------------------------------------------------------------------------------
# JudgeStartupReport
#   Check the startup report at booting or enabling.
#   <IN>  $link   : Link.
#         $stack_r: Startup report stack.
#   <RTN> $RES_OK: Agreement.
#         $RES_NG: Disagreement.
#------------------------------------------------------------------------------
sub JudgeStartupReport($$) {
my ($link, $stack_r) = @_;
my $rtn = $RES_OK;
my @stack_r = @{$STACK_S{$stack_r}};
my $sol_mcast;
my $vref;
my %vref;
my $eflag = 0;
my %rcdlst;
my $wk;
my $sl = 0;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "JudgeStartupReport($link, $stack_r)");
	}

	# Judgment evasion
	if ($CONF_DATA{CHECK_STARTUP_REPORT} == 0) {
		return $rtn;
	}
	if (($BOOT == 0) && ($CONF_DATA{FUNC_ENABLE_REPORT} == 0)) {
		return $rtn;
	}

	# Caption judgement
	if ($BOOT == 1) {
		vLog1("Judge: Startup (Bootup) MLDv2 Report on $link.");
	}
	else {
		vLog1("Judge: Startup (Enable) MLDv2 Report on $link.");
	}

	# Get target data on link.
	if ($link eq "Link0") {
		$sol_mcast = $CONF_DATA{HUT0_SOL_MCAST};
	}
	elsif ($link eq "Link1") {
		$sol_mcast = $CONF_DATA{HUT1_SOL_MCAST};
	}
	else {
		vLogRed("INTERNAL ERROR: JudgeStartupReport(), $link is worng.");
		exit $V6evalTool::exitFatal;
	}

	# Check the startup report.
	foreach $vref (@stack_r) {
		%vref = %{$vref};

		# Message is exist.
		$eflag = 1;

		# Caption msg
		vLog0("	<A HREF=\"#vRecvPKT$vref{PKTNO}\">Startup MLDv2 Report.</A>");

		# Get the record data from report.
		%rcdlst = GetReportRcd(\%vref);

		# Count
		if ($BOOT == 1) {
			# Compare the record data with link-local solicitation multicast of interface.
			$wk = CompRecord(\%rcdlst, "$sol_mcast", 4, "NULL", 0);
			if ($wk == $RES_OK) {
				$sl ++;
			}
		}
	}

	# Pre Judge
	if ($eflag == 0) {
		vLogRed("	FAIL: There is no Startup Report.");
		return $RES_NG;
	}

	# Caption judgement
	vLog1("Judge: Startup Rreport record summary.");

	# Judge
	if ($BOOT == 1) {
		vLog0("	INFO: Number of records T0_EX() for RUT solicited-node multicast address, $sl.");
		if ($sl < $CONF_DATA{RV}) {
			vLogRed("		FAIL: There are few records compared with standard $CONF_DATA{RV}.");
			$rtn = $RES_NG;
		}
		elsif ($sl > $CONF_DATA{RV}) {
			vLogRed("		FAIL: There are many records compared with standard $CONF_DATA{RV}.");
			$rtn = $RES_NG;
		}
	}

	return $rtn;
}

#------------------------------------------------------------------------------
# JudgeGeneralReport
#   Check the general report for general query.
#   <IN>  %vref  : Report message to be checked.
#         $link  : Link.
#   <RTN> $RES_OK: Agreement.
#         $RES_NG: Disagreement.
#------------------------------------------------------------------------------
sub JudgeGeneralReport(%$) {
my ($vref, $link) = @_;
my %vref = %{$vref};
my $rtn = $RES_OK;
my %rcdlst;
my $wk;
my $sol_mcast;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "JudgeGeneralReport($vref, $link)");
	}

	# Judgment evasion
	if ($CONF_DATA{CHECK_GENERAL_REPORT} == 0) {
		return $rtn;
	}

	# Caption
	# (Since there are details, it is a call side.)

	# Caption msg
	vLog0("	<A HREF=\"#vRecvPKT$vref{PKTNO}\">General MLDv2 Report.</A>");

	# Get target data.
	%rcdlst = GetReportRcd(\%vref);

	# Get target data on link.
	if ($link eq "Link0") {
		$sol_mcast = $CONF_DATA{HUT0_SOL_MCAST};
	}
	elsif ($link eq "Link1") {
		$sol_mcast = $CONF_DATA{HUT1_SOL_MCAST};
	}
	else {
		vLogRed("INTERNAL ERROR: JudgeGeneralReport(), $link is an unknown link.");
		exit $V6evalTool::exitFatal;
	}

	# Compare the record data with link-local solicitation multicast of interface.
	$wk = CompRecord(\%rcdlst, $sol_mcast, 2, "NULL", 1);
	if ($wk != $RES_OK) {
		$rtn = $RES_NG;
	}

	return $rtn;
}

#------------------------------------------------------------------------------
# JudgeStackReportRecord
#   Check the source list of Query.
#   <IN>  $stackid: Key in %STACK_S{}
#         $mcast  : Multicast to compare.
#         $type   : Record type to expect.
#         $srcid  : ID of the source list to expect.
#         $num    : number of each source.
#   <RTN> $RES_OK: Agreement.
#         $RES_NG: Disagreement.
#------------------------------------------------------------------------------
sub JudgeStackReportRecord($$$$$) {
my ($stackid, $mcast, $type, $srcid, $num) = @_;
my @stdsrc = @{$SOURCE_LISTS{$srcid}};
my $rtn = $RES_OK;
my $vref;
my %vref;
my $msgcnt = 0;
my %rcdlst;
my @tgtsrc;
my %hwk = ();
my $wk;
my %hsrc = ();

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "JudgeStackReportRecord($stackid, $mcast, $type, $srcid, $num)");
	}

	# Judgment evasion

	# Caption
	# (Since there are details, it is a call side.)

	# Get target data.
	unless (defined $STACK_S{$stackid}) {
		vLogRed("	There is no no message.");
		return $RES_NG;
	}

	# Check report record.
	foreach $vref (@{$STACK_S{$stackid}}) {
		%vref = %{$vref};

		# Caption msg
		vLog0("	<A HREF=\"#vRecvPKT$vref{PKTNO}\">MLDv2 Report.</A>");

		# Get the records.
		%rcdlst = GetReportRcd(\%vref);

		# Get the source list.
		unless (defined $rcdlst{$mcast}{$type}) {
			vLog0("		INFO: Record of Multicast address $mcast and type $type is no exist.");
			next;
		}
		@tgtsrc = @{$rcdlst{$mcast}{$type}{srclst}};

		# Compare the source list.
		%hwk = CompLst(\@stdsrc, \@tgtsrc);
		foreach $wk (sort keys %hwk) {
			if ($hwk{$wk} > 0) {
				if ($hwk{$wk} == 1) {
					vLog0("		INFO: Multicast source address $wk is match.");
				}
				else { # ($hwk{$wk} > 1)
					vLogRed("		FAIL: Multicast source address $wk is duplicated.");
					$rtn = $RES_NG;
				}

				# for total check
				unless (defined $hsrc{$wk}) {
			 		$hsrc{$wk} = 1;
				}
				else {
			 		$hsrc{$wk} += 1;
				}
			}
			elsif ($hwk{$wk} == 0) {
				vLog0("		INFO: Multicast source address $wk is no exist.");
			}
			else { # ($hwk{$wk} < 0)
				vLogRed("		FAIL: Multicast source address $wk is unexpected.");
				$rtn = $RES_NG;
			}
		}
	}

	# Caption judgement
	vLog1("Judge: Report record source list summary.");

	# Judge
	foreach $wk (@stdsrc) {
		unless (defined $hsrc{$wk}) {
			$hsrc{$wk} = 0;
		}

		vLog0("	INFO: There are multicast source address $wk, $hsrc{$wk}.");

		if ($hsrc{$wk} < $num) {
			vLogRed("		FAIL: There are few multicast source addresses compared with standard $num.");
			$rtn = $RES_NG;
		}

		elsif ($hsrc{$wk} > $num) {
			vLogRed("		FAIL: There are many multicast source addresses compared with standard $num.");
			$rtn = $RES_NG;
		}
	}

	return $rtn;
}

#------------------------------------------------------------------------------
# JudgeReportRecord
#   Check one record in report.
#   <IN>  %vref  : Report message to be checked.
#         $mcast : Multicast to check.
#         $type  : Record type to expect.
#         $srcid : ID of the source list to expect.
#         $eflag : Error display.
#   <RTN> $RES_OK: Agreement.
#         $RES_NG: Disagreement.
#------------------------------------------------------------------------------
sub JudgeReportRecord(%$$$$) {
my ($vref, $mcast, $type, $srcid, $eflag) = @_;
my %vref = %{$vref};
my $rtn = $RES_OK;
my %rcdlst;
my $wk;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "JudgeReportRecord($vref, $mcast, $type, $srcid)");
	}

	# Judgment evasion

	# Caption
	# (Since there are details, it is a call side.)

	# Caption msg
	vLog0("	<A HREF=\"#vRecvPKT$vref{PKTNO}\">MLDv2 Report.</A>");

	# Get target data
	%rcdlst = GetReportRcd(\%vref);

	# Compare the record data with specific multicast and type and source.
	$wk = CompRecord(\%rcdlst, $mcast, $type, $srcid, $eflag);
	if ($wk != $RES_OK) {
		$rtn = $RES_NG;
	}

	return $rtn;
}

#------------------------------------------------------------------------------
# JudgeSplitReport
#   Check the source list of Report.
#   <IN>  $stackid: Key in %STACK_S{}
#         $mcast  : Multicast to compare.
#         $type   : Record type to expect.
#         $srcid  : ID of the source list to expect.
#         $num    : number of each source.
#   <RTN> $RES_OK: Agreement.
#         $RES_NG: Disagreement.
#------------------------------------------------------------------------------
sub JudgeSplitReport($$$$$$) {
my ($stackid, $mcast, $type, $srcid, $num, $limit) = @_;
my @stdsrc = @{$SOURCE_LISTS{$srcid}};
my $rtn = $RES_OK;
my $vref;
my %vref;
my $msgcnt = 0;
my %rcdlst;
my @tgtsrc;
my %hwk = ();
my $wk;
my %hsrc = ();
my $just_count = 0;
my $zero_count = 0;
my $etc_count = 0;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "JudgeSplitReport($stackid, $mcast, $type, $srcid, $num, $limit)");
	}

	# Judgment evasion

	# Caption
	# (Since there are details, it is a call side.)

	# Get target data
	unless (defined $STACK_S{$stackid}) {
		vLogRed("	There is no target Report.");
		return $RES_NG;
	}

	# Check query
	foreach $vref (@{$STACK_S{$stackid}}) {
		%vref = %{$vref};

		# Caption msg
		vLog0("	<A HREF=\"#vRecvPKT$vref{PKTNO}\">MLDv2 Report.</A>");

		# Get the records.
		%rcdlst = GetReportRcd(\%vref);

		# Get the source list.
		unless (defined $rcdlst{$mcast}{$type}) {
			vLog0("		INFO: Record of Multicast address $mcast and type $type is no exist.");
			next;
		}
		@tgtsrc = @{$rcdlst{$mcast}{$type}{srclst}};

		# Compare the source list.
		%hwk = CompLst(\@stdsrc, \@tgtsrc);
		foreach $wk (sort keys %hwk) {
			if ($hwk{$wk} > 0) {
				if ($hwk{$wk} == 1) {
					vLog0("		INFO: Multicast source address $wk is match.");
				}
				else { # ($hwk{$wk} > 1)
					vLogRed("		FAIL: Multicast source address $wk is duplicated.");
					$rtn = $RES_NG;
				}

				# for total check
				unless (defined $hsrc{$wk}) {
			 		$hsrc{$wk} = 1;
				}
				else {
			 		$hsrc{$wk} += 1;
				}
			}
			elsif ($hwk{$wk} == 0) {
				vLog0("		INFO: Multicast source address $wk is no exist.");
			}
			else { # ($hwk{$wk} < 0)
				vLogRed("		FAIL: Multicast source address $wk is unexpected.");
				$rtn = $RES_NG;
			}
		}
	}

	# Caption judgement
	vLog1("Judge: Split Report source list summary.");

	# Judge with count
	foreach $wk (@stdsrc) {
		unless (defined $hsrc{$wk}) {
			$hsrc{$wk} = 0;
			$zero_count ++;
		}

		vLog0("	INFO: There are multicast source address $wk, $hsrc{$wk}.");
		if ($hsrc{$wk} == $num) {
			$just_count ++;;
		}
		elsif ($hsrc{$wk} < $num) {
			vLogGreen("		FAIL: There are few multicast source addresses compared with standard $num");
			$etc_count ++;
		}
		elsif ($hsrc{$wk} > $num) {
			vLogRed("		FAIL: There are many multicast source addresses compared with standard $num.");
			$etc_count ++;
			$rtn = $RES_NG;
		}
	}

	# Judge limit.
	vLog0("Judge: Limit number of MLD Reports.");
	if (($just_count != $limit) || ($etc_count != 0)) {
		vLogRed("		FAIL: An expected number of multicast source addresses cannot be found.");
		$rtn = $RES_NG;
	}

	return $rtn;
}

#------------------------------------------------------------------------------
# GetReportRcd
#   Get record data from MLDv2 Report.
#   <IN>  $vref: MLDv2 Report.
#   <RTN> @hrtn: Multicast record data.
#------------------------------------------------------------------------------
sub GetReportRcd(%) {
my ($vref) = @_;
my %vref = %{$vref};
my %hrtn = ();
my $num_r;
my $type;
my $mcast;
my $num_s;
my $i;
my $j;
my $fr_record;
my $fr_source;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "GetReportRcd($vref)");
	}

	# Check report.
	unless (defined $vref{$FRAME_MLDv2R}) {
		vLogRed("INTERNAL ERROR: GetReportRcd(), This is not an MLDv2 Report packet.");
		exit $V6evalTool::exitFatal;
	}

	# Get number of records.
	$num_r = $vref{$FRAME_MLDv2R . ".NumOfMcastAddrRecords"};
	if ($DEBUG > 2) {
		InfoDebug(__FILE__, __LINE__, "GetReportRcd(), Number of Mcast Address Records $num_r.");
	}

	# For every record.
	for ($i = 1; $i <= $num_r; $i++) {
		if ($i == 1) {
			$fr_record = "$FRAME_MLDv2R.MLDv2_AddrRecord";
		}
		else {
			$fr_record = "$FRAME_MLDv2R.MLDv2_AddrRecord$i";
		}

		# Check record.
		unless (defined $vref{$fr_record}) {
			vLogRed("ERROR: Mismatch of the record number($num_r) and field($i) in Report.");
			exit $V6evalTool::exitFail;
		}

		# Get type, multicast address, number of source.
		$type  = $vref{"$fr_record.Type"};
		$mcast = $vref{"$fr_record.MulticastAddress"};
		$num_s = $vref{"$fr_record.NumOfSources"};
		if ($DEBUG > 2) {
			InfoDebug(__FILE__, __LINE__, "GetReportRcd(), Type is $type.");
			InfoDebug(__FILE__, __LINE__, "GetReportRcd(), Multicast address is $mcast.");
			InfoDebug(__FILE__, __LINE__, "GetReportRcd(), Number of sources is $num_s.");
		}

		# Need to be defined key for comparison.
		@{$hrtn{$mcast}{$type}{srclst}} = ();

		# For every source in record.
		for ($j = 1; $j <= $num_s; $j++) {
			if ($j == 1) {
				$fr_source = "$fr_record.SourceAddress";
			}
			else {
				$fr_source = "$fr_record.SourceAddress_$j";
			}

			# Check source.
			unless (defined $vref{$fr_source}) {
				vLogRed("ERROR: Mismatch of the multicast source number($num_s) and field($j) in the record($i).");
				exit $V6evalTool::exitFail;
			}

			# Get source.
			if ($DEBUG > 2) {
				InfoDebug(__FILE__, __LINE__, "GetReportRcd(), Multicast source address is $vref{$fr_source}.");
			}
			push @{$hrtn{$mcast}{$type}{srclst}}, $vref{$fr_source};
		}
	}

	return %hrtn;
}

#------------------------------------------------------------------------------
# CompRecord
#   Compare the record.
#   <IN>  %rcdlst: Multicast record to be compared.
#         $mcast : Multicast to compare.
#         $type  : Record type to expect.
#         $srcid : ID of the source list to expect.
#         $eflag : Flag for error judgement display.
#   <RTN> $RES_OK: Agreement.
#         $RES_NG: Disagreement.
#------------------------------------------------------------------------------
sub CompRecord(%$$$$) {
my ($rcdlst, $mcast, $type, $srcid, $eflag) = @_;
my %rcdlst = %{$rcdlst};
my @stdsrc = @{$SOURCE_LISTS{$srcid}};
my $rtn = $RES_OK;
my @tgtsrc;
my %hwk;
my $wk;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "CompRecord($rcdlst, $mcast, $type, $srcid)");
	}

	# Compare the multicast.
	unless (defined $rcdlst{$mcast}) {
		if ($eflag > 0) {
			vLogRed("		FAIL: Record of multicast address $mcast is no exist.");
		}
		return $RES_NG;
	}

	# Compare the record type.
	unless (defined $rcdlst{$mcast}{$type}) {
		if ($eflag > 0) {
			vLogRed("		FAIL: Record of multicast address $mcast and type $type is no exist.");
		}
		return $RES_NG;
	}
	else {
		vLog0("		INFO: The message has record of multicast address $mcast and type $type.");
	}

	# Get target data
	@tgtsrc = @{$rcdlst{$mcast}{$type}{srclst}};

	# Compare the source list.
	%hwk = CompLst(\@stdsrc, \@tgtsrc);
	foreach $wk (sort keys %hwk) {
		if ($hwk{$wk} > 0) {
			if ($hwk{$wk} == 1) {
				vLog0("		INFO: Multicast source address $wk is match.");
			}
			else { # ($hwk{$wk} > 1)
				vLogRed("		FAIL: Multicast source address $wk is duplicated.");
				$rtn = $RES_NG;
			}
		}
		elsif ($hwk{$wk} == 0) {
			vLogRed("		FAIL: Multicast source address $wk is no exist.");
			$rtn = $RES_NG;
		}
		else { # ($hwk{$wk} < 0)
			vLogRed("		FAIL: Multicast source address $wk is unexpected.");
			$rtn = $RES_NG;
		}
	}

	return $rtn;
}

#------------------------------------------------------------------------------
# CompLst
#   Compare two lists.
#   <IN>  @stdlst: List of standard.
#         @tgtlst: List of terget.
#   <OUT> %hrtn  : <key> => Comparison result.
#                  >1: It is in stdlst and and it is in tgtlst (too much).
#                  =1: It is in stdlst and and it is in tgtlst.
#                  =0: It is in stdlst and is not in tgtlst.
#                  <0: It is not in stdlst and it is in tgtlst.
#------------------------------------------------------------------------------
sub CompLst(@@) {
my ($stdlst, $tgtlst) = @_;
my @stdlst = @{$stdlst};
my @tgtlst = @{$tgtlst};
my %hrtn;
my $wk;

	if ($DEBUG > 1) {
		InfoDebug(__FILE__, __LINE__, "CompLst($stdlst, $tgtlst)");
	}

	# Create the hash from stdlst.
	foreach $wk (@stdlst) {
 		# It is in stdlst
 		$hrtn{$wk} = 0;
	}

	# Update the hash by checking tgtlst.
	foreach $wk (@tgtlst) {
		if (defined $hrtn{$wk}) {
			# It is in both
			$hrtn{$wk} += 1;
		}
		else {
			# It is not in stdlst and it is in tgtlst.
			$hrtn{$wk} -= 1;
		}
	}

	return %hrtn;
}

# EOF
1;
