#!/usr/bin/perl

# Copyright(C) IPv6 Promotion Council (2004-2010). All Rights Reserved.
# 
# This documentation is produced by SIP SWG members of Certification WG in 
# IPv6 Promotion Council.
# The SWG members currently include NIPPON TELEGRAPH AND TELEPHONE CORPORATION (NTT), 
# Yokogawa Electric Corporation and NTT Advanced Technology Corporation (NTT-AT).
# 
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

# use strict;

# 
# 09/6/ 3  CtGetHostFromFQDN,CtMkSecurityVerify
#          CtSvSetDefaultRouteSetFrom200Reg 
# 09/4/30  CtSvDlgUpdate early
# 09/4/20  CtSvDlgUpdate early
# 09/4 2   CtSvDlgUpdate Terminated
# 09/2/12  UpdateDialogSubscribe Terminated
# 09/2/ 3  UpdateDialogSubscribe NOTIFY
# 08/12/22 CtSvGenRequestVia IPv4

#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $dialogid
#     $param
#     $node
#   
#     
#   
#     
#
#     $param
#       
#     $param => {
#       'CallID'       => "",           # o 
#       'RemoteTarget' => '',           # o 
#       'LocalURI' => {         
#           'AoR'         => "",        # m 
#           'Contact'     => "",        # m 
#           'DisplayName' => "",        # o 
#       },
#       'LocalTag'     => "",           # o 
#       'LocalSeqNum'  => "",           # o 
#       'RemoteURI' => {
#           'AoR'         => "",        # m 
#           'DisplayName' => "",        # o 
#       },
#       'RemoteTag'    => '',           # - 
#       'RemoteSeqNum' => '',           # - 
#       'RouteSet'     => '',           # o 
#       'SecureFlag'   => '',           # - config.txt
#       'DialogState'  => '',           # - 
#       'Direction'    => '',           # m 
# 
#       #------------------------------------------
#       # 
#       #------------------------------------------
#       'Usage'          => '',         # o Invite|Subscribe|Register 
#       'ExpireTime'     => '',         # - 
#       'RegInfo'        => {			# RegInfo
#           '_version'     => '',       # - 
#           '_state'       => '',       # - 
#           'registration' => '',       # - Registraion
#       },
#     }
#-----------------------------------------------------------------------------
sub CtSvCreateDlg {
    my ($dialogid, $param, $node) = @_;
    my ($dlg);

    if ($dialogid eq '') {
        CtSvError('fatal', "dialogid nothing");
        return;
    }

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }
    
    # Call-ID
    #   - 
    #   - 
    if ($param->{'CallID'} ne '') {
        $dlg->{'CallID'} = $param->{'CallID'};
    } else {
	$dlg->{'CallID'} = '';
    }

    # LocalURI (AoR)
    #   - 
    #     (
    if ($param->{'LocalURI'}->{'AoR'} ne '') {
        $dlg->{'LocalURI'}->{'AoR'} = $param->{'LocalURI'}->{'AoR'};
    } else {
        CtSvError('fatal', "no LocalURI(AoR)");
        return;
    }

    # LocalURI (Contact)
    #   - 
    #     (
    if ($param->{'LocalURI'}->{'Contact'} ne '') {
        $dlg->{'LocalURI'}->{'Contact'} = $param->{'LocalURI'}->{'Contact'};
    } else {
        CtSvError('fatal', "no LocalURI(Contact)");
        return;
    }

    # LocalURI (DisplayName)
    #   - 
    if ($param->{'LocalURI'}->{'DisplayName'} ne '') {
        $dlg->{'LocalURI'}->{'DisplayName'} = $param->{'LocalURI'}->{'DisplayName'};
    }

    # LocalTag
    #   - 
    #   - 
    if ($param->{'LocalTag'} ne '') {
        $dlg->{'LocalTag'} = $param->{'LocalTag'};
    } else {
	$dlg->{'LocalTag'} = '';
    }

    # LocalSeqNum
    #   - 
    #   - 
    if ($param->{'LocalSeqNum'} ne '') {
        $dlg->{'LocalSeqNum'} = $param->{'LocalSeqNum'};
    } else {
	$dlg->{'LocalSeqNum'} = '';
    }

    # RemoteURI (AoR)
    #   - 
    if ($param->{'RemoteURI'}->{'AoR'} ne '') {
        $dlg->{'RemoteURI'}->{'AoR'} = $param->{'RemoteURI'}->{'AoR'};
    } else {
        CtSvError('fatal', "no RemoteURI(AoR)");
        return;
    }
    
    # RemoteURI (DisplayName)
    #   - 
    if ($param->{'RemoteURI'}->{'DisplayName'} ne '') {
        $dlg->{'RemoteURI'}->{'DisplayName'} = $param->{'RemoteURI'}->{'DisplayName'};
    }

    # RemoteTarget
    #   - 
    #   - 
    if ($param->{'RemoteTarget'} ne '') {
	$dlg->{'RemoteTarget'} = $param->{'RemoteTarget'};
    } else {
	$dlg->{'RemoteTarget'} = '';
    }
    
    # RemoteTag
    #   - 
    if ($param->{'RemoteTag'} ne '') {
	$dlg->{'RemoteTag'} = $param->{'RemoteTag'};
    } else {
	$dlg->{'RemoteTag'} = '';
    }
    
    # RemoteSeqNum
    #   - 
    if ($param->{'RemoteSeqNum'} ne '') {
	$dlg->{'RemoteSeqNum'} = $param->{'RemoteSeqNum'};
    } else {
	$dlg->{'RemoteSeqNum'} = '';
    }

    # RouteSet
    #   - 
    #   - 
    if ($param->{'RouteSet'} ne '') {
        $dlg->{'RouteSet'} = $param->{'RouteSet'};
    } else {
	$dlg->{'RouteSet'} = '';
    }
    
    # SecureFlag
    #   - config.txt
    $dlg->{'SecureFlag'} = (CtTbPrm('CI,transport') eq 'TLS')?'TRUE':'FALSE',

    # DialogState (Terminated, Early, Confirmed)
    #   - 
    $dlg->{'DialogState'} = 'Terminated';

    # Direction (Callee, Caller)
    if ($param->{'Direction'} ne '') {
	$dlg->{'Direction'} = $param->{'Direction'};
    } else {
	# 
        MsgPrint('WAR', "Direction is not specified for dialog ID[%s]\n", $dialogid);
    }

    #------------------------------------------
    # 
    #------------------------------------------

    if ($param->{'Usage'} ne '') {
	$dlg->{'Usage'} = $param->{'Usage'};
    } else {
	$dlg->{'Usage'} = 'Invite';
    }
    if ($dlg->{'Usage'} eq 'Subscribe') {
	$dlg->{'SubscribedTime'} = '';
	$dlg->{'ExpireTime'} = '';
    }

    CtSvDlgSet($dialogid, $dlg, $node);
    if(CtLgLevel('DLG')){CtPrintDlg($dialogid,$node);}
    return;
}


