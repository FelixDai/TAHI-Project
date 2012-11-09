define(e,(Hdr_Ether.SourceAddress=ether("$1") OR Hdr_Ether.DestinationAddress=ether("$1")))

define(ip,(Hdr_IPv6.SourceAddress=v6("$1") OR Hdr_IPv6.DestinationAddress=v6("$1")))

define(ip4,(Hdr_IPv4.SourceAddress=v4("$1") OR Hdr_IPv4.DestinationAddress=v4("$1")))

define(unspec,(Hdr_IPv6.SourceAddress=v6("::") OR Hdr_IPv6.DestinationAddress=v6("::")))

define(loopback,(Hdr_IPv6.SourceAddress=v6("::1") OR Hdr_IPv6.DestinationAddress=v6("::1")))

define(eall,(Hdr_Ether.Type=any))

define(v4all,(Hdr_IPv4.Version=4))

define(v6all,(Hdr_IPv6.Version=6))

define(hopopt,(Hdr_IPv6.NextHeader=0 OR Hdr_HopByHop.NextHeader=0 OR Hdr_Destination.NextHeader=0 OR Hdr_Routing.NextHeader=0 OR Hdr_Fragment.NextHeader=0))

define(icmp4,(Hdr_IPv6.NextHeader=1 OR Hdr_HopByHop.NextHeader=1 OR Hdr_Destination.NextHeader=1 OR Hdr_Routing.NextHeader=1 OR Hdr_Fragment.NextHeader=1))

define(igmp,(Hdr_IPv6.NextHeader=2 OR Hdr_HopByHop.NextHeader=2 OR Hdr_Destination.NextHeader=2 OR Hdr_Routing.NextHeader=2 OR Hdr_Fragment.NextHeader=2))

define(tcp,(Hdr_TCP.SourcePort=any))

define(udp,(Hdr_UDP.SourcePort=any))

define(frag,(Hdr_IPv6.NextHeader=44 OR Hdr_HopByHop.NextHeader=44 OR Hdr_Destination.NextHeader=44 OR Hdr_Routing.NextHeader=44 OR Hdr_Fragment.NextHeader=44))

define(esp,(Hdr_IPv6.NextHeader=50 OR Hdr_HopByHop.NextHeader=50 OR Hdr_Destination.NextHeader=50 OR Hdr_Routing.NextHeader=50 OR Hdr_Fragment.NextHeader=50))

define(ah,(Hdr_IPv6.NextHeader=51 OR Hdr_HopByHop.NextHeader=51 OR Hdr_Destination.NextHeader=51 OR Hdr_Routing.NextHeader=51 OR Hdr_Fragment.NextHeader=51))

define(icmp,(Hdr_IPv6.NextHeader=58 OR Hdr_HopByHop.NextHeader=58 OR Hdr_Destination.NextHeader=58 OR Hdr_Routing.NextHeader=58 OR Hdr_Fragment.NextHeader=58))

define(dstopt,(Hdr_IPv6.NextHeader=60 OR Hdr_HopByHop.NextHeader=60 OR Hdr_Destination.NextHeader=60 OR Hdr_Routing.NextHeader=60 OR Hdr_Fragment.NextHeader=60))

define(redirect,(ICMPv6_Redirect.Type=137))

define(unreach,(ICMPv6_DestinationUnreachable.Type=1))

define(toobig,(ICMPv6_PacketTooBig.Type=2))

define(parameter,(ICMPv6_ParameterProblem.Type=4))

define(ping,(ICMPv6_EchoRequest.Type=128 OR ICMPv6_EchoReply.Type=129))

define(mld,(ICMPv6_MLDReport.Type=130 OR ICMPv6_MLDReport.Type=131 OR ICMPv6_MLDDone.Type=132))

define(rs,(ICMPv6_RS.Type=133))

define(ra,(ICMPv6_RA.Type=134))

define(ns,(ICMPv6_NS.Type=135))

define(na,(ICMPv6_NA.Type=136))

define(rr,(ICMPv6_RouterRenumbering.Type=138))

define(jumbogram,(Opt_JumboPayload.OptionType=194))

define(unflag,(Hdr_TCP.URGFlag=0 AND Hdr_TCP.ACKFlag=0 AND Hdr_TCP.PSHFlag=0 AND Hdr_TCP.RSTFlag=0 AND Hdr_TCP.SYNFlag=0 AND Hdr_TCP.FINFlag=0))

define(ack,(Hdr_TCP.URGFlag=0 AND Hdr_TCP.ACKFlag=1 AND Hdr_TCP.PSHFlag=0 AND Hdr_TCP.RSTFlag=0 AND Hdr_TCP.SYNFlag=0 AND Hdr_TCP.FINFlag=0))

