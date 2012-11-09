####################################################################
# Ether Header                          e~

Hdr_Ether.SourceAddress                 esrc
Hdr_Ether.DestinationAddress            edst
Hdr_Ether.Type                          etype


####################################################################
# IPv6 Header                           ip~

Hdr_IPv6.SourceAddress                  ipsrc
Hdr_IPv6.DestinationAddress             ipdst
Hdr_IPv6.PayloadLength                  ippaylen
Hdr_IPv6.NextHeader                     ipnext
Hdr_IPv6.HopLimit                       iphop


####################################################################
# Extension Headers

### HopByHop Header                     hbh~

Hdr_HopByHop.NextHeader                 hbhnext


### Destination Header                  dh~

Hdr_Destination.NextHeader              dhnext


### Routing Header                      rh~

Hdr_Routing.NextHeader                  rhnext
Hdr_Routing.RoutingType                 rhtype
#Hdr_Routing.SegmentLeft                        rhseg


### Fragment Header                     fh~

Hdr_Fragment.NextHeader                 fhnext
Hdr_Fragment.FragmentOffset             fhoff
Hdr_Fragment.MFlag                      fhmf
Hdr_Fragment.Identification             fhid


#####################################################################
# Extension Header Options

### Pad1 Option                         pad1~

Opt_Pad1.OptionType                     pad1type


### PadN Option                         padn~

Opt_PadN.OptionType                     padntype
Opt_PadN.OptDataLength                  padnlen


### JumboPayload Option                 jumbo~

Opt_JumboPayload.OptionType             jumbotype
Opt_JumboPayload.OptDataLength          jumbolen
Opt_JumboPayload.JumboPayloadLength     jumbopaylen


### RouterAlert Option                  rlt~

Opt_RouterAlert.OptionType              rlttype
Opt_RouterAlert.OptDataLength           rltlen



#####################################################################
# ICMPv6


### ICMPv6 RS                           rs~

ICMPv6_RS.Type                          rstype
ICMPv6_RS.Code                          rscode


### ICMPv6 RA                           ra~

ICMPv6_RA.Type                          ratype
ICMPv6_RA.Code                          racode
ICMPv6_RA.MFlag                         ramf
ICMPv6_RA.OFlag                         raof
#ICMPv6_RA.LifeTime                     ralife
#ICMPv6_RA.ReachableTime                rareachable
#ICMPv6_RA.Retranstimer                 raretrans


### ICMPv6 NS                           ns~

ICMPv6_NS.Type                          nstype
ICMPv6_NS.Code                          nscode
ICMPv6_NS.TargetAddress                 nstarget


### ICMPv6 NA                           na~

ICMPv6_NA.Type                          natype
ICMPv6_NA.Code                          nacode
ICMPv6_NA.RFlag                         narf
ICMPv6_NA.SFlag                         nasf
ICMPv6_NA.OFlag                         naof
ICMPv6_NA.TargetAddress                 natarget


### ICMPv6 Redirect                     red~

ICMPv6_Redirect.Type                    redtype
ICMPv6_Redirect.Code                    redcode
ICMPv6_Redirect.TargetAddress           redtarget
ICMPv6_Redirect.DestinationAddress      reddst


### ICMPv6 EchoRequest                  ereq~

ICMPv6_EchoRequest.Type                 ereqtype
ICMPv6_EchoRequest.Code                 ereqcode
ICMPv6_EchoRequest.Identifier           ereqid
ICMPv6_EchoRequest.SequenceNumber       ereqseq


### ICMPv6 EchoReply                    erep~

ICMPv6_EchoReply.Type                 ereptype
ICMPv6_EchoReply.Code                 erepcode
ICMPv6_EchoReply.Identifier           erepid
ICMPv6_EchoReply.SequenceNumber       erepseq


### ICMPv6 Packet Too Big               ptb~

ICMPv6_PacketTooBig.Type                ptbtype
ICMPv6_PacketTooBig.Code                ptbcode
ICMPv6_PacketTooBig.MTU                 ptbmtu


### ICMPv6 Destination Unreachable      dstun~

ICMPv6_DestinationUnreachable.Type      dstuntype
ICMPv6_DestinationUnreachable.Code      dstuncode


### ICMPv6 ParameterProblem             pp~

ICMPv6_ParameterProblem.Type            pptype
ICMPv6_ParameterProblem.Code            ppcode


#####################################################################
# TCP                                   tcp~

TCP.SourcePort                          tcpsrc
TCP.DestinationPort                     tcpdst


#####################################################################
# UDP                                   udp~

UDP.SourcePort                          udpsrc
UDP.DestinationPort                     udpdst