#-----------------------------------------------------------------------------
# 
#   
#     $dialogid
#     $msg
#     $node
#     $regname
#   
#     
#   
#     SIP
#   
#     REGISTER
#-----------------------------------------------------------------------------
sub CtSvDlgUpdate {
    my($dialogid, $msg, $node, $regname) = @_;
    my(%orgDlg);

    # TODO
    #   - RFC3261
    #   - RFC3261
    #	- 3xx
    #	- 

    if ($dialogid eq '') {
        CtSvError('fatal', "dialogid nothing");
        return;
    }

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }

    if(CtLgLevel('DLG')){CtCopyDlg(CtFindDlg($dialogid, $node),\%orgDlg);}

    #-----------------------------------------------------------
    # Subscribe
    #-----------------------------------------------------------
    if (CtSvDlg($dialogid, 'Usage', $node) eq 'Subscribe') {
	UpdateSubscribeDialog($dialogid, $msg, $regname, $node);
	if(CtLgLevel('DLG')){CtDiffDlg($dialogid,\%orgDlg,CtFindDlg($dialogid, $node))}
	return;
    }
    #-----------------------------------------------------------
    # 
    #-----------------------------------------------------------

    # 
    # 
    # 
    # 
    # 
    #
    # 
    # 
    # 
    
    my ($method, $status, $dlgstate, $cseqmethod, $recroute);
    $method		= CtFlv('SL,method', $msg);
    $status		= CtFlv('SL,code', $msg);
    $dlgstate	= CtSvDlg($dialogid, 'DialogState', $node);
    $cseqmethod	= CtFlv('HD,#CSeq,method', $msg);
    $recroute	= CtFlv('HD,#Record-Route,routes,addr,#TXT#', $msg);

    if ($dlgstate eq 'Terminated') {
	# Terminated

	if ($msg->{'#Direction#'} eq 'out' && ($method && !$status)) {
	    # Terminated

	    # 
	    # ENCODE
	    
	    # 
	    # 
	    if (CtFlv('HD,#Call-ID,call-id', $msg)) {
		CtTbSet("DLG,$dialogid,CallID", CtFlv('HD,#Call-ID,call-id', $msg), $node);
	    }
	    if (CtFlv('HD,#From,addr,uri,#TXT#', $msg)) {
		CtTbSet("DLG,$dialogid,LocalURI,AoR", CtFlv('HD,#From,addr,uri,#TXT#', $msg), $node);
	    }
	    if (CtFlv('HD,#From,params,list,tag-id', $msg)) { 
		CtTbSet("DLG,$dialogid,LocalTag", CtFlv('HD,#From,params,list,tag-id', $msg), $node);
	    }
	    if (CtFlv('HD,#CSeq,cseqnum', $msg)) {
		CtTbSet("DLG,$dialogid,LocalSeqNum", CtFlv('HD,#CSeq,cseqnum', $msg), $node);
	    }
	    if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {	
		CtTbSet("DLG,$dialogid,LocalURI,Contact", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
	    }
	    
	    if (CtFlv('HD,#To,addr,uri,#TXT#', $msg)) {
		CtTbSet("DLG,$dialogid,RemoteURI,AoR", CtFlv('HD,#To,addr,uri,#TXT#', $msg), $node);
	    }

	} elsif ($msg->{'#Direction#'} eq 'in' && ($method && !$status)) {
	    # Terminated
	    
	    if ($method eq "ACK") {
		# ACK
		# 
	    } elsif ($method eq "BYE") {
		# BYE
		# 
	    } elsif ($method eq "CANCEL") {
		# CANCEL
		# (180
		# 
	    } elsif ($method eq "INVITE") {
		# INVITE
		# (1XX

		CtTbSet("DLG,$dialogid,CallID", CtFlv('HD,#Call-ID,call-id', $msg), $node);
		CtTbSet("DLG,$dialogid,RemoteURI,AoR", CtFlv('HD,#From,addr,uri,#TXT#', $msg), $node);
		CtTbSet("DLG,$dialogid,RemoteURI,DisplayName", CtFlv('HD,#From,addr,display', $msg), $node);
		if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
		    CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		}

		CtTbSet("DLG,$dialogid,RemoteTag", CtFlv('HD,#From,params,list,tag-id', $msg), $node);

		# RemoteSeqNum
		if (CtFlv('HD,#CSeq,cseqnum', $msg) > CtSvDlg($dialogid,'RemoteSeqNum')) {
		    CtTbSet("DLG,$dialogid,RemoteSeqNum", CtFlv('HD,#CSeq,cseqnum', $msg), $node);
		}

		CtTbSet("DLG,$dialogid,RouteSet", $recroute, $node);
		CtTbSet("DLG,$dialogid,SecureFlag", (CtFlv('SL,uri,scheme', $msg) eq 'sips')?'TRUE':'FALSE', $node);

	    }
	    elsif ($method eq "OPTIONS") {
		# OPTIONS
		# 
	    } 
	    elsif ($method eq "REGISTER") {
		# 
		# 

		CtTbSet("DLG,$dialogid,CallID", CtFlv('HD,#Call-ID,call-id', $msg), $node);
		CtTbSet("DLG,$dialogid,RemoteURI,AoR", CtFlv('HD,#From,addr,uri,#TXT#', $msg), $node);
		CtTbSet("DLG,$dialogid,RemoteURI,DisplayName", CtFlv('HD,#From,addr,display', $msg), $node);
		if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
 		    CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		    ### suyama
		    #CtTbSet("DLG,$dialogid,LocalURI,Contact", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		}

		CtTbSet("DLG,$dialogid,RemoteTag", CtFlv('HD,#From,params,list,tag-id', $msg), $node);

		# RemoteSeqNum
		if (CtFlv('HD,#CSeq,cseqnum', $msg) > CtSvDlg($dialogid,'RemoteSeqNum')) {
		    CtTbSet("DLG,$dialogid,RemoteSeqNum", CtFlv('HD,#CSeq,cseqnum', $msg), $node);
		}

		CtTbSet("DLG,$dialogid,RouteSet", $recroute, $node);
		CtTbSet("DLG,$dialogid,SecureFlag", (CtFlv('SL,uri,scheme', $msg) eq 'sips')?'TRUE':'FALSE', $node);
		
	    } else {
		# 
	    }

	} elsif ($msg->{'#Direction#'} eq 'out' && (!$method && $status)) {
	    # Terminated
	    if ($status =~ /^[1]/ && $status !~ 100) {
		# 101-199
		CtTbSet("DLG,$dialogid,DialogState", 'Early', $node);
	    } elsif ($status =~ /^[2]/) {
		# INVITE
		if ($cseqmethod eq 'INVITE') {
		    # Confirmed
		    CtTbSet("DLG,$dialogid,DialogState", 'Confirmed', $node);
		}
	    } else {
		# Terminated
	    }

	} elsif ($msg->{'#Direction#'} eq 'in' && (!$method && $status)) {
	    # Terminated

	    if ($status =~ /^[1]/ && $status ne '100') {
		# 101-199
		CtTbSet("DLG,$dialogid,DialogState", 'Early', $node);

		if ($cseqmethod ne 'REGISTER') { # REGISTER
		    if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
			CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		    }
		}
		CtTbSet("DLG,$dialogid,RemoteTag", CtFlv('HD,#To,params,list,tag-id', $msg), $node);
		CtTbSet("DLG,$dialogid,RouteSet", ref($recroute) eq 'ARRAY' ? [reverse(@$recroute)] : $recroute, $node);
	    } elsif ($status =~ /^[2]/) {
		# INVITE
		if ($cseqmethod eq 'INVITE') {
		    # Confirmed
		    CtTbSet("DLG,$dialogid,DialogState", 'Confirmed', $node);
		}

		if ($cseqmethod ne 'REGISTER') { # REGISTER
		    if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
			CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		    }
		}
		CtTbSet("DLG,$dialogid,RemoteTag", CtFlv('HD,#To,params,list,tag-id', $msg), $node);
		CtTbSet("DLG,$dialogid,RouteSet", ref($recroute) eq 'ARRAY' ? [reverse(@$recroute)] : $recroute, $node);
	    } else {
		# Terminated
	    }

	} else {
	    CtSvError('fatal', "Invalid Message-1");
	    return;
	}
	if(CtLgLevel('DLG')){CtDiffDlg($dialogid,\%orgDlg,CtFindDlg($dialogid, $node))}
	return;
    }
    elsif ($dlgstate eq 'Early') {
	# Early

	# 
	# ENCODE

	if ($msg->{'#Direction#'} eq 'out' && ($method && !$status)) {
	    # Early

	    # UPDATE

	} elsif ($msg->{'#Direction#'} eq 'in' && ($method && !$status)) {
	    # Early

	    # UPDATE

	    # RemoteSeqNum
	    if (CtFlv('HD,#CSeq,cseqnum', $msg) > CtSvDlg($dialogid,'RemoteSeqNum')) {
		CtTbSet("DLG,$dialogid,RemoteSeqNum", CtFlv('HD,#CSeq,cseqnum', $msg), $node);
	    }


	} elsif ($msg->{'#Direction#'} eq 'out' && (!$method && $status)) {
	    # Early

	    if ($status =~ /^[1]/ && $status !~ 100) {
		# Early
		CtTbSet("DLG,$dialogid,DialogState", 'Early', $node);
	    } elsif ($status =~ /^[2]/) {
		# INVITE
		if ($cseqmethod eq 'INVITE') {
		    # Confirmed
		    CtTbSet("DLG,$dialogid,DialogState", 'Confirmed', $node);

		    # 
		    CtTbSet("DLG,$dialogid,RouteSet", $recroute,$node);
		    #CtTbSet("DLG,$dialogid,RouteSet", ref($recroute) ? [reverse(@$recroute)] : $recroute,$node);
		}
	    } elsif ($status =~ /^[4]/ || $status =~ /^[5]/ || $status =~ /^[6]/){
		# 4xx-6xx
		CtTbSet("DLG,$dialogid,DialogState", 'Terminated', $node);
	    } else {
		# 
	    }

	} elsif ($msg->{'#Direction#'} eq 'in' && (!$method && $status)) {
	    # Early
	    
	    if ($status =~ /^[1]/ && $status !~ 100) {
		# Early
		CtTbSet("DLG,$dialogid,DialogState", 'Early', $node);

		if ($cseqmethod ne 'REGISTER') { # REGISTER
		    if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
			CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		    }
		}
		CtTbSet("DLG,$dialogid,RemoteTag", CtFlv('HD,#To,params,list,tag-id', $msg), $node);
		CtTbSet("DLG,$dialogid,RouteSet", ref($recroute) eq 'ARRAY' ? [reverse(@$recroute)] : $recroute, $node);
	    } elsif ($status =~ /^[2]/) {
		# INVITE
		if ($cseqmethod eq 'INVITE') {
		    # Confirmed
		    CtTbSet("DLG,$dialogid,DialogState", 'Confirmed', $node);
		}

		if ($cseqmethod ne 'REGISTER') { # REGISTER
		    if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
			CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		    }
		}
		# XXX: 101-199
		CtTbSet("DLG,$dialogid,RemoteTag", CtFlv('HD,#To,params,list,tag-id', $msg), $node);
		# 
		#  CtTbSet("DLG,$dialogid,RouteSet", $recroute,$node);
		CtTbSet("DLG,$dialogid,RouteSet", ref($recroute) eq 'ARRAY' ? [reverse(@$recroute)] : $recroute, $node);
	    } elsif ($status =~ /^[4]/ || $status =~ /^[5]/ || $status =~ /^[6]/){
		# 4xx-6xx
		CtTbSet("DLG,$dialogid,DialogState", 'Confirmed', $node);	# XXX:Confirmed???
	    } else {
		# 
	    }

	} else {
	    CtSvError('fatal', "Invalid Message-2");
	    return;
	}
	if(CtLgLevel('DLG')){CtDiffDlg($dialogid,\%orgDlg,CtFindDlg($dialogid, $node))}
	return;
    }
    elsif ($dlgstate eq 'Confirmed') {
	# Confirmed
	
	if ($msg->{'#Direction#'} eq 'out' && ($method && !$status)) {
	    # Confirmed
	    
	    if ($method eq "BYE") {
		CtTbSet("DLG,$dialogid,DialogState", 'Terminated', $node);
	    } else {
		# 
	    }

	} elsif ($msg->{'#Direction#'} eq 'in' && ($method && !$status)) {
	    # Confirmed

	    # RemoteSeqNum
	    if (CtFlv('HD,#CSeq,cseqnum', $msg) > CtSvDlg($dialogid,'RemoteSeqNum')) {
		CtTbSet("DLG,$dialogid,RemoteSeqNum", CtFlv('HD,#CSeq,cseqnum', $msg), $node);
	    }
	    
	    # RemoteTarget
	    if ($method eq "INVITE") {
		# 
		if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
		    CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		}
	    } elsif ($method eq "UPDATE") {
		# 
		if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
		    CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		}
	    } else {
		# 
	    }

	} elsif ($msg->{'#Direction#'} eq 'out' && (!$method && $status)) {
	    # Confirmed


	} elsif ($msg->{'#Direction#'} eq 'in' && (!$method && $status)) {
	    # Confirmed
	    
	    if ($status =~ /^[2]/) {
		if (CtFlv('HD,#CSeq,method', $msg) eq 'INVITE') {
		    # 
		    # RemoteTarget
		    if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
			CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		    }
		} elsif (CtFlv('HD,#CSeq,method', $msg) eq 'UPDATE') {
		    # 
		    # RemoteTarget
		    if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
			CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		    }
		}
	    }
	} else {
	    CtSvError('fatal', "Invalid Message-3");
	    return;
	}
	if(CtLgLevel('DLG')){CtDiffDlg($dialogid,\%orgDlg,CtFindDlg($dialogid, $node))}
	return;
    }
    else {
	CtSvError('fatal', "Invalid Dialog[$dialogid] State");
	return;
    }
    return;
}


