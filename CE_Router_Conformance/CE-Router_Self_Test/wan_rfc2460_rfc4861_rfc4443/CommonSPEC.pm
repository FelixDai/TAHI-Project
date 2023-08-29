#
# $Name: CE-Router_Self_Test_1_0_5 $
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
# Perl Module for IPv6 Specification Conformance Test
#
# $CHT-TL: CommonSPEC.pm,v 1.1 2014/05/19  weifen Exp $
#

package CommonSPEC;

use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	nd_vRecv_EN
	nd_vRecv_IN
	nr_vRecv_EN
	writefragdef
	%pktdesc
	);

use V6evalTool;
require './config.pl';

$Success = 0;		# subroutine exit status
$Failure = 1;

%pktdesc = (
	#--- CommonHost/Router
	'ns_l2l'	=> 'Recv Neighbor Solicitation (Link-Local to Link-Local)',
	'ns_g2l'	=> 'Recv Neighbor Solicitation (Global to Link-Local)',
	'ns_l2g'	=> 'Recv Neighbor Solicitation (Link-Local to Global)',
	'ns_g2g'	=> 'Recv Neighbor Solicitation (Global to Global)',
	'u_ns_l2l'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Link-Local)',
	'u_ns_l2l_wo'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Link-Local, without SLL)',
	'u_ns_g2l'	=> 'Recv Unicast Neighbor Solicitation (Global to Link-Local)',
	'u_ns_g2l_wo'	=> 'Recv Unicast Neighbor Solicitation (Global to Link-Local, without SLL)',
	'u_ns_l2g'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Global)',
	'u_ns_l2g_wo'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Global, without SLL)',
	'u_ns_g2g'	=> 'Recv Unicast Neighbor Solicitation (Global to Global)',
	'u_ns_g2g_wo'	=> 'Recv Unicast Neighbor Solicitation (Global to Global, without SLL)',
	'na_l2l'	=> 'Send Neighbor Advertisement (Link-Local to Link-Local)',
	'na_l2g'	=> 'Send Neighbor Advertisement (Link-Local to Global)',
	'na_g2l'	=> 'Send Neighbor Advertisement (Global to Link-Local)',
	'na_g2g'	=> 'Send Neighbor Advertisement (Global to Global)',

	#--- CommonRouter
#	'ns_g2l_link1'		=> 'Recv Neighbor Solicitation (Global to Link-Local)',
#	'u_ns_g2l_link1'	=> 'Recv Unicast Neighbor Solicitation (Global to Link-Local)',
#	'u_ns_g2l_wo_link1'	=> 'Recv Unicast Neighbor Solicitation (Global to Link-Local, without SLL)',
#	'ns_l2g_link1'		=> 'Recv Neighbor Solicitation (Link-Local to Global)',
#	'u_ns_l2g_link1'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Global)',
#	'u_ns_l2g_wo_link1'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Global, without SLL)',
#	'ns_g2g_link1'		=> 'Recv Neighbor Solicitation (Global to Global)',
#	'u_ns_g2g_link1'	=> 'Recv Unicast Neighbor Solicitation (Global to Global)',
#	'u_ns_g2g_wo_link1'	=> 'Recv Unicast Neighbor Solicitation (Global to Global, without SLL)',