define(psh,(Hdr_TCP.URGFlag=0 AND Hdr_TCP.ACKFlag=0 AND Hdr_TCP.PSHFlag=1 AND Hdr_TCP.RSTFlag=0 AND Hdr_TCP.SYNFlag=0 AND Hdr_TCP.FINFlag=0))

define(ackpsh,(Hdr_TCP.URGFlag=0 AND Hdr_TCP.ACKFlag=1 AND Hdr_TCP.PSHFlag=1 AND Hdr_TCP.RSTFlag=0 AND Hdr_TCP.SYNFlag=0 AND Hdr_TCP.FINFlag=0))

define(unack,((Hdr_TCP.URGFlag=1 OR Hdr_TCP.PSHFlag=1 OR Hdr_TCP.RSTFlag=1 OR Hdr_TCP.SYNFlag=1 OR Hdr_TCP.FINFlag=1) OR (Hdr_IPv6.NextHeader!=6 OR Hdr_HopByHop.NextHeader!=6 OR Hdr_Destination.NextHeader!=6  OR Hdr_Routing.NextHeader!=6 OR Hdr_Fragment.NextHeader!=6)))

define(unackpsh,((Hdr_TCP.URGFlag=0 AND Hdr_TCP.ACKFlag=1 AND Hdr_TCP.PSHFlag=0 AND Hdr_TCP.RSTFlag=0 AND Hdr_TCP.SYNFlag=0 AND Hdr_TCP.FINFlag=0) OR (Hdr_TCP.URGFlag=0 AND Hdr_TCP.ACKFlag=0 AND Hdr_TCP.PSHFlag=1 AND Hdr_TCP.RSTFlag=0 AND Hdr_TCP.SYNFlag=0 AND Hdr_TCP.FINFlag=0) OR (Hdr_TCP.URGFlag=1 OR Hdr_TCP.RSTFlag=1 OR Hdr_TCP.SYNFlag=1 OR Hdr_TCP.FINFlag=1) OR (Hdr_IPv6.NextHeader!=6 OR Hdr_HopByHop.NextHeader!=6 OR Hdr_Destination.NextHeader!=6  OR Hdr_Routing.NextHeader!=6 OR Hdr_Fragment.NextHeader!=6)))

define(unaap,((Hdr_TCP.URGFlag=0 AND Hdr_TCP.ACKFlag=0 AND Hdr_TCP.PSHFlag=1 AND Hdr_TCP.RSTFlag=0 AND Hdr_TCP.SYNFlag=0 AND Hdr_TCP.FINFlag=0) OR (Hdr_TCP.URGFlag=1 OR Hdr_TCP.RSTFlag=1 OR Hdr_TCP.SYNFlag=1 OR Hdr_TCP.FINFlag=1) OR (Hdr_IPv6.NextHeader!=6 OR Hdr_HopByHop.NextHeader!=6 OR Hdr_Destination.NextHeader!=6  OR Hdr_Routing.NextHeader!=6 OR Hdr_Fragment.NextHeader!=6) OR (Hdr_IPv4.Protocol!=41 AND Hdr_IPv4.Protocol!=6)))

define(ripng,(Hdr_UDP.SourcePort=521 AND Hdr_UDP.DestinationPort=521))

define(ripngm,((Hdr_UDP.SourcePort=521 AND Hdr_UDP.DestinationPort=521) AND Hdr_IPv6.DestinationAddress=v6("ff02::9")))

define(ripngu,((Hdr_UDP.SourcePort=521 AND Hdr_UDP.DestinationPort=521) AND Hdr_IPv6.DestinationAddress!=v6("ff02::9")))

define(solicite,(Hdr_IPv6.SourceAddress=v6("ff02::1:ff00:0", 104) OR Hdr_IPv6.DestinationAddress=v6("ff02::1:ff00:0", 104)))

define(multicast,(Hdr_IPv6.SourceAddress=v6("ff00::", 8) OR Hdr_IPv6.DestinationAddress=v6("ff00::", 8)))

define(linklocal,(Hdr_IPv6.SourceAddress=v6("feb0::", 10) OR Hdr_IPv6.DestinationAddress=v6("feb0::", 10)))

define(sitelocal,(Hdr_IPv6.SourceAddress=v6("fef0::", 10) OR Hdr_IPv6.DestinationAddress=v6("fef0::", 10)))

define(global,(Hdr_IPv6.SourceAddress=v6("3000::", 3) OR Hdr_IPv6.DestinationAddress=v6("3000::", 3)))