#=============================================================================
# 
#=============================================================================

#-----------------------------------------------------------------------------
# 
#   
#     $dialogid
#     $node
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtSvDlgGet {
    my ($dialogid, $node) = @_;

    if ($dialogid eq '') {
        CtSvError('fatal', "dialogid nothing");
        return;
    }

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }

    return CtTbl("DLG,$dialogid", $node);
}


#-----------------------------------------------------------------------------
# 
#   
#     $dialogid
#     $dialog
#     $node
#   
#     
#   
#     SIP
#-----------------------------------------------------------------------------
sub CtSvDlgSet {
    my ($dialogid, $dialog, $node) = @_;
    my ($oldDlg);

    if ($dialogid eq '') {
        CtSvError('fatal', "dialogid nothing");
        return;
    }

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }

    # 
    $oldDlg = CtSvDlgGet($dialogid, $node);
    if ($oldDlg ne '') {
        MsgPrint('DLG', "Overwrite dialog info: dialog ID[%s]\n", $dialogid);
    }

    CtTbSet("DLG,$dialogid", $dialog, $node);
}


#-----------------------------------------------------------------------------
# 
#   
#     $dialogid
#     $field
#     $node
#   
#     
#   
#     
#-----------------------------------------------------------------------------
sub CtSvDlg {
    my ($dialogid, $field, $node) = @_;

    if ($dialogid eq '') {
        CtSvError('fatal', "dialogid nothing");
        return;
    }

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }

    return CtTbl("DLG,$dialogid,$field", $node);
}
sub CtSvDlgRegInfoSet {
    my ($dialogid, $key, $val, $node) = @_;
    my $data = CtTbl("DLG,$dialogid,RegInfo", $node);
    CtSvKeyValueSet($data,$key,$val);
}
sub CtSvKeyValueSet {
    my($data,$key,$val)=@_;
    my($id);
    if(ref($data) eq 'HASH'){
        foreach $id (keys(%$data)){
            if(ref($data->{$id})){
                CtSvKeyValueSet($data->{$id},$key,$val);
            }
            elsif($key eq $id){
                $data->{$id} = $val;
            }
        }
    }
    elsif(ref($data) eq 'ARRAY'){
        foreach $id (@$data){
            if(ref($id)){
                CtSvKeyValueSet($id,$key,$val);
            }
        }
    }
}

sub CtCopyDlg {
    my($fromA,$toB)=@_;
    %$toB = %$fromA;
}
sub CtDiffDlg {
    my($name,$dlgA,$dlgB)=@_;
    my($key,@msg);
    push(@msg,"  --- dialog update $name ---");
    foreach $key (sort(keys(%$dlgB))){
	if(ref($dlgA->{$key}) || ref($dlgB->{$key})){
	    CtDiffDlg2($key,$dlgA->{$key},$dlgB->{$key},\@msg,2);
	}
	elsif($dlgA->{$key} ne $dlgB->{$key}){
	    push(@msg,sprintf("  %s | %s => %s",$key,$dlgA->{$key}ne''?$dlgA->{$key}:q{''},$dlgB->{$key}ne''?$dlgB->{$key}:q{''}));
	}
    }
    if(0<$#msg){
	map{printf($_."\n")}(@msg);
    }
}
sub CtDiffDlg2 {
    my($name,$dlgA,$dlgB,$message,$level)=@_;
    my($key,@msg);

    push(@msg,' ' x $level . $name);
    if(ref($dlgA) eq 'ARRAY' || ref($dlgB) eq 'ARRAY'){
	$dlgA=[$dlgA] unless(ref($dlgA) eq 'ARRAY');
	$dlgB=[$dlgB] unless(ref($dlgB) eq 'ARRAY');
	$max = $#$dlgA < $#$dlgB ? $#$dlgB : $#$dlgA;
	foreach $no (0..$max){
	    if(ref($dlgA->[$no]) || ref($dlgB->[$no])){
		CtDiffDlg2($key,$dlgA->[$no],$dlgB->[$no],\@msg,$level+2);
	    }
	    elsif($dlgA->[$no] ne $dlgB->[$no]){
		push(@msg,sprintf(' ' x $level . "  %s | %s => %s",$no,$dlgA->[$no]ne''?$dlgA->[$no]:q{''},$dlgB->[$no]ne''?$dlgB->[$no]:q{''}));
	    }
	}
    }
    elsif(ref($dlgA) eq 'HASH' || ref($dlgB) eq 'HASH'){
	$dlgA={$dlgA} unless(ref($dlgA) eq 'HASH');
	$dlgB={$dlgB} unless(ref($dlgB) eq 'HASH');
	foreach $key (sort(keys(%$dlgB))){
	    if(ref($dlgA->{$key}) || ref($dlgB->{$key})){
		CtDiffDlg2($key,$dlgA->{$key},$dlgB->{$key},\@msg,$level+2);
	    }
	    elsif($dlgA->{$key} ne $dlgB->{$key}){
		push(@msg,sprintf(' ' x $level . "  %s | %s => %s",$key,$dlgA->{$key}ne''?$dlgA->{$key}:q{''},$dlgB->{$key}ne''?$dlgB->{$key}:q{''}));
	    }
	}
    }
    if(0<$#msg){
	push(@$message,@msg);
    }
}
sub CtFindDlg {
    my($dialogid, $node)=@_;
    return CtTbl("DLG,$dialogid", $node);
}
sub CtPrintDlg {
    my($dialogid,$node)=@_;
    printf(" --- $dialogid ---\n");
    printf(TextVal(CtTbl("DLG,$dialogid", $node),2));
}

# @@ -- SipDialog2.pm --

# use strict;

###############################################################################
# ToDo 10/30
#  RegInfo->registration
###############################################################################

###############################################################################
# SIP Dialog Control 2
###############################################################################

#-----------------------------------------------------------------------------
# 
#   
#     $dialogid
#     $msg
#     $tnode
#     $node
#   
#     
#   
#     
#     REGISTER
#     LocalURI,AoR|Contact|DisplayName
#     
#
#   XXX: RemoteTarget
#        CtSvCreateDlg
#-----------------------------------------------------------------------------
sub CtSvCreateDlgFromRequest {
    my ($dialogid, $msg, $tnode, $node) = @_;
    my ($method);
    my ($param);

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }
    if ($tnode eq '') {
	CtSvError('fatal', "terminate node is not specified");
	return;
    }
    
    $method = CtFlv('SL,method', $msg);
    
    if ($method eq 'INVITE') {		# XXX
	my ($conURI) = CtTbl('UC,SecContactURI', $tnode);	# 
	if (!$conURI) {
	    # XXX: config.txt
	    MsgPrint('WAR', "cannot get SecContactURI of $tnode\n");
	    $conURI = CtTbl('UC,ContactURI', $tnode);		# XXX:
	}
	$param = {
	    # XXX:LocalSeqNum
	    'LocalSeqNum' => CtFlv('HD,#CSeq,cseqnum', $msg),
	    'RemoteTarget' => CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg),
	    'RemoteURI'   => {
		AoR         => CtFlv('HD,#From,addr,uri,#TXT#', $msg),
		DisplayName => CtFlv('HD,#From,addr,display', $msg)
	    },
		    'LocalURI'    => {
			AoR         => CtFlv('HD,#To,addr,uri,#TXT#', $msg),
			Contact     => StrURI($conURI,'NoBrackets'),	# 
			DisplayName => CtFlv('HD,#To,addr,display', $msg)
		},
			    'Direction' => 'Callee',	# Callee
			    'Usage'     => 'Invite',	# Invite
	};
	CtSvCreateDlg($dialogid, $param, $node);
    } elsif ($method eq 'SUBSCRIBE') {
	$param = {
	    # XXX:LocalSeqNum
	    'LocalSeqNum' => CtFlv('HD,#CSeq,cseqnum', $msg),
	    'RemoteTarget' => CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg),
	    'RemoteURI' => {
		'AoR'         => CtFlv('HD,#From,addr,uri,#TXT#', $msg),
		'DisplayName' => CtFlv('HD,#From,addr,display', $msg)
	    },
		    'LocalURI' => {
			'AoR'         => CtFlv('HD,#To,addr,uri,#TXT#', $msg),
			'Contact'     => StrURI(CtTbl('UC,ContactURI', $tnode),'NoBrackets'),	# 
			'DisplayName' => CtFlv('HD,#To,addr,display', $msg)
		},
			    'Direction' => 'Callee',	# Callee
			    'Usage'     => 'Subscribe',	# Subscribe
	};
	CtSvCreateDlg($dialogid, $param, $node);
    } elsif ($method eq 'REGISTER') {
	$param = {
	    'RemoteURI' => {
		'AoR'         => CtFlv('HD,#From,addr,uri,#TXT#', $msg),
		'DisplayName' => CtFlv('HD,#From,addr,display', $msg)
	    },
		    'LocalURI' => {
			'AoR'         => CtFlv('HD,#To,addr,uri,#TXT#', $msg),
			'Contact'     => CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg),
			'DisplayName' => CtFlv('HD,#To,addr,display', $msg)
		},
			    'Direction' => 'Callee',	# Callee
			    'Usage'     => 'Register',	# Register
	};
	CtSvCreateDlg($dialogid, $param, $node);
    } else {
	# 
    }
}