#	'na_l2l_link1'		=> 'Send Neighbor Advertisement (Link-Local to Link-Local)',
#	'na_l2g_link1'		=> 'Send Neighbor Advertisement (Link-Local to Global)',
#	'na_g2l_link1'		=> 'Send Neighbor Advertisement (Global to Link-Local)',
#	'na_g2g_link1'		=> 'Send Neighbor Advertisement (Global to Global)',

	#--- Setup for Host
	'setup_ra'		=> 'Send Router Advertisement',
	'setup_dadns'		=> 'Recv DADNS',

	#--- Setup for Host/Router
	'setup_echo_request'	=> 'Send Echo Request (Link-Local)',
	'setup_echo_reply'	=> 'Recv Echo Reply (Link-Local)',
	'setup_echo_request_g'	=> 'Send Echo Request (Global)',
	'setup_echo_reply_g'	=> 'Recv Echo Reply (Global)',

	#--- Setup for Router

	#--- Cleanup for Host
	'cleanup_ra'			=> 'Send Router Advertisement (any Lifetimes set to 0)',
	'cleanup_na'			=> 'Send Neighbor Advertisement (Link-Local Address with Different Link-layer Address)',
	'cleanup_na_g'			=> 'Send Neighbor Advertisement (Global address with Different Link-layer Address)',
	'cleanup_echo_request'		=> 'Send Echo Request',
	'cleanup_echo_request_g'	=> 'Send Echo Request (Global)',

	#--- Cleanup for Router
	'cleanup_na_1'			=> 'Send Neighbor Advertisement (Link-Local Address with Different Link-layer Address)',
	'cleanup_na_g_1'		=> 'Send Neighbor Advertisement (Global Address with Different Link-layer Address)',
	'cleanup_echo_request_1'	=> 'Send Echo Request',
	'cleanup_echo_request_g_1'	=> 'Send Echo Request (Global)',

	#--- Setup and Cleanup for CERouter.1.3.2
	'setup_echo_request_tr1'   => 'Send Echo Request From TR1',
	'setup_echo_reply_tr1'     => 'Recv Echo Reply',
	'setup_ra_tr1'   => 'Send Router Advertisement',

	'ns_l2l_tr1'     => 'Recv Neighbor Solicitation (link-local to link-local) ',
	'ns_g2l_tr1'     => 'Recv Neighbor Solicitation (global to link-local) ',
	'na_l2l_tr1'     => 'Send Neighbor Advertisement (link-local to link-local) ',
	'na_l2g_tr1'     => 'Send Neighbor Advertisement (link-local to global) ',

	'cleanup_ra_tr1' => 'Send Router Advertisement (cleanup)',
	'cleanup_echo_request_tr1' => 'Send Echo Request From TR1 (cleanup)',
	'cleanup_na_tr1' => 'Send Neighbor Advertisement (cleanup) ',
);

#--- NS/NA correspondence
%nd = (
	'Link0' => {
		'ns_l2l'	=> 'na_l2l',
		'ns_g2l'	=> 'na_l2g',
		'ns_l2g'	=> 'na_g2l',
		'ns_g2g'	=> 'na_g2g',
		'u_ns_l2l'	=> 'na_l2l',
		'u_ns_l2l_wo'	=> 'na_l2l',
		'u_ns_g2l'	=> 'na_l2g',
		'u_ns_g2l_wo'	=> 'na_l2g',
		'u_ns_l2g'	=> 'na_g2l',
		'u_ns_l2g_wo'	=> 'na_g2l',
		'u_ns_g2g'	=> 'na_g2g',
		'u_ns_g2g_wo'	=> 'na_g2g',
	},
	'Link1' => {
		'ns_l2l'		=> 'na_l2l_link1',
		'ns_g2l_link1'		=> 'na_l2g_link1',
		'ns_l2g_link1'		=> 'na_g2l_link1',
		'ns_g2g_link1'		=> 'na_g2g_link1',
		'u_ns_l2l'		=> 'na_l2l_link1',
		'u_ns_l2l_wo'		=> 'na_l2l_link1',
		'u_ns_g2l_link1'	=> 'na_l2g_link1',
		'u_ns_g2l_wo_link1'	=> 'na_l2g_link1',
		'u_ns_l2g_link1'	=> 'na_g2l_link1',
		'u_ns_l2g_wo_link1'	=> 'na_g2l_link1',
		'u_ns_g2g_link1'	=> 'na_g2g_link1',
		'u_ns_g2g_wo_link1'	=> 'na_g2g_link1',
	},
);


$remote_debug = '';
$routeSet = 0;
$useRA = 0;