#-----------------------------------------------------------------------------
# 
#   
#     $dialogid
#     $orig_node
#     $term_node
#     $param
#     $node
#   
#     
#   
#     
#	  Usage
#-----------------------------------------------------------------------------
sub CtSvCreateDlgForRequest {
    my ($dialogid, $orig_node, $term_node, $param, $node) = @_;
    my ($p);
    my ($default_seqnum) = 1100;

    if (!$dialogid) {
	CtSvError('fatal', "dialogid is not specified");
	return;
    }
    if (!$orig_node) {
	CtSvError('fatal', "orig_node is not specified");
	return;
    }
    if (!$term_node) {
	CtSvError('fatal', "term_node is not specified");
	return;
    }

    #------------------------------
    # 
    #------------------------------
    if ($param) {
	$p = $param;	# 
    }
    unless ($p->{'Usage'}) {
	# Usage
	$p->{'Usage'} = 'Invite';
    }
    unless ($p->{'Direction'}) {
	$p->{'Direction'} = 'Caller';
    }
    unless ($p->{'LocalSeqNum'}) {
	$p->{'LocalSeqNum'} = $default_seqnum;
    }

    if ($p->{'Usage'} eq 'Invite') {
	unless ($p->{'RemoteURI'} && $p->{'RemoteURI'}->{'Aor'}) {
	    # 
	    $p->{'RemoteURI'}->{'AoR'} = CtTbl('UC,UserProfile,PublicUserIdentity', $term_node),	# ToURI
	}

	unless ($p->{'LocalURI'} && $p->{'LocalURI'}->{'Aor'}) {
	    # 
	    $p->{'LocalURI'}->{'AoR'} = CtTbl('UC,UserProfile,PublicUserIdentity', $orig_node),	# FromURI
	}
	unless ($p->{'LocalURI'} && $p->{'LocalURI'}->{'Contact'}) {
	    # 
	    $p->{'LocalURI'}->{'Contact'} = StrURI(CtTbl('UC,SecContactURI', $orig_node),'NoBrackets'),	# ContactURI
	}
	# Request-URI
	# 
	unless ($p->{'RemoteTarget'}) {
	    my ($tSecContactURI) = CtTbl('UC,SecContactURI', $term_node);
	    if (!$tSecContactURI) {
		# XXX:
		#     REGISTER
		my ($tContactURI) = CtTbl('UC,ContactURI', $term_node);
		my ($port_s) = CtSecNego('','port_ps');
		if (!$port_s) {
		    CtSvError('fatal', "cannot get port_ps\n");
		}
		# ContactURI
		$tSecContactURI = NewURI($tContactURI->{'host'},$port_s, $tContactURI->{'param'});
	    }
	    $p->{'RemoteTarget'} = StrURI($tSecContactURI,'NoBrackets');						# RequestURI
	}
    } elsif ($p->{'Usage'} eq 'Register') {
	# 
	CtSvError('fatal', "not implimented");
	return;
	
    } elsif ($p->{'Usage'} eq 'Subscribe') {
	# 
	CtSvError('fatal', "not implimented");
	return;
    } else {
	CtSvError('fatal', "unknown usage: $p->{'Usage'}");
	return;
    }

    #------------------------------
    # 
    #------------------------------
    CtSvCreateDlg($dialogid, $p, $node);
}


#-----------------------------------------------------------------------------
# 
#   
#       
#   
#     $dialogid
#     $msg
#     $tnode
#
#             
#     $node
#   
#     
#   
#     
#     
#   
#-----------------------------------------------------------------------------
sub CtSvCreateDlgFromReq {
    my ($dialogid, $msg, $tnode, $node) = @_;
    my ($method);
    my ($param);

    # 
    if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
    if (ref($node) ne 'HASH') {
        CtSvError('fatal', "node is not HASH");
        return '';
    }

    $method = CtFlv('SL,method', $msg);
    if ($method eq '') {
	return;
    }

    if ($msg->{'#Direction#'} eq 'in') {

	# --------------------------------------------------------------------------------------
	# 
	# --------------------------------------------------------------------------------------
	# 
	# --------------------------------------------------------------------------------------
	# CallID                Call-ID:
	# RemoteTarget		Contact:URI
	# LocalURI,Contact                              INVITE
	#                                               SUBSCRIBE
	#                                               REGISTER
	# LocalURI,AoR          To:URI
	# LocalURI,DisplayName  To:DisplayName
	# LocalTag                                      
	# LocalSeqNum                                   
	# RemoteURI,AoR		From:URI
	# RemoteURI,DisplayName	From:DisplayName
	# RemoteTag             From:Tag
	# RemoteSeqNum          CSeq:Num
	# RouteSet              Record-Route:
	# SecureFlag            RequestURI
	# DialogState                                   Terminated
	# Direction                                     Callee
	# Usage                                         Invite|Subscribe|Register
	# --------------------------------------------------------------------------------------
	$param = {
	    'CallID'       => CtFlv('HD,#Call-ID,call-id', $msg),
	    'RemoteTarget' => CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg),
	    'LocalURI' => {
		Contact     => '',	# 
		AoR         => CtFlv('HD,#To,addr,uri,#TXT#', $msg),
		DisplayName => CtFlv('HD,#To,addr,display', $msg)
	    },
		    'LocalTag'    => '',
		    'LocalSeqNum' => '',
		    'RemoteURI' => {
			AoR         => CtFlv('HD,#From,addr,uri,#TXT#', $msg),
			DisplayName => CtFlv('HD,#From,addr,display', $msg)
		},
			    'RemoteTag'    => CtFlv('HD,#From,params,list,tag-id', $msg),
			    'RemoteSeqNum' => CtFlv('HD,#CSeq,cseqnum', $msg),
			    'RouteSet'     => CtFlv('HD,#Record-Route,routes,addr,#TXT#', $msg),
			    'SecureFlag'   => (CtFlv('SL,uri,scheme', $msg) eq 'sips') ? 'TRUE' : 'FALSE',
			    'Direction'    => 'Callee',	# Callee
			    'Usage'        => '',		# 
	};
	if ($method eq 'INVITE') {
	    if ($tnode eq '') {
		CtSvError('fatal', "terminate node is not specified");
		return;
	    }
	    if(CtEnableIpsec()){
		$param->{'LocalURI'}->{'Contact'} = StrURI(CtTbl('UC,SecContactURI',$tnode), 'NoBrackets');	# 
	    }else{
		$param->{'LocalURI'}->{'Contact'} = StrURI(CtTbl('UC,ContactURI',$tnode), 'NoBrackets','show5060');	# 

	    }
	    $param->{'Usage'} = 'Invite';	# Invite
	} elsif ($method eq 'SUBSCRIBE') {
	    if ($tnode eq '') {
		CtSvError('fatal', "terminate node is not specified");
		return;
	    }
	    $param->{'LocalURI'}->{'Contact'} = StrURI(CtTbl('UC,ContactURI',$tnode), 'NoBrackets');	# 
	    $param->{'Usage'} = 'Subscribe';# Subscribe
	} elsif ($method eq 'REGISTER') {
	    $param->{'LocalURI'}->{'Contact'} = CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg);
	    $param->{'Usage'} = 'Register',	# Register
	} else {
	    # 
	    MsgPrint('WAR', "no dialog created for unsupported method [%s]\n", $method);
	    return;
	}
    } elsif ($msg->{'#Direction#'} eq 'out') {
	# --------------------------------------------------------------------------------------
	# 
	# --------------------------------------------------------------------------------------
	# 
	# --------------------------------------------------------------------------------------
	# CallID				Call-ID:
	# RemoteTarget			SL:RequestURI [
	# LocalURI,Contact		Contact:URI	
	# LocalURI,AoR			From:URI
	# LocalURI,DisplayName	From:DisplayName
	# LocalTag				From:Tag
	# LocalSeqNum			CSeq:Num
	# RemoteURI,AoR			To:URI
	# RemoteURI,DisplayName	To:DisplayName
	# RemoteTag										
	# RemoteSeqNum									
	# RouteSet				Route: [
	# SecureFlag			RequestURI
	# DialogState									Terminated
	# Direction										Caller
	# Usage											Invite|Subscribe|Register
	# --------------------------------------------------------------------------------------
	# [
	#     
	#     
	#     
	# --------------------------------------------------------------------------------------
	$param = {
	    'CallID'       => CtFlv('HD,#Call-ID,call-id', $msg),
	    'RemoteTarget' => CtFlv('SL,uri,#TXT#', $msg),
	    'LocalURI' => {
		Contact     => CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg),
		AoR         => CtFlv('HD,#From,addr,uri,#TXT#', $msg),
		DisplayName => CtFlv('HD,#From,addr,display', $msg)
	    },
		    'LocalTag'    => CtFlv('HD,#From,params,list,tag-id', $msg),
		    'LocalSeqNum' => CtFlv('HD,#CSeq,cseqnum', $msg),
		    'RemoteURI' => {
			AoR         => CtFlv('HD,#To,addr,uri,#TXT#', $msg),
			DisplayName => CtFlv('HD,#To,addr,display', $msg)
		},
			    #	'RemoteTag'    => CtFlv('HD,#To,params,list,tag-id', $msg),	# XXX:
			    'RemoteTag'    => '',
			    'RemoteSeqNum' => '',
			    'RouteSet'     => CtFlv('HD,#Route,#REST#', $msg),
			    'SecureFlag'   => (CtFlv('SL,uri,scheme', $msg) eq 'sips') ? 'TRUE' : 'FALSE',
			    'Direction'    => 'Callee',	# Callee
			    'Usage'        => '',		# 
	};
	if ($method eq 'INVITE') {
	    $param->{'Usage'} = 'Invite';	# Invite
	} elsif ($method eq 'SUBSCRIBE') {
	    $param->{'Usage'} = 'Subscribe';# Subscribe
	} elsif ($method eq 'REGISTER') {
	    # XXX:1st REGISTER
	    #     
	    # XXX:
	    ##	$param->{'LocalURI'}->{'Contact'} = StrURI(CtTbl('UC,SecContactURI',$tnode), 'NoBrackets');	# 
	    $param->{'Usage'} = 'Register',	# Register
	} else {
	    # 
	    MsgPrint('WAR', "no dialog created for unsupported method [%s]\n", $method);
	    return;
	}
    } else {
	CtSvError('fatal', "unknown direction");
	return;
    }

    CtSvCreateDlg($dialogid, $param, $node);
}


#-----------------------------------------------------------------------------
# 
#-----------------------------------------------------------------------------



#-----------------------------------------------------------------------------
# 
#   
#     $dialogid
#     $msg
#     $regname
#     $node
#   
#     
#   
#     SIP
#     CtSvDlgUpdate()
#       (1) SUBSCRIBE
#       (2) SUBSCRIBE
#-----------------------------------------------------------------------------
#
#	'DLG' => {						# 
#		'DlgName' => {				# hashkey:Dialog
#			'CallID'       => '',
#			'RemoteTarget' => '',
#			'LocalURI' => {
#				'AoR'         => '',
#				'DisplayName' => '',
#				'Contact'     => '',
#			},
#			'LocalTag'    => '',
#			'LocalSeqNum' => '',
#			'RemoteURI' => {
#				'AoR'         => '',
#				'DisplayName' => '',
#			},
#			'RemoteTag'    => '',
#			'RemoteSeqNum' => '',
#			'RouteSet'     => '',
#			'DialogState'  => '',
#
#			# 
#
#			'Usage'  => '',		# 
#
#			# 
#		#	'SubscribedTime' => '',		# SUBSCRIBE
#			'ExpireTime'     => '',		# Expire
#										# 
#			'RegInfo' => {				# reg-event
#										# NOTIFY
#				'_version'     => '',
#				'_state'       => '',	# full|partial
#				'registration' => '',	# REG
#			},
#		},
#	},
#
sub UpdateSubscribeDialog {
    my ($dialogid, $msg, $regname, $node) = @_;

    # TODO
    #   - 
    #   - 
    #   - Pending
    #   - REFER
    

# XXX: 
#	if ($dialogid eq '') {
#		CtSvError('fatal', "dialogid nothing");
#		return;
#	}
#	# 
#	if ($node eq '') { $node = $DIRRoot{'ACTND'}; }
#	if (ref($node) ne 'HASH') {
#		CtSvError('fatal', "node is not HASH");
#		return '';
#	}

    # 
    # 
    # 
    
    my ($method, $status, $dlgstate, $cseqmethod, $recroute);
    $method		= CtFlv('SL,method', $msg);
    $status		= CtFlv('SL,code', $msg);
    $dlgstate	= CtSvDlg($dialogid, 'DialogState', $node);
    $cseqmethod	= CtFlv('HD,#CSeq,method', $msg);
    $recroute	= CtFlv('HD,#Record-Route,routes,addr,#TXT#', $msg);

    if ($dlgstate eq 'Terminated') {
	# Terminated

	if ($msg->{'#Direction#'} eq 'out' && ($method && !$status)) {
	    # Terminated

	    # 
	    # ENCODE
	    
	    # 
	    # 
	    if (($method eq "SUBSCRIBE") or $method eq "NOTIFY") {
		if (CtFlv('HD,#Call-ID,call-id', $msg)) {
		    CtTbSet("DLG,$dialogid,CallID", CtFlv('HD,#Call-ID,call-id', $msg), $node);
		}
		if (CtFlv('HD,#From,addr,uri,#TXT#', $msg)) {
		    CtTbSet("DLG,$dialogid,LocalURI,AoR", CtFlv('HD,#From,addr,uri,#TXT#', $msg), $node);
		}
		if (CtFlv('HD,#From,params,list,tag-id', $msg)) { 
		    CtTbSet("DLG,$dialogid,LocalTag", CtFlv('HD,#From,params,list,tag-id', $msg), $node);
		}
		if (CtFlv('HD,#CSeq,cseqnum', $msg)) {
		    CtTbSet("DLG,$dialogid,LocalSeqNum", CtFlv('HD,#CSeq,cseqnum', $msg), $node);
		}
		if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {	
		    CtTbSet("DLG,$dialogid,LocalURI,Contact", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		}
		if (CtFlv('HD,#To,addr,uri,#TXT#', $msg)) {
		    CtTbSet("DLG,$dialogid,RemoteURI,AoR", CtFlv('HD,#To,addr,uri,#TXT#', $msg), $node);
		}
		if ($method eq "SUBSCRIBE") {
                    my $expires = CtFlv('HD,#Expires,seconds', $msg) ||
                        CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires', $msg);
		    if ($expires) {
			CtTbSet("DLG,$dialogid,ExpireTime", $expires + time(), $node);
		    }
		    # XXX:RegInfo
		}
	    }

	} elsif ($msg->{'#Direction#'} eq 'in' && ($method && !$status)) {
	    # Terminated
	    
	    if ($method eq "SUBSCRIBE") {
		# SUBSCRIBE
		# (2xx

		CtTbSet("DLG,$dialogid,CallID", CtFlv('HD,#Call-ID,call-id', $msg), $node);
		CtTbSet("DLG,$dialogid,RemoteURI,AoR", CtFlv('HD,#From,addr,uri,#TXT#', $msg), $node);
		CtTbSet("DLG,$dialogid,RemoteURI,DisplayName", CtFlv('HD,#From,addr,display', $msg), $node);
		if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
		    CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		}

		CtTbSet("DLG,$dialogid,RemoteTag", CtFlv('HD,#From,params,list,tag-id', $msg), $node);

		# RemoteSeqNum
		if (CtFlv('HD,#CSeq,cseqnum', $msg) > CtSvDlg($dialogid,'RemoteSeqNum')) {
		    CtTbSet("DLG,$dialogid,RemoteSeqNum", CtFlv('HD,#CSeq,cseqnum', $msg), $node);
		}

		CtTbSet("DLG,$dialogid,RouteSet", $recroute, $node);
		CtTbSet("DLG,$dialogid,SecureFlag", (CtFlv('SL,uri,scheme', $msg) eq 'sips')?'TRUE':'FALSE', $node);

		# ExpireTime
		{
		    # XXX:SUBSCRIBE
		    #     2xx
		    my $expires = CtFlv('HD,#Expires,seconds', $msg) ||
		                  CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires', $msg);
		    if ($expires eq '') {
			# Expires
			$expires = 3761;	# Default Duration(RFC3680)
		    }
		    $expires += time();
		    CtTbSet("DLG,$dialogid,ExpireTime", $expires, $node);
		}
		if ((CtFlv('HD,#Event,eventtype', $msg)) eq 'reg') {
		    # reg-event
		    if (!CtSvDlg($dialogid, 'RegInfo', $node)) {	# XXX:
			my ($reginfo) ;
			# XXX:
			my ($registration) =  CtSvRegGet($regname, $node);
			if (!$registration) {
			    CtSvError('fatal', "cannot get registration($regname)");
			    return;
			}
                        $registration = CtUtHashCopy($registration);
			$reginfo->{'_version'}     = 0;
			$reginfo->{'_state'}       = 'full';
			$reginfo->{'registration'} = $registration;
			CtTbSet("DLG,$dialogid,RegInfo", $reginfo, $node);
			#	DumpValue($reginfo);			# DEBUG
		    }
		}
	    } elsif ($method eq "NOTIFY") {
		# 2xx
		# XXX:
	    } else {
		# 
	    }

	} elsif ($msg->{'#Direction#'} eq 'out' && (!$method && $status)) {
	    # Terminated

	    if ($status =~ /^[2]/) {
		# SUBSCRIBE
		if ($cseqmethod eq 'SUBSCRIBE') {
		    # Active
		    CtTbSet("DLG,$dialogid,DialogState", 'Active', $node);
		    CtTbSet("DLG,$dialogid,RouteSet", $recroute, $node);
		}
	    } else {
		# Terminated
	    }

	} elsif ($msg->{'#Direction#'} eq 'in' && (!$method && $status)) {
	    # Terminated

	    if ($status =~ /^[2]/) {
		# SUBSCRIBE
		if ($cseqmethod eq 'SUBSCRIBE') {
		    # Active
		    CtTbSet("DLG,$dialogid,DialogState", 'Active', $node);
		    # ExpireTime
		    {
			my $expires = CtFlv('HD,#Expires,seconds', $msg) ||
			              CtFlv('HD,#Contact,c-params,#ContactParam,h-params,list,#CPExpires,expires', $msg);
			if ($expires ne '') {
			    $expires += time();
			    CtTbSet("DLG,$dialogid,ExpireTime", $expires, $node);
			} else {
			}
		    }
		}

		if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
		    CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		}
		CtTbSet("DLG,$dialogid,RemoteTag", CtFlv('HD,#To,params,list,tag-id', $msg), $node);
		CtTbSet("DLG,$dialogid,RouteSet", ref($recroute) eq 'ARRAY' ? [reverse(@$recroute)] : $recroute, $node);
	    } else {
		# Terminated
	    }

	} else {
	    CtSvError('fatal', "Invalid Message");
	    return;
	}
	
	return;
    }
    elsif ($dlgstate eq 'Active')
    {
	
	if ($msg->{'#Direction#'} eq 'out' && ($method && !$status)) {
	    # Active
	    
	    if ($method eq "NOTIFY") {
		# terminate NOTIFY
		# 
		#	if (CtFlv('HD,#Subscription-State,substate', $msg) eq 'terminated') {
		#		CtTbSet("DLG,$dialogid,DialogState", 'Terminated', $node);
		#	}
	    } else {
		# 
	    }

	} elsif ($msg->{'#Direction#'} eq 'in' && ($method && !$status)) {
	    # Active

	    # RemoteSeqNum
	    if (CtFlv('HD,#CSeq,cseqnum', $msg) > CtSvDlg($dialogid,'RemoteSeqNum')) {
		CtTbSet("DLG,$dialogid,RemoteSeqNum", CtFlv('HD,#CSeq,cseqnum', $msg), $node);
	    }
	    
	    # RemoteTarget
	    #	if ( ($method eq "SUBSCRIBE")  or ($method eq "REFER") ) {
	    if ($method eq "SUBSCRIBE") {
		# 
		# RemoteTarget
		if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
		    CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		}
	    } elsif ($method eq "NOTIFY") {
		# 
		# RemoteTarget
		if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
		    CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		}
		# terminate NOTIFY
		if (CtFlv('HD,#Subscription-State,substate', $msg) eq 'terminated') {
		    # Subscription-State
		    CtTbSet("DLG,$dialogid,DialogState", 'Terminated', $node);
		}
	    } else {
		# 
	    }

	} elsif ($msg->{'#Direction#'} eq 'out' && (!$method && $status)) {
	    # Active

	    #	if ( ($cseqmethod eq "SUBSCRIBE") or ($cseqmethod eq "NOTIFY") or ($cseqmethod eq "REFER") ) {
	    if ( ($cseqmethod eq "SUBSCRIBE") or ($cseqmethod eq "NOTIFY") ) {
		if ($status =~ /404|405|410|416|480|481|482|483|484|485|489|501|502|604/) {
		    # Dialog
		    # Terminated
		    # 
		    #---------+---------------------------------+-------------+
		    #   Code  | Reason                          |    Impact   |
		    #---------+---------------------------------+-------------+
		    #   404   | Not Found                       |    Dialog   |
		    #   405   | Method Not Allowed              |    Usage    |
		    #   410   | Gone                            |    Dialog   |
		    #   416   | Unsupported URI Scheme          |    Dialog   |
		    #   480   | Temporarily Unavailable         |    Usage    |
		    #   481   | Call/Transaction Does Not Exist |    Usage    |
		    #   482   | Loop Detected                   |    Dialog   |
		    #   483   | Too Many Hops                   |    Dialog   |
		    #   484   | Address Incomplete              |    Dialog   |
		    #   485   | Ambiguous                       |    Dialog   |
		    #   489   | Bad Event                       |    Usage    |
		    #   501   | Not Implemented                 |    Usage    |
		    #   502   | Bad Gateway                     |    Dialog   |
		    #   604   | Does Not Exist Anywhere         |    Dialog   |
		    #---------+---------------------------------+-------------+
		    CtTbSet("DLG,$dialogid,DialogState", 'Terminated', $node);
		}
	    }
	} elsif ($msg->{'#Direction#'} eq 'in' && (!$method && $status)) {
	    # Active
	    
	    #	if ( ($cseqmethod eq "SUBSCRIBE") or ($cseqmethod eq "NOTIFY") or ($cseqmethod eq "REFER") ) {
	    #	if ( ($cseqmethod eq "SUBSCRIBE") or ($cseqmethod eq "NOTIFY") ) {
	    if ( ($cseqmethod eq "SUBSCRIBE") ) {
		if ($status =~ /^[2]/) {
		    # 
		    # RemoteTarget
		    if (CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg)) {
			CtTbSet("DLG,$dialogid,RemoteTarget", CtFlv('HD,#Contact,c-params,addr,uri,#TXT#', $msg), $node);
		    }
		} elsif ($status =~ /404|405|410|416|480|481|482|483|484|485|489|501|502|604/) {
		    # Dialog
		    # Terminated
		    CtTbSet("DLG,$dialogid,DialogState", 'Terminated', $node);
		} else {
		    # 
		}
	    }
	} else {
	    CtSvError('fatal', "Invalid Message");
	    return;
	}

	return;
    }
    else {
	CtSvError('fatal', "Invalid Dialog[$dialogid] State");
	return;
    }

    return;
}