#===============================================================
# %ret = nd_vRecv_EN(LinkN, timeout, seektime, count, frame...)
#			- waiting for expecting packets for End Node
# %ret = nd_vRecv_IN(LinkN, timeout, seektime, count, frame...)
#			- waiting for expecting packets for Intermediate Node
#===============================================================
# argument:
#    LinkN: interface name ('Link0' or 'Link1')
#    timeout: time to stop waiting [sec.]
#    seektime: time to start waiting [sec.]
#    count: number of receiving packets
#    frame(list): expecting packet names
# return:
#    ret(hash):
#	status    - status(0: catch expected packets
#			   1: time exceeded
#			   2: count exceeded
#			 > 3: error)
#	recvCount - number of received packets
#	recvTimeN - time of receiving packet #N 
#	recvFrame - name of received packet(expected)
#===============================================================

sub nd_vRecv_EN {
	my($IF, $timeout, $seektime, $count, @frames) = @_;
	my(%ret, @recv);

	my %ndHash = %{$nd{$IF}};
	my @ndList = keys(%ndHash);

	while (1) {
		%ret = vRecv($IF, $timeout, $seektime, $count, @ndList, @frames);

		if ($ret{'status'} == 0) {
			@recv = grep {$ret{'recvFrame'} eq $_} @ndList;
			if ($recv[0]) {
				vSend($IF, $ndHash{$recv[0]});
				next;
			}

			@recv = grep {$ret{'recvFrame'} eq $_} @frames;
			if ($recv[0]) {
				last;
			}
		} else {
			last;
		}
	}

	return (%ret);
}