#-------------------------------------
# URI
#-------------------------------------
# $URI => {		# URI
#	'host' => '',
#	'port' => '',
#	'param' => '',
# }
# XXX: scheme, diplayname
#-------------------------------------
sub StrURI {
    my ($uri, $noBrackets,$show5060) = @_;
    my ($str);

    if (!$uri) {
	CtSvError('fatal', "null uri is passed");
	return '';
    }
    $str = 'sip:' . (IsIPV6Address($uri->{'host'}) ? '['.$uri->{'host'}.']' : $uri->{'host'});
    if ($uri->{'port'} && ($show5060 || $uri->{'port'} != 5060)) { # 5060
	# XXX:5060
	$str .= ":$uri->{'port'}";
    }
    if ($uri->{'param'}) {
	$str .= ";$uri->{'param'}";
    }
    if (!$noBrackets) {
	$str = '<' . $str . '>';
    }

    return $str;
}

sub StrURI_no_port {
    my ($uri, $noBrackets) = @_;
    my ($str);

    if (!$uri) {
	CtSvError('fatal', "null uri is passed");
	return '';
    }
    $str = 'sip:' . (IsIPV6Address($uri->{'host'}) ? '['.$uri->{'host'}.']' : $uri->{'host'});
    if (!$noBrackets) {
	$str = "<sip:$host";
    } else {
	$str = "sip:$host";
    }
    if ($uri->{'param'}) {
	$str .= ";$uri->{'param'}";
    }
    if (!$noBrackets) {
	$str = '<' . $str . '>';
    }

    return $str;
}

#-------------------------------------
# IMPU
#-------------------------------------
# $IMPU => {		# IMPU
#	'DisplayName' => '',
#	'URI' => '',		# sip|tel URI
# }
# XXX: URI
#-------------------------------------
sub StrIMPU {
    my ($impu) = @_;
    my ($str) = '';

    if (!$impu) {
	CtSvError('fatal', "null impu is passed");
	return '';
    }
    if ($impu->{'DisplayName'}) {
	$str = "\"$impu->{'DisplayName'}\"" . ' ';
    }
    $str .= "<$impu->{'URI'}>";
    return $str;
}

#-------------------------------------
# Via
#-------------------------------------
# $Via => {		# Via
#	'proto' => '',	# transport
#	'host' => '',
#	'port' => '',
#	'param' => '',
# }
#-------------------------------------
sub StrVia {
    my ($via,$show5060) = @_;
    my ($str,$host);

    if (!$via) {
	CtSvError('fatal', "null via is passed");
	return '';
    }
    $host = IsIPV6Address($via->{'host'}) ? '['.$via->{'host'}.']' : $via->{'host'};
    $str = "SIP/2.0/$via->{'proto'} $host";
    if ($via->{'port'} && ($show5060 || $via->{'port'} != 5060)) {
	# XXX:5060
	$str .= ":$via->{'port'}";
    }
    if ($via->{'param'}) {
	$str .= ";$via->{'param'}";
    }
    return $str;
}

sub StrVia_no_port {
    my ($via) = @_;
    my ($str,$host);

    if (!$via) {
	CtSvError('fatal', "null via is passed");
	return '';
    }
    $host = CtUtIPAdType($via->{'host'}) ? '['.$via->{'host'}.']' : $via->{'host'};
    $str = "SIP/2.0/$via->{'proto'} $host";

    if (CtEnableIpsec() || ($via->{'port'} && ($via->{'port'} != 5060))) {
	# XXX:5060
	$str .= ":$via->{'port'}";
    }
    if ($via->{'param'}) {
	$str .= ";$via->{'param'}";
    }
    return $str;
}



#-------------------------------------
# URI
#-------------------------------------
sub NewURI {
    my ($host, $port, $param) = @_;
    my ($newURI);

    if ($host) {
	$newURI->{'host'} = $host;
    } else {
	CtSvError('fatal', "host name is not specified");
	return undef;
    }
    if ($port) {
        $newURI->{'port'} = $port;
    } else {
        $newURI->{'port'} = '';
    }
    if ($param) {
        $newURI->{'param'} = $param;
    } else {
        $newURI->{'param'} = '';
    }
    return $newURI;
}

#-------------------------------------
# Via
#-------------------------------------
sub NewVia {
    my ($proto, $host, $port, $param) = @_;
    my ($newVia);

    if ($proto) {
	$newVia->{'proto'} = $proto;
    } else {
	# 
	$newVia->{'proto'} = 'UDP';
    }
    if ($host) {
	$newVia->{'host'} = $host;
    } else {
	CtSvError('fatal', "host name is not specified");
	return undef;
    }
    if ($port) {
	$newVia->{'port'} = $port;
    } else {
	$newVia->{'port'} = '';
    }
    if ($param) {
	$newVia->{'param'} = $param;
    } else {
	$newVia->{'param'} = '';
    }
    return $newVia;
}


#----------------------------------
# 
#----------------------------------
sub DumpValue {
    use Dumpvalue;
    my ($val) = @_;
    my $dumper = new Dumpvalue;
    $dumper->dumpValue($val);
}



###############################################################################
# Via,Record-Route,Max-Forwards
###############################################################################
# XXX: 
###############################################################################

#------------------------------------------
# Via
#------------------------------------------
# Via: IniPath/DlgPath
#      Protected/UnProtected(ini-REGISTER/non-ini-REGISTER)
# RR:  
#      Protected/UnProtected(ini-REGISTER/non-ini-REGISTER)
#
#------------------------------------------
#  
#------------------------------------------
# 
#   (1)
#      (a) 
#      REGISTER
#   (2)
#      (a) 
#      (b) 
#
# 
#   (1) 
#       
#       Via:         (
#                    
#       RecordRoute: (
#                    
#       Max-Forward: 70 - (
#   (2) 
#       
#       Via:         (
#                    
#       RecordRoute: 
#                    
#       Max-Forward: 70 - (
#
#   
#   
#
#   (3) ini-REGISTER
#       
#       Via:         (
#                    
#                    P
#       RecordRoute: 
#       Max-Forward: 70 - (
#   (4) ini-REGISTER
#       
#       Via:         (
#                    
#       RecordRoute: 
#       Max-Forward: 70 - (REGISTER
#
# 
#   (1) 
#       
#       Via:         
#       RecordRoute: 
#                    
#                    
#   (2) 
#       
#       Via:         
#       RecordRoute: 


#--------------------------------------------------------------
# branch
#--------------------------------------------------------------
sub GenBranch {
    return "branch=z9hG4bK" . CtFlRandHexStr(4);
}

#--------------------------------------------------------------
# Via
#--------------------------------------------------------------
#   
#     $pathName
#     $termNode
#     $emuNode
#     $withinDlg
#     $protected:
#     $addRcvd:
#   
#     
#   
#     
#--------------------------------------------------------------
sub CtSvGenRequestVia {
    my ($pathName, $termNode, $emuNode, $withinDlg, $protected, $addRcvd) = @_;
    my ($nodes,@via,$beforeNode);
    my ($via) = [];
    my ($func) = sub {		# 
	my ($nodeName, $val) = @_;
	if ($val) {
	    unshift(@$val,$nodeName);	# 
	} else {
	    $val = [$nodeName];
	}
	return $val;
    };
    my ($funcDlg) = sub {	# 
	my ($nodeName, $val) = @_;
	# 
	if ( (CtTbl('UC,NodeType', $nodeName) eq 'U') or (CtTbl('UC,AddRecRoute', $nodeName)) ) {
	    if ($val) {
		unshift(@$val,$nodeName);	# 
	    } else {
		$val = [$nodeName];
	    }
	}
	return $val;
    };

    if (!$pathName) {
	CtSvError('fatal', "no path name is specified");
	return undef;
    }
    if ($withinDlg) {
	$nodes = CtTraceMessagePath($pathName, $funcDlg, $termNode, $emuNode);
    } else {
	$nodes = CtTraceMessagePath($pathName, $func, $termNode, $emuNode);
    }
    if (!$nodes) {
	MsgPrint('WAR', "cannot get nodes for $pathName\n");
	return undef;
    }

    # 
    foreach my $nodeName (@$nodes) {
	my ($nodeType);
	my ($addRR, $v);
	my ($nd);

	$nodeType = CtTbl('UC,NodeType', $nodeName);

	if ($nodeType eq 'U') {
	    # UE
	    if (!$protected) {
		# IPSec
		#   Via
		$v = CtTbl('UC,Via', $nodeName);
	    } else {
		# IPSec
		#   SecVia
		$v = CtTbl('UC,SecVia', $nodeName);
	    }
	} else {
	    # UE
	    if ( $protected && 			# ini-REGISTER
		 ($nodeType eq 'P') &&
		 ($nodeName eq $emuNode) )	# XXX:
	    {
		# 
		$v = CtTbl('UC,SecVia', $nodeName);
	    } else {
		# 
		$v = CtTbl('UC,Via', $nodeName);
	    }
	}
	if ($v) {
	    # via
	    push(@$via, {'rr'=>$v,
                         'show5060'=>((!$beforeNode && $nodeType =~/[PU]/) || 
                                      $beforeNode eq 'U' || ($beforeNode eq 'P' && $nodeType eq 'U'))});
	} else {
	    MsgPrint('WAR', "cannot get Via of $nodeName\n");
	}
	$beforeNode=$nodeType;
    }

    # 
    for (my $i=0; $i<@$via; $i++) {
	my $s;
	# 
	$s = StrVia($via->[$i]->{'rr'},$via->[$i]->{'show5060'}) . ';' . GenBranch();
	if ($addRcvd) {
            if ($i != 0) {
                if ( !CtUtIp($via->[$i]->{'rr'}->{'host'}) ) {
		    # host
		    my ($address);  
		    if($address = CtTbAd('local-ip',$nodes->[$i])){
			$s .= ';received='.$address;
		    }
		    else {
			MsgPrint('WAR', "cannot get address of $nodes->[$i]\n");
		    }
                }
            }
	}
        push(@via,$s);
    }

    # 
    return join(',', @via);
}

sub ViaAddReceived {
    my ($viaParm) = @_;
    my ($peer, $via, $host);

    $peer = CtTbAd('peer-ip');
    $via = CtPkEncode($viaParm, '');
    # 'Via:'
    # 
    $via =~ s/^,//;
    $host = CtFlGet('sentby,host', $viaParm);
    if (CtUtIp($host)) {
	# IP
        if (!CtUtV6Eq($host, $peer)) {
            $via .= ';received=' . $peer;
        }
    } else {
	# FQDN
        $via .= ';received=' . $peer;
    }
    return $via;
}

#--------------------------------------------------------------
# Via
#--------------------------------------------------------------
#   
#     $msg:
#   
#     
#   
#     
#     
#--------------------------------------------------------------
sub CtSvGenResponseVia {
    my ($msg) = @_;
    my ($viaParm);

    $viaParm = CtFlv('HD,#Via,records,#ViaParm', $msg);

    if (ref($viaParm) ne 'ARRAY') {
	# 
	return ViaAddReceived($viaParm);
    } else {
	my (@vias, $via);

	# 
	$via = ViaAddReceived(shift(@$viaParm));
	push(@vias, $via);

	# 2
	foreach $cur (@$viaParm) {
	    $via = CtPkEncode($cur, '');
	    # 'Via:'
	    # 
	    $via =~ s/^,//;
	    push(@vias, $via);
	}
	#	return (join("\r\nVia: ", @vias) );
	return (join(",", @vias) );
    }
}

#--------------------------------------------------------------
# RecordRoute
#--------------------------------------------------------------
#   
#     $pathName
#     $termNode
#     $emuNode
#     $forRequest
#     $protected:
#   
#     
#   
#     
#--------------------------------------------------------------
sub CtSvGenRecRoute {
    my ($pathName, $termNode, $emuNode, $forRequest, $protected, $noStr) = @_;
    my ($nodes,$beforeNode);
    my ($recRoute) = [];
    my ($func) = sub {
	# 
	my ($nodeName, $val) = @_;
	if ($val) {
	    unshift(@$val,$nodeName);	# 
	} else {
	    $val = [$nodeName];
	}
	return $val;
    };

    if (!$pathName) {
	CtSvError('fatal', "no path name is specified");
	return undef;
    }

    $nodes = CtTraceMessagePath($pathName, $func, $termNode, $emuNode);
    if (!$nodes) {
	MsgPrint('WAR', "cannot get nodes for $pathName\n");
	return undef;
    }

    # 
    foreach my $nodeName (@$nodes) {
	my ($nodeType);
	my ($addRR, $rr);
	my ($nd);

	if ($nodeName eq $termNode) {
	    # 
	    next;
	}

	$nodeType = CtTbl('UC,NodeType', $nodeName);
	$addRR = CtTbl('UC,AddRecRoute', $nodeName);

	if ( $addRR) {
	    # RecordRoute
	    if ( $protected && 			# ini-REGISTER
		 ($nodeType eq 'P') &&
		 ($nodeName eq $emuNode) )	# XXX:
	    {
		# 
                if(CtSecurityScheme() eq 'sipdigest'){
                    $rr = CtTbl('UC,RecRouteURI', $nodeName);
                }
                else{
                    $rr = CtTbl('UC,SecRouteURI', $nodeName);
                }
	    } else {
		# 
		$rr = CtTbl('UC,RecRouteURI', $nodeName);
	    }
	}
        # printf("[%s][%s][%s]\n",$beforeNode,$nodeType,((!$beforeNode && $nodeType =~/[PU]/) || 
        #                              $beforeNode eq 'U' || ($beforeNode eq 'P' && $nodeType eq 'U')));
	if ($rr) {
	    # rr
	    push(@$recRoute, {'rr'=>$rr,
                              'show5060'=>((!$beforeNode && $nodeType =~/[PU]/) || 
                                           $beforeNode eq 'U' || ($beforeNode eq 'P' && $nodeType eq 'U'))});
	} else {
	    # UE
	}
	$beforeNode=$nodeType;
    }

    if (!$forRequest) {
	# 
	# XXX:
	#     
	@$recRoute = reverse(@$recRoute);
    }

    # 
    if($noStr){return $recRoute}

    # 
    $recRoute = join(',', map{StrURI($_->{'rr'},'',$_->{'show5060'})}(@$recRoute));

    return $recRoute;
}