sub nd_vRecv_IN {
	my($IF, $timeout, $seektime, $count, @frames) = @_;
	my(%ret, @recv);

	while (1) {
		%ret = desc_vRecv($IF, $timeout, $seektime, $count, $#frames + 1, @frames, sort(keys(%{$nd{$IF}})));

		if ($ret{'status'} == 0) {
			@recv = grep {$ret{'recvFrame'} eq $_} @frames;
			if ($recv[0]) {
				last;
			}

			@recv = grep {$ret{'recvFrame'} eq $_} sort(keys(%{$nd{$IF}}));
			if ($recv[0]) {
				desc_vSend($IF, ${$nd{$IF}}{$recv[0]});
			}
		} else {
			last;
		}
	}

	return (%ret);
}


#===============================================================
# nr_vRecv_EN(LinkN, timeout, frame...)
#			- continual waiting for expecting packets for End Node
#===============================================================
# argument:
#    LinkN: interface name ('Link0' or 'Link1')
#    timeout: initial time of waiting [sec.]
#    frame(list): expecting packet names
# return:
#    (stop_time, %ret)
#    stop_time: if received expected packet, this is receiving time.
#               if not, this is timeout time.
#    ret(hash):
#	status    - status(0: catch expected packets
#			   1: time exceeded
#			   2: count exceeded
#			 > 3: error)
#	recvCount - number of received packets
#	recvTimeN - time of receiving packet #N 
#	recvFrame - name of received packet(expected)
#===============================================================
sub nr_vRecv_EN {
	my($IF, $timeout, @frames) = @_;
	my(%ret, @recv, $receive_time, $start_time, $delay_time);

	$start_time = time();
	$delay_time = $timeout;

	while (1) {
		vLogHTML("waiting $delay_time sec.<BR>");
		%ret = vRecv($IF, $delay_time, 0, 0, @frames, sort(keys(%{$nd{$IF}})));
		$receive_time = time();
		if ($ret{'status'} == 0) {
			@recv = grep {$ret{'recvFrame'} eq $_} @frames;
			if ($recv[0]) {
				last;
			}

			@recv = grep {$ret{'recvFrame'} eq $_} sort(keys(%{$nd{$IF}}));
			if ($recv[0]) {
				vSend($IF, ${$nd{$IF}}{$recv[0]});
				$delay_time = $start_time + $timeout - $receive_time;
				next;
			}
		} else {
			last;
		}
	}

	return ($receive_time - $start_time, %ret);
}

# temporarily add packet description " from/to LinkN"
sub desc_vSend {
	my($IF, $frame) = @_;
	my($tmpdesc, $ret);

	$tmpdesc = $pktdesc{$frame};
	$pktdesc{$frame} .= " to $IF";
	$ret = vSend($IF, $frame);
	$pktdesc{$frame} = $tmpdesc;

	return ($ret);
}

# $offset means: add "from LinkN" to description for $frames[$offset ..]
sub desc_vRecv {
	my($IF, $timeout, $seektime, $count, $offset, @frames) = @_;
	my(%ret, %tmpdesc, $key);

	%tmpdesc = ();
	foreach $key ((@frames)[$offset .. $#frames]) {
		$tmpdesc{$key} = $pktdesc{$key};
		$pktdesc{$key} .= " from $IF";
	}
	%ret = vRecv($IF, $timeout, $seektime, $count, @frames);
	foreach $key ((@frames)[$offset .. $#frames]) {
		$pktdesc{$key} = $tmpdesc{$key};
	}

	return (%ret);
}



@fragment_1st_name = ();   #fragment paket definition

#===============================================================
# writefragdef(file name,packet name, MTU size, packet size, 1st fragment default size,
# 2nd fragment default size, header_ether, ip_src, ip_dst)
#			- fragment paket definition(echo reply fragment)
#===============================================================
# return:
#    ($ret)
#    ret:
#	$Success or $Failure
#===============================================================
#----  fragment paket definition
sub writefragdef($$$$$$$$$){
	my ($def, $original_name, $MTU_value, $PKT_size,$data_size_1st,$data_size_2nd , $header_ether, $ip_src, $ip_dst) = @_;
	
	if(open(OUT, "> $def")) {

		@fragment_1st_name = ();
		while ( $data_size_1st  <= ($MTU_value - 40 ) && $data_size_2nd >= 0) {
			
			if ((($data_size_1st + 40 +8) <= $MTU_value) &&  ($data_size_2nd  <= ($MTU_value - 40 -8 ))){
			
				$offset = $data_size_1st/8;
				
				push( @fragment_1st_name ,"echo_reply$PKT_size" . "_1st_$data_size_1st");
				
				select(OUT);
				
				print "FEM_hdr_ipv6_exth(\n";
				print "    echo_reply$PKT_size" . "_1st_$data_size_1st,\n"; #change this
				print "    $header_ether ,\n"; #change this _HETHER_nut2tn
				print "    {\n";
				print "        _SRC( $ip_src );\n"; #change this
				print "        _DST( $ip_dst );\n"; #change this
				print "    },\n";
				print "    {\n";
				print "        header = _HDR_IPV6_NAME(echo_reply$PKT_size"."_1st_$data_size_1st);\n"; #change this
				print "        exthdr = frag"."$PKT_size"."_1st_$data_size_1st;\n"; #change this
				print "        upper = payload"."$PKT_size"."_1st_$data_size_1st;\n"; #change this
				print "    }\n";
				print ")\n";
				
				print "\n";
				
				print "FEM_hdr_ipv6_exth(\n";
				print "    echo_reply$PKT_size" . "_2nd_$data_size_2nd,\n"; #change this
				print "    $header_ether ,\n"; #change this _HETHER_nut2tn
				print "    {\n";
				print "        _SRC( $ip_src );\n";
				print "        _DST( $ip_dst );\n"; #change this
				print "    },\n";
				print "    {\n";
				print "         header = _HDR_IPV6_NAME(echo_reply$PKT_size"."_2nd_$data_size_2nd);\n"; #change this
				print "         exthdr = frag"."$PKT_size"."_2nd_$data_size_2nd;\n"; #change this
				print "         upper = payload"."$PKT_size"."_2nd_$data_size_2nd;\n"; #change this
				print "    }\n";
				print ")\n";
				
				print "\n";
				
				print "Hdr_Fragment frag"."$PKT_size"."_1st_$data_size_1st {\n"; #change this
				print "    NextHeader = 58;\n";
				print "    FragmentOffset = 0;\n";
				print "    MFlag = 1;\n";
				print "    Identification = FRAG_ID;\n";
				print "}\n";
				
				print "\n";
				
				print "Hdr_Fragment frag"."$PKT_size"."_2nd_$data_size_2nd {\n"; #change this
				print "    NextHeader = 58;\n";
				print "    FragmentOffset = $offset;" . "//$data_size_1st"."/8;\n";
				print "    MFlag = 0;\n";
				print "    Identification = FRAG_ID;\n";
				print "}\n";
				
				print "\n";
				
				print "Payload payload"."$PKT_size"."_1st_$data_size_1st {\n"; #chnage this
				print "    data = substr(_PACKET_IPV6_NAME("."$original_name"."), 40, "."$data_size_1st".");\n";
				print "}\n";
				
				print "\n";
				
				print "Payload payload"."$PKT_size"."_2nd_$data_size_2nd {\n"; #chnage this
				print "    data = substr(_PACKET_IPV6_NAME("."$original_name"."), ",$data_size_1st+40,", "."$data_size_2nd".");\n";
				print "}\n";
				
				
				
				select(STDOUT);
			}
			
			$data_size_1st += 8;
			$data_size_2nd -= 8;
		}
		close(OUT);
		return($Success);
	}
	vLogHTML('<FONT COLOR="#FF0000">Can\'t open file.</FONT><BR>');
	return($Failure);
}

1;


__END__
################################################################

=head1 NAME

  CommonSPEC.pm - Common Test Setup, Cleanup, and other procedures

=head1 SYNOPSIS

  nd_vRecv_EN(LinkN, timeout, seektime, count, frame...)
  nd_vRecv_IN(LinkN, timeout, seektime, count, frame...)
  nr_vRecv_EN(LinkN, delay, frame...)

=head1 DESCRIPTION

  nd_vRecv_EN(LinkN, timeout, seektime, count, frame...)
			- waiting for expecting packets for End Node
  nd_vRecv_IN(LinkN, timeout, seektime, count, frame...)
			- waiting for expecting packets for Intermediage Node

    argument:
       LinkN: interface name ('Link0' or 'Link1')
       timeout: time to stop waiting [sec.]
       seektime: time to start waiting [sec.]
       count: number of receiving packets
       frame(list): expecting packet names

    return:
       ret(hash):
           status    - status(0: catch expected packets
                              1: time exceeded
                              2: count exceeded
                            > 3: error)
           recvCount - number of received packets
           recvTimeN - time of receiving packet #N 
           recvFrame - name of received packet(expected)

    This is a wrapper for vRecv() which replies appropriate
    Neighbor Advertisement automatically when it receives
    any Neighbor Solicitation.
    Then it waits the specified packets again (no NS in this time).

  nr_vRecv_EN(LinkN, delay, frame...)
				- continual waiting for expecting packets

    argument:
       LinkN: interface name ('Link0' or 'Link1')
       timeout: initial time of waiting [sec.]
       frame(list): expecting packet names

    return:
       (stop_time, %ret)
       stop_time: if received expected packet, this is receiving time.
                  if not, this is timeout time.
       ret(hash):
           status    - status(0: catch expected packets
                              1: time exceeded
                              2: count exceeded
                            > 3: error)
           recvCount - number of received packets
           recvTimeN - time of receiving packet #N 
           recvFrame - name of received packet(expected)

    This is similar to nd_vRecv. As it received any NS, it replies NA
    automatically. However, after that, it resumes waiting until
    it receives the specified packets or timeout.
    (In this case, as for a timeout, only the part of the time which
    already passed becomes short.)

=head1 SEE ALSO

  perldoc V6evalTool

=cut