#--------------------------------------------------------------
# MaxForwards
#--------------------------------------------------------------
#   
#     $pathName
#     $termNode
#     $emuNode
#     $withinDlg
#   
#     
#   
#     
#--------------------------------------------------------------
sub CtSvGenMaxForwards {
    my ($pathName, $termNode, $emuNode, $withinDlg) = @_;
    my ($nodes);
    my ($nd);
    my ($hop) = 0;
    my ($func) = sub {
	my ($nodeName, $hop) = @_;
	my ($nodeType, $addRR);

	$nodeType = CtTbl('UC,NodeType', $nodeName);
	if ($nodeType eq 'U') {
	    $hop++;
	} else {
	    $addRR = CtTbl('UC,AddRecRoute', $nodeName);
	    if (!$withinDlg || $addRR) {
		$hop++
	    }
	}
  
	return $hop;
	
    };

    if (!$pathName) {
	CtSvError('fatal', "no path name is specified");
	return undef;
    }
    $hop = CtTraceMessagePath($pathName, $func, $termNode, $emuNode);
 
   return 70 - ($hop - 1);
}


###############################################################################
# 
###############################################################################

#----------------------------------------------------------------------
# DefaultRouteSet
#----------------------------------------------------------------------
#   
#     $pcscf
#     $msg
#     $tnode
#   
#     
#   
#     Route
#     
#     
#   
#   
#----------------------------------------------------------------------
sub CtSvSetDefaultRouteSetFrom200Reg {
    my ($pcscf, $msg, $tnode, $negoname) = @_;
    my ($p, $serv_route, @route_set);

    if (!$pcscf) {
	CtSvError('fatal', "pcscf is not specified");
	return;
    }

    if(CtEnableIpsec()){
	# (1) P
	$p = CtTbl('UC,SecRouteURI', $pcscf);
	#   add by hok 
	$p->{'port'} = CtSecNego($negoname,'port_ps',$tnode) || $p->{'port'};
    }
    else{
	$p = CtTbl('UC,RecRouteURI', $pcscf);
    }
    if (!$p) {
	CtSvError('fatal', "cannot get SecRouteURI of $pcscf");
	return;
    }
    push(@route_set, StrURI($p,'','show5060'));

    # (2) 200 REGISTER
    $serv_route = CtFlv('HD,#Service-Route,routes,#RouteParam,addr,#TXT#', $msg);
    if (!$serv_route) {
	CtSvError('fatal', "cannot get Service-Route header");
	return;
    }
    push(@route_set, $serv_route);

    CtTbSet('UC,DefaultRouteSet', \@route_set, $tnode);  # UC,DefaultRouteSet
}

#----------------------------------------------------------------------
# SecurityClient
#----------------------------------------------------------------------
#   
#     $tnode
#   
#     
#   
#     UE
#     
#   
#----------------------------------------------------------------------
sub CtSvSetSecurityClient {
    my ($tnode,$negoname) = @_;
    my ($mech, $q, $alg, $ealg, $spi_c, $spi_s, $port_c, $port_s);
    my ($str);

    $str = CtSecNego($negoname,'mech', $tnode) || 'ipsec-3gpp';  # 
    if( $q = CtSecNego($negoname,'q', $tnode) ){ $str .= '; q=' . $q; }
    $str .= '; alg=' . (CtSecNego($negoname,'alg', $tnode) || 'hmac-sha-1-96'); # 
    if( $ealg = CtSecNego($negoname,'ealg', $tnode) ){
	# ealg
	$str .= '; ealg='.$ealg;
    }
    $str .= '; mode="trans"' .
	'; spi-c='  . CtSecNego($negoname,'spi_lc',$tnode) .
	'; spi-s='  . CtSecNego($negoname,'spi_ls',$tnode) .
	'; port-c=' . CtSecNego($negoname,'port_lc',$tnode) .
	'; port-s=' . CtSecNego($negoname,'port_ls',$tnode);

    CtTbSet('UC,SecurityClient', $str, $tnode);
}

#----------------------------------------------------------------------
# DefaultRouteSet
#----------------------------------------------------------------------
# UC,DefaultRouteSet
# XXX:REGISTER
#     
#----------------------------------------------------------------------
sub CtSvSetDefaultRouteSetFromUC {
    my ($pcscf, $scscf, $tnode) = @_;	# $tnode
    if (CtTbl('UC,DefaultRouteSet', $tnode) eq '') {
	# XXX: REGISTER
	#      
	my (@route_set, $serv_route);
	# (1) P
	push(@route_set, StrURI(CtTbl('UC,SecRouteURI', $pcscf)));
	# (2) S-CSCFa1
	$serv_route = CtTbl('UC,ServiceRoute', $scscf);
	push(@route_set, $serv_route);
	CtTbSet('UC,DefaultRouteSet', \@route_set, $tnode);  # UC,DefaultRouteSet
    } else {
	MsgPrint('WAR', "UC,DefaultRouteSet is already defined");
    }
}

#----------------------------------------------------------------------
# SecurityVerify
#----------------------------------------------------------------------
# Security-Verify
# 
# XXX:REGISTER
#     
#----------------------------------------------------------------------
sub CtSvSetSecurityVerifyFromUC {
    my ($pcscf, $tnode, $negoname) = @_;	# $tnode
    my ($mech, $q, $alg, $ealg, $spi_c, $spi_s, $port_c, $port_s);
    my ($sv);

    if (!$pcscf) {
	# pcscf
	# 
	$pcscf = CtTbPrm('CI,target');
	if ($pcscf eq '') {
	    CtSvError('fatal', "cannot get target");
	    return '';
	}
    }
    $mech = CtSecNego($negoname,'mech', $pcscf) || CtSecNego($negoname,'mech', $tnode);   # ipsec-3gpp
    if (!$mech) {
	$mech = 'ipsec-3gpp';
    }
    $sv = "$mech; ";
    $q = CtSecNego($negoname,'q', $pcscf) || CtSecNego($negoname,'q', $tnode);                # q
    if ($q) { $sv .= "q=$q; "; }
    $alg = CtSecNego($negoname,'alg', $pcscf) || CtSecNego($negoname,'alg', $tnode);      # alg
    if ($alg) {
	$sv .= "alg=$alg; ";
    } else {
	$sv .= "alg=hmac-sha-1-96; ";
    }
    $ealg = CtSecNego($negoname,'ealg', $pcscf) || CtSecNego($negoname,'ealg', $tnode);       # ealg
    if ($ealg && $ealg !~ /null/i) {
	$sv .= "ealg=$ealg; ";
    }
    $spi_c = CtSecNego($negoname,'spi_lc', $pcscf);    # spi-c
    $sv .= "spi-c=$spi_c; ";
    $spi_s = CtSecNego($negoname,'spi_ls', $pcscf);    # spi-s
    $sv .= "spi-s=$spi_s; ";
    $port_c = CtSecNego($negoname,'port_lc', $pcscf);  # port-c
    $sv .= "port-c=$port_c; ";
    $port_s = CtSecNego($negoname,'port_ls', $pcscf);  # port-s
    $sv .= "port-s=$port_s";

    CtTbSet('UC,SecurityVerify', $sv, $tnode);  # UC,SecurityVerify
}
sub CtMkSecurityVerify {
    my ($sa) = @_;
    return sprintf("%s; %s alg=%s; %s spi-c=%s; spi-s=%s; port-c=%s; port-s=%s",
		   $sa->{'mech'},
		   $sa->{'q'}?'q='.$sa->{'q'}.';':'',
		   $sa->{'alg'}?$sa->{'alg'}:'hmac-sha-1-96',
		   ($sa->{'ealg'} && ($sa->{'ealg'} !~ /null/i))?'ealg='.$sa->{'ealg'}.';':'',
		   $sa->{'spi_pc'}, $sa->{'spi_ps'},
		   $sa->{'port_pc'}, $sa->{'port_ps'});
    
}

sub CtGetHostFromFQDN {
    my($fqdn)=@_;
    my@host = split('@',$fqdn);
    unless(@host[1]){return};
    @host[1] =~ s/^\[(.+)\]$/$1/;
    return @host[1];
}

sub CtGetUserNameFromFQDN {
    my($fqdn)=@_;
    my@host = split('@',$fqdn);
    return @host[0];
}

# SecContactURI(config::[NODE]::contact-host) 
sub CtGetHostFromSecContactURI {
    my($node)=@_;
    my $address = CtTbl('UC,SecContactURI,host', $node);
    
    # 
    $address =~ s/^[^@]+@([^@]+)$/$1/;

    # 
    $address =~ s/^(.+):[0-9]+$/$1/;

    # IP
    $address =~ s/^\[(.+)\]$/$1/;

    return $address;
}

#----------------------------------------------------------------------
# 
#----------------------------------------------------------------------
#   
#     $node
#   
#     
#   
#     REGISTER
#     
#   
#     
#     
#----------------------------------------------------------------------
sub CtSvSaveParams {
    my ($node) = @_;
    my ($drs, $sv);

    if (!$node) {
	$node = $DIRRoot{'ACTND'};
    }
    $drs = CtTbl('UC,DefaultRouteSet', $node);
    $sv = CtTbl('UC,SecurityVerify', $node);

    if (ref($node)) {
	$node = $node->{'ID'};
    }
    if ($drs) {
	$DIRRoot{'SC'}->{'PARAM'}->{'COCFG'}->{$node}->{DefaultRouteSet} = $drs;
    }
    if ($sv) {
	$DIRRoot{'SC'}->{'PARAM'}->{'COCFG'}->{$node}->{SecurityVerify} = $sv;
    }
}

1;
