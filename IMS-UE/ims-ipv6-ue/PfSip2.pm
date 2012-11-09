#!/usr/bin/perl 
# Copyright (C) NTT Advanced Technology 2007

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

# 
# 09/3/13 SIP
#         
# 09/2/26 SDP
# 08/9/29 SIP:SIPuri <xxx:port;xx=yy> 
# 08/3/ 5 SIP:Status
# 08/2/28 SIP:Unknown 
#         SL
# 08/2/28 SIP:Referred-By,SIP:Warning 
#         SIP:Referred-By
# 08/2/28 sip: sips: 
# 08/2/25 SDP
#         SDPOrderChk
# 08/2/25 UriParameters
#         MT
# 08/2/18 SDP 
#         t= 
#         
# 08/2/18 repeat-fields 
# 08/2/18 != 
#         SIP:Sent-By,SIP:SIPUri,SIP:SIPSUri
# 08/2/18 hostport
#         SIP:ViaTtl... SIP:TransportParam...  '^;?' => '^(?:$PtSEMI)?'
#         SIP:Sent-By SIP:SIPUri, SIP:SIPSUri  ':'   => '$PtCOLON'
# 08/1/18 
#   SIP:RefresherParam
# 08/1/18 Via
#   SIP:ViaParm
# 07/12/27 SL 
#   SIP:ContactParam,SIP:v=,SIP:r=,SIP:TimeUnit 
#   SIP:Duration,SIP:MediaDescriptions,SIP:ViaTtl,SIP:ViaMaddr,SIP:ViaReceived,SIP:ViaBranch,SIP:ViaExtension 
# 07/12/27 
#   Event,Subscription-State,Allow-Events
# 07/12/25 XML UNSDP 
# 07/11/22 SL
#   ContactParams 
#   Via 
# 07/11/14
#   Contact q= 0.000
# 07/10/30 Event,Allow-Events,Subscription-State 
# 07/10/ 5 
#   Reason 
# 07/08/21 
#   MT 
#   SIPuri
#   

#
# 
#   
#   
#
# use strict;

# BNF
#  1) 
#  2) 
#
# MT:
# MM:MT
# SL:

#============================================
# 
#============================================
@SIPPacketHexMap = (

#======================
# SIP
#======================
 {'##'=>'SIP',         # 
  '#Name#'=>'SIP',     # 
  '#CONTEXT#'=>'TXT',  # 
  '#TX#'=>{            # 
      'SL'=>"($PtSIPMessage)", # 
      'MT'=>$PtSIPMessage,
      'MM'=>'^((?:.|[\r\n])+)$',
      'LOG'=>{'AC'=>\q{$V =~ s/\r\n/\r\n     /g;$V}},
  },
  'field'=>            # 
      [
       # 
       {'NM'=>'SL',    # 
	'#CHOICE#'=>  # 
	[   
	    {'ST'=>'SIP:Status'},  # 
	    {'ST'=>'SIP:Request'},  
	],
       },
       # 
       {'NM'=>'HD',    # 
	'DE'=>{'SL'=>"(^(?:(?:.+)$PtCRLF)+)"}, # 
	'#ARRAY#'=>                 # 
	    [{'DE'=>{'SL'=>"(^(?:(?:.+)$PtCRLF(?:(?:$PtWSP)+(?:.+)$PtCRLF)*))"}, # 
	      '#CHOICE#'=>      # 
	      [
	       {'ST'=>'SIP:Accept'},
	       {'ST'=>'SIP:Accept-Encoding'},
	       {'ST'=>'SIP:Accept-Language'},
	       {'ST'=>'SIP:Alert-Info'},
	       {'ST'=>'SIP:Allow'},
	       {'ST'=>'SIP:Authentication-Info'},
	       {'ST'=>'SIP:Authorization'},
	       {'ST'=>'SIP:Call-ID'},
	       {'ST'=>'SIP:Call-Info'},
	       {'ST'=>'SIP:Contact'},
	       {'ST'=>'SIP:Content-Disposition'},
	       {'ST'=>'SIP:Content-Encoding'},
	       {'ST'=>'SIP:Content-Language'},
	       {'ST'=>'SIP:Content-Length'},
	       {'ST'=>'SIP:Content-Type'},
	       {'ST'=>'SIP:CSeq'},
	       {'ST'=>'SIP:Date'},
	       {'ST'=>'SIP:Error-Info'},
	       {'ST'=>'SIP:Expires'},
	       {'ST'=>'SIP:From'},
	       {'ST'=>'SIP:History-Info'},
	       {'ST'=>'SIP:In-Reply-To'},
	       {'ST'=>'SIP:Max-Forwards'},
	       {'ST'=>'SIP:MIME-Version'},
	       {'ST'=>'SIP:Min-SE'},
	       {'ST'=>'SIP:Min-Expires'},
	       {'ST'=>'SIP:Organization'},
	       {'ST'=>'SIP:Path'},
	       {'ST'=>'SIP:Reason'},
	       {'ST'=>'SIP:Priority'},
	       {'ST'=>'SIP:Proxy-Authenticate'},
	       {'ST'=>'SIP:Proxy-Authorization'},
	       {'ST'=>'SIP:Proxy-Require'},

	       {'ST'=>'SIP:P-Associated-URI'},
	       {'ST'=>'SIP:P-Called-Party-ID'},
	       {'ST'=>'SIP:P-Visited-Network-ID'},
	       {'ST'=>'SIP:P-Access-Network-Info'},
	       {'ST'=>'SIP:P-Charging-Addr'},
	       {'ST'=>'SIP:P-Charging-Vector'},

	       {'ST'=>'SIP:Record-Route'},
	       {'ST'=>'SIP:Remote-Party-ID'},
	       {'ST'=>'SIP:Reply-To'},
	       {'ST'=>'SIP:Require'},
	       {'ST'=>'SIP:Retry-After'},
	       {'ST'=>'SIP:Route'},
	       {'ST'=>'SIP:Security-Client'},
	       {'ST'=>'SIP:Security-Server'},
	       {'ST'=>'SIP:Security-Verify'},
	       {'ST'=>'SIP:Server'},
	       {'ST'=>'SIP:Service-Route'},
	       {'ST'=>'SIP:Session-Expires'},
	       {'ST'=>'SIP:Subject'},
	       {'ST'=>'SIP:Supported'},
	       {'ST'=>'SIP:Timestamp'},
	       {'ST'=>'SIP:To'},
	       {'ST'=>'SIP:Unsupported'},
	       {'ST'=>'SIP:User-Agent'},
	       {'ST'=>'SIP:Via'},
	       {'ST'=>'SIP:Warning'},
	       {'ST'=>'SIP:WWW-Authenticate'},
	       {'ST'=>'SIP:Anonymity'},
	       {'ST'=>'SIP:Referred-By'},
	       {'ST'=>'SIP:Privacy'},
	       {'ST'=>'SIP:P-Asserted-Identity'},
	       {'ST'=>'SIP:P-Preferred-Identity'},
	       {'ST'=>'SIP:RAck'},
	       {'ST'=>'SIP:RSeq'},
	       {'ST'=>'SIP:Event'},
	       {'ST'=>'SIP:Subscription-State'},
	       {'ST'=>'SIP:Allow-Events'},
	       {'ST'=>'SIP:Unknown'},
	       ]}]},
       # 
       {'NM'=>'CR',
	'DE'=>{'TY'=>'match','MT'=>"^($PtCRLF)"},
	'EN'=>{'TY'=>'str'},'IV'=>"\r\n"},
       # 
       {'NM'=>'BD', 
	'EN'=>{'AC'=>\q{$V."\r\n"}},
	'DE'=>{'AC2'=>\&SDPOrderChk},
        '#ARRAY#'=>                                          # 
        [{'DE'=>{'TY'=>'match'}, # 
	      '#CHOICE#'=>                                       # 
	      [
	       {'ST'=>'SIP:v='},
	       {'ST'=>'SIP:o='},
	       {'ST'=>'SIP:s='},
	       {'ST'=>'SIP:i='},
	       {'ST'=>'SIP:u='},
	       {'ST'=>'SIP:e='},
	       {'ST'=>'SIP:p='},
	       {'ST'=>'SIP:c='},
	       {'ST'=>'SIP:b='},
	       {'ST'=>'SIP:t='},
	       {'ST'=>'SIP:k='},
	       {'ST'=>'SIP:a='},
	       {'ST'=>'SIP:m='},
	       {'ST'=>'XML', 'MT'=>sub{my $subtype=CtFlGet('HD,#Content-Type,subtype',@_[2]->{decode});return $subtype=~/xml/i}},
	       {'ST'=>'UNSDP','MT'=>sub{my $subtype=CtFlGet('HD,#Content-Type,subtype',@_[2]->{decode});return $subtype && !($subtype=~/sdp/i)}},
	       {'ST'=>'SIP:r='},  # 
	       {'ST'=>'SIP:z='},  # 
	       {'ST'=>'SIP:?='},  # 
	       ]}]},
       ]
   },

#======================
# 
#======================
# Request-Line   = Method SP Request-URI SP SIP-Version CRLF
# $PtRequestLine = qq{$PtMethod\\s$PtRequestURI\\s$PtSIPVersion};
 {
  '##'=>'SIP:Request',
  '#Name#'=>'RQ', 
  '#TX#'=>{
      'SL'=>"(^(?:.+)$PtCRLF)",
      'MT'=>"^$PtRequestLine",
      'MM'=>"^$PtMethod(?:.*)$PtCRLF",
  },
  'field'=>
     [

      {'NM'=>'method',
       'DE'=>{'TY'=>'match',          # 
	          'MT'=>"($PtMethod)\\s"}, # 
       'EN'=>{'TY'=>'str+sp'}},       # 

      {'NM'=>'uri', # 
       'DE'=>{'TY'=>'match','MT'=>"$PtRequestURI(?= )",'SL'=>"(^$PtRequestURI(?= ))"}, # 
       'EN'=>{'TY'=>'str','AC'=>\q{$V.' '}},
       '#CHOICE#'=>                 # 
         [{'ST'=>'SIP:SIPUri'},
          {'ST'=>'SIP:SIPSUri'},
          {'ST'=>'SIP:AbsoluteUri'},],
      },

      {'NM'=>'sip-version',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtSIPVersion)"},
       'EN'=>{'TY'=>'str'}},

     ]
  },

 {'##'=>'SIP:Status',
  '#Name#'=>'ST', 
  '#TX#'=>{
      'SL'=>"(^(?:.+)$PtCRLF)",
      'MT'=>"^$PtStatusLine",
      'MM'=>"^SIP(?:.*)$PtCRLF",
  },
  'field'=>
     [

      {'NM'=>'sip-version',
       'DE'=>{'TY'=>'match','MT'=>"($PtSIPVersion)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'code',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtDigit){1,3})"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'reason',
       'DE'=>{'TY'=>'match','MT'=>"(?:$PtSP|$PtHTAB)*($PtReasonPhrase)"},
       'EN'=>{'TY'=>'str'}},

     ]
  },


#======================
# 
#======================
 {'##'=>'SIP:Header',
  '#Name#'=>'HD', 
  '#TX#'=>{
      'SL'=>"(^(?:(?:.+)$PtCRLF)+)",
  },
  'field'=>
     [
      {'NM'=>'headers',
       '#ARRAY#'=>                   # 
        [{'#CHOICE#'=>                 # 
	  [
	   {'ST'=>'SIP:Accept'},
	   {'ST'=>'SIP:Accept-Encoding'},
	   {'ST'=>'SIP:Accept-Language'},
	   {'ST'=>'SIP:Alert-Info'},
	   {'ST'=>'SIP:Allow'},
	   {'ST'=>'SIP:Authentication-Info'},
	   {'ST'=>'SIP:Authorization'},
	   {'ST'=>'SIP:Call-ID'},
	   {'ST'=>'SIP:Call-Info'},
	   {'ST'=>'SIP:Contact'},
	   {'ST'=>'SIP:Content-Disposition'},
	   {'ST'=>'SIP:Content-Encoding'},
	   {'ST'=>'SIP:Content-Language'},
	   {'ST'=>'SIP:Content-Length'},
	   {'ST'=>'SIP:Content-Type'},
	   {'ST'=>'SIP:CSeq'},
	   {'ST'=>'SIP:Date'},
	   {'ST'=>'SIP:Error-Info'},
	   {'ST'=>'SIP:Expires'},
	   {'ST'=>'SIP:From'},
	   {'ST'=>'SIP:History-Info'},
	   {'ST'=>'SIP:In-Reply-To'},
	   {'ST'=>'SIP:Max-Forwards'},
	   {'ST'=>'SIP:MIME-Version'},
	   {'ST'=>'SIP:Min-SE'},
	   {'ST'=>'SIP:Min-Expires'},
	   {'ST'=>'SIP:Organization'},
	   {'ST'=>'SIP:Path'},
	   {'ST'=>'SIP:Reason'},
	   {'ST'=>'SIP:Priority'},
	   {'ST'=>'SIP:Proxy-Authenticate'},
	   {'ST'=>'SIP:Proxy-Authorization'},
	   {'ST'=>'SIP:Proxy-Require'},
	   {'ST'=>'SIP:P-Associated-URI'},
	   {'ST'=>'SIP:P-Called-Party-ID'},
	   {'ST'=>'SIP:P-Visited-Network-ID'},
	   {'ST'=>'SIP:P-Access-Network-Info'},
	   {'ST'=>'SIP:P-Charging-Addr'},
	   {'ST'=>'SIP:P-Charging-Vector'},
	   {'ST'=>'SIP:Record-Route'},
	   {'ST'=>'SIP:Remote-Party-ID'},
	   {'ST'=>'SIP:Reply-To'},
	   {'ST'=>'SIP:Require'},
	   {'ST'=>'SIP:Retry-After'},
	   {'ST'=>'SIP:Route'},
	   {'ST'=>'SIP:Security-Client'},
	   {'ST'=>'SIP:Security-Server'},
	   {'ST'=>'SIP:Security-Verify'},
	   {'ST'=>'SIP:Server'},
	   {'ST'=>'SIP:Service-Route'},
	   {'ST'=>'SIP:Session-Expires'},
	   {'ST'=>'SIP:Subject'},
	   {'ST'=>'SIP:Supported'},
	   {'ST'=>'SIP:Timestamp'},
	   {'ST'=>'SIP:To'},
	   {'ST'=>'SIP:Unsupported'},
	   {'ST'=>'SIP:User-Agent'},
	   {'ST'=>'SIP:Via'},
	   {'ST'=>'SIP:Warning'},
	   {'ST'=>'SIP:WWW-Authenticate'},
	   {'ST'=>'SIP:Anonymity'},
	   {'ST'=>'SIP:Referred-By'},
	   {'ST'=>'SIP:Privacy'},
	   {'ST'=>'SIP:P-Asserted-Identity'},
	   {'ST'=>'SIP:P-Preferred-Identity'},
	   {'ST'=>'SIP:RAck'},
	   {'ST'=>'SIP:RSeq'},
	   {'ST'=>'SIP:Event'},
	   {'ST'=>'SIP:Subscription-State'},
	   {'ST'=>'SIP:Allow-Events'},
           ]
         }
        ],
      },
     ]
  },

# Accept    = "Accept" HCOLON [accept-range *(COMMA accept-range)]
# $PtAccept = qq{(?i:Accept)$PtHCOLON(?:$PtAcceptRange(?:$PtCOMMA$PtAcceptRange)*)?};
 {'##'=>'SIP:Accept','#Name#'=>'Accept',
  '#TX#'=>{'MT'=>"^$PtAccept(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:accept:)(?:.*)$PtCRLF",'SL'=>"(^$PtAccept(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Accept)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'range',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtAcceptRange(?:$PtCOMMA$PtAcceptRange)*)"},
       'EN'=>{'TY'=>'str'}},

     ]
},

# Accept-Encoding   = "Accept-encoding" HCOLON [ encoding *(COMMA encoding) ]
# $PtAcceptEncoding = qq{(?i:Accept-encoding)$PtHCOLON(?:$PtEncoding(?:$PtCOMMA$PtEncoding)*)?};
 {'##'=>'SIP:Accept-Encoding','#Name#'=>'Accept-Encoding', 
  '#TX#'=>{'MT'=>"^$PtAcceptEncoding(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:accept-encoding:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtAcceptEncoding(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Accept-encoding)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'encoding',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtEncoding(?:$PtCOMMA$PtEncoding)*)"},
       'EN'=>{'TY'=>'str'}},

     ]
},

# Accept-Language   = "Accept-Language" HCOLON [ language *(COMMA language) ]
# $PtAcceptLanguage = qq{(?i:Accept-Language)$PtHCOLON(?:$PtLanguage(?:$PtCOMMA$PtLanguage)*)?};
 {'##'=>'SIP:Accept-Language','#Name#'=>'Accept-Language',
  '#TX#'=>{'MT'=>"^$PtAcceptLanguage(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:accept-language:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtAcceptLanguage(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Accept-Language)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'language',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtLanguage(?:$PtCOMMA$PtLanguage)*)"},
       'EN'=>{'TY'=>'str'}},

     ]
},

# Alert-Info   = "Alert-Info" HCOLON alert-param *(COMMA alert-param)
# $PtAlertInfo = qq{(?i:Alert-Info)$PtHCOLON$PtAlertParam(?:$PtCOMMA$PtAlertParam)*};
 {'##'=>'SIP:Alert-Info','#Name#'=>'Alert-Info',
  '#TX#'=>{'MT'=>"^$PtAlertInfo(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:alert-info:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtAlertInfo(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Alert-Info)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'alerts',
       'DE'=>{'SL'=>"($PtAlertParam(?:$PtCOMMA$PtAlertParam)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
       '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtAlertParam)"},
            '#CHOICE#'=>[{'ST'=>'SIP:AlertParam'}]}
       ],
      },

     ]
},

# alert-param   = LAQUOT absoluteURI RAQUOT *( SEMI generic-param )
# $PtAlertParam = qq{$PtLAQUOT$PtAbsoluteUri$PtRAQUOT(?:$PtSEMI$PtGenericParam)*};
 {'##'=>'SIP:AlertParam','#Name#'=>'AlertParam',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtAlertParam",'SL'=>"(^(?:$PtCOMMA)?$PtAlertParam)"},
  'field'=>
     [

      {'NM'=>'uri',
       'DE'=>{'TY'=>'match',
              'MT'=>"$PtLAQUOT($PtAbsoluteUri)$PtRAQUOT",'SL'=>"((?:$PtAbsoluteUri))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{",<".$V.">"} }},

      {'NM'=>'param',
       'DE'=>{'SL'=>"($PtGenericParam)"},
         '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}], },

     ]
},

# Allow    = "Allow" HCOLON [Method *(COMMA Method)]
# $PtAllow = qq{(?i:Allow)$PtHCOLON(?:$PtMethod(?:$PtCOMMA$PtMethod)*)?};
 {'##'=>'SIP:Allow','#Name#'=>'Allow',
  '#TX#'=>{'MT'=>"^$PtAllow(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:allow:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtAllow(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Allow)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'methods',
       'DE'=>{'SL'=>"($PtMethod(?:$PtCOMMA$PtMethod)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#CHOICE#'=>[{'ST'=>'SIP:Methods'}], },

     ]
},

#
#
 {'##'=>'SIP:Methods','#Name#'=>'Methods',
  '#TX#'=>{'MT'=>"($PtMethod(?:$PtCOMMA$PtMethod)*)"},
  'field'=>
     [

      {'NM'=>'list',
        '#ARRAY#'=>[{'DE'=>{'SL'=>"((?:$PtCOMMA)?$PtMethod)"},
        '#CHOICE#'=>[
          {'ST'=>'SIP:Method'}], }], },

     ],
 },

# Authentication-Info   = "Authentication-Info" HCOLON ainfo *(COMMA ainfo)
# $PtAuthenticationInfo = qq{(?i:Authentication-Info)$PtHCOLON$PtAinfo(?:$PtCOMMA$PtAinfo)*};
 {'##'=>'SIP:Authentication-Info','#Name#'=>'Authentication-Info',
  '#TX#'=>{'MT'=>"^$PtAuthenticationInfo(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Authentication-Info:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtAuthenticationInfo(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Authentication-Info)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'ainfo',
       'DE'=>{'SL'=>"($PtAinfo(?:$PtCOMMA$PtAinfo)*)"},
         '#ARRAY#'=>[
           {'DE'=>{'SL'=>"(($PtAinfo))"},
             '#CHOICE#'=>[
              {'ST'=>'SIP:NextNonce'},
              {'ST'=>'SIP:MessageQop'},
              {'ST'=>'SIP:ResponseAuth'},
              {'ST'=>'SIP:Cnonce'},
              {'ST'=>'SIP:NonceCount'}], }],
      },

     ]
},


# Authorization    = "Authorization" HCOLON credentials
# $PtAuthorization = qq{(?i:Authorization)$PtHCOLON$PtCredentials};
 {'##'=>'SIP:Authorization','#Name#'=>'Authorization', 
  '#TX#'=>{'MT'=>"^$PtAuthorization(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Authorization:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtAuthorization(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Authorization)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'credentials',
       'DE'=>{'SL'=>"($PtCredentials)"},
         '#CHOICE#'=>[{'ST'=>'SIP:Credentials'}], },

     ],
},

# credentials    = ("Digest" LWS digest-response) / other-response
# $PtCredentials = qq{(?:(?i:Digest)$PtLWS$PtDigestResponse|$PtOtherResponse)};
 {'##'=>'SIP:Credentials','#Name#'=>'Credentials',
  '#TX#'=>{'MT'=>$PtCredentials},
  'field'=>
     [

      {'NM'=>'credential',
       'DE'=>{'SL'=>"($PtCredentials)"},
         '#CHOICE#'=>[
           {'ST'=>'SIP:DigestResponse'},
           {'ST'=>'SIP:OtherResponse'}], },

     ],
 },

# digest-response   = dig-resp *(COMMA dig-resp)
# $PtDigestResponse = qq{$PtDigResp(?:$PtCOMMA$PtDigResp)*};
 {'##'=>'SIP:DigestResponse','#Name#'=>'DigestResponse',
  '#TX#'=>{'MT'=>"(?i:Digest)$PtLWS$PtDigestResponse"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Digest))"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'digestresp',
       'DE'=>{'SL'=>"($PtDigestResponse)"}, 
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)} },
         '#CHOICE#'=>[{'ST'=>'SIP:DigestResponses'}], },

     ],
 },

 {'##'=>'SIP:DigestResponses','#Name#'=>'DigestResponses',
  '#TX#'=>{'MT'=>$PtDigestResponse},
  'field'=>
     [

      {'NM'=>'list',
          '#ARRAY#'=>[{'DE'=>{'SL'=>"((?:$PtCOMMA)?$PtDigResp)"},
          '#CHOICE#'=>[
              {'ST'=>'SIP:UserName'},
              {'ST'=>'SIP:Realm'},
              {'ST'=>'SIP:Nonce'},
              {'ST'=>'SIP:DigestUri'},
              {'ST'=>'SIP:Dresponse'},
              {'ST'=>'SIP:Algorithm'},
              {'ST'=>'SIP:Cnonce'},
              {'ST'=>'SIP:Opaque'},
              {'ST'=>'SIP:MessageQop'},
              {'ST'=>'SIP:NonceCount'},
              {'ST'=>'SIP:AuthParam'}], }], },

     ],
 },

# other-response   = auth-scheme LWS auth-param *(COMMA auth-param)
# $PtOtherResponse = qq{$PtAuthScheme$PtLWS$PtAuthParam(?:$PtCOMMA$PtAuthParam)*};
 {'##'=>'SIP:OtherResponse','#Name#'=>'OtherResponse',
  '#TX#'=>{'MT'=>$PtOtherResponse},
  'field'=>
     [

      {'NM'=>'scheme',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtAuthScheme)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'params',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtAuthParam(?:$PtCOMMA$PtAuthParam)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Call-ID    = "Call-ID" HCOLON callid
# $PtCall-ID = qq{(?i:Call-ID|i)$PtHCOLON$PtCallid};
 {'##'=>'SIP:Call-ID','#Name#'=>'Call-ID',
  '#TX#'=>{'MT'=>"^$PtCallID(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Call-ID:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtCallID(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Call-ID|i)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'call-id',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtCallid)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

## Call-Info    = "Call-Info" HCOLON info *(COMMA info)
## $PtCall-Info = qq{(?i:Call-Info)$PtHCOLON$PtInfo(?:$PtCOMMA$PtInfo)*};
 {'##'=>'SIP:Call-Info','#Name#'=>'Call-Info',
  '#TX#'=>{'MT'=>"^$PtCallInfo(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Call-Info:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtCallInfo(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Call-Info)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'call-info',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtInfo(?:$PtCOMMA$PtInfo)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Contact    = ("Contact" / "m" ) HCOLON ( STAR / (contact-param *(COMMA contact-param)))
# $PtContact = qq{(?i:Contact|m)$PtHCOLON(?:$PtSTAR|(?:$PtContactParam(?:$PtCOMMA$PtContactParam)*))};
 {'##'=>'SIP:Contact','#Name#'=>'Contact',
  '#TX#'=>{'MT'=>"^$PtContact(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Contact:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtContact(?:$PtCRLF)?\$)",'AC'=>'oneline'},
  'field'=>
     [
      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Contact|m)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'c-params',
       'DE'=>{'SL'=>"((?:$PtSTAR)|(?:$PtContactParam(?:$PtCOMMA$PtContactParam)*))"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}}, 
         '#ARRAY#'=>[{
           '#CHOICE#'=>[
             {'ST'=>'SIP:STAR'},
             {'ST'=>'SIP:ContactParam'}
         ]}],
      },

     ],
 },

# STAR    =  SWS "*" SWS ; 
# $PtSTAR = qq{(?:$PtSWS\\\*$PtSWS)};
 {'##'=>'SIP:STAR','#Name#'=>'STAR', '#TX#'=>{'MT'=>"^$PtSTAR"},
  'field'=>
     [

      {'NM'=>'star',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtSTAR))"},
       'EN'=>{'TY'=>'comma+str'}},

     ],
 },

# contact-param   =  (name-addr / addr-spec) *(SEMI contact-params)
# $PtContactParam   = qq{(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtContactParams)*};
 {'##'=>'SIP:ContactParam','#Name#'=>'ContactParam',
  '#TX#'=>{'MT'=>"^(?:(?:$PtCOMMA)?(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtContactParams)*)",
           'SL'=>"^((?:(?:$PtCOMMA)?(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtContactParams)*))"},

  'field'=>
     [

      {'NM'=>'addr',
       'DE'=>{'SL'=>"((?:$PtNameAddr|$PtAddrSpec))"},
       'EN'=>{'TY'=>'str','AC'=>\q{','.$V}},
         '#CHOICE#'=>[
           {'ST'=>'SIP:NameAddr'},
           {'ST'=>'SIP:AddrSpec'}]},

      {'NM'=>'h-params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtContactParams)*)"},
        '#CHOICE#'=>[{'ST'=>'SIP:ContactParams'}], },

     ],
 },

 {'##'=>'SIP:ContactParams','#Name#'=>'ContactParams',
  '#TX#'=>{'MT'=>"(?:$PtSEMI$PtContactParams)*\$",'SL'=>"((?:$PtSEMI$PtContactParams)*\$)"},
  'field'=>
     [

      {'NM'=>'list',
        '#ARRAY#'=>[{'DE'=>{'SL'=>"($PtContactParams)"},
        '#CHOICE#'=>[
          {'ST'=>'SIP:CPQ'},
          {'ST'=>'SIP:CPExpires'},
          {'ST'=>'SIP:GenericParam'}], }], },


     ],
 },

# c-p-q  = "q" EQUAL qvalue
# $PtCPQ = qq{(?i:q)$PtEQUAL$PtQvalue};
 {'##'=>'SIP:CPQ','#Name#'=>'CPQ',
  '#TX#'=>{'MT'=>"^$PtCPQ\$",'SL'=>"(^$PtCPQ\$)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:q))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'q',
       'DE'=>{'TY'=>'match','MT'=>"($PtQvalue)"},
              'IV'=>('0.0'),
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# c-p-expires  = "expires" EQUAL delta-seconds
# $PtCPExpires = qq{(?i:expires)$PtEQUAL$PtDeltaSeconds};
 {'##'=>'SIP:CPExpires','#Name#'=>'CPExpires',
  '#TX#'=>{'MT'=>"^$PtCPExpires",'SL'=>"(^$PtCPExpires)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:expires))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'expires',
       'DE'=>{'TY'=>'match','MT'=>"($PtDeltaSeconds)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# contact-extension   =  generic-param
# $PtContactExtension = qq{$PtGenericParam};
 {'##'=>'SIP:ContactExtension',
  '#Name#'=>'ContactExtension', 
  '#TX#'=>{'MT'=>"^$PtContactExtension",'SL'=>"(^$PtContactExtension)"},
  'field'=>
     [

      {'NM'=>'extension',
       'DE'=>{'TY'=>'match','MT'=>"($PtGenericParam)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

#----------------------------------------------------------
#
#      {'NM'=>'extension','DE'=>{'SL'=>"(($PtContactExtension))"},
#                         '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}], },
#----------------------------------------------------------

     ],
 },

# Content-Disposition = "Content-Disposition" HCOLON disp-type *( SEMI disp-param )
# $ContentDisposition = qq{(?i:Content-Disposition)$PtHCOLON$PtDispType(?:$PtSEMI$PtDispParam)*};
 {'##'=>'SIP:Content-Disposition','#Name#'=>'Content-Disposition',
  '#TX#'=>{'MT'=>"^$ContentDisposition(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Content-Disposition:)(?:.*)$PtCRLF",
	   'SL'=>"(^$ContentDisposition(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Content-Disposition)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'disposition',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtDispType(?:$PtSEMI$PtDispParam)*)"},
        'EN'=>{'TY'=>'str'}},

     ],
 },

# Content-Encoding = ( "Content-Encoding" / "e" ) HCOLON content-coding *(COMMA content-coding)
# $ContentEncoding = qq{(?i:Content-Encoding|e)$PtHCOLON$PtContentCoding(?:$PtCOMMA$PtContentCoding)*};
 {'##'=>'SIP:Content-Encoding','#Name#'=>'Content-Encoding',
  '#TX#'=>{'MT'=>"^$ContentEncoding(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Content-Encoding:)(?:.*)$PtCRLF",
	   'SL'=>"(^$ContentEncoding(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Content-Encoding|e)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'encoding',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtContentCoding(?:$PtCOMMA$PtContentCoding)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Content-Language   = "Content-Language" HCOLON language-tag *(COMMA language-tag)
# $PtContentLanguage = qq{(?i:Content-Language)$PtHCOLON$PtLanguageTag(?:$PtCOMMA$PtLanguageTag)*};
 {'##'=>'SIP:Content-Language','#Name#'=>'Content-Language',
  '#TX#'=>{'MT'=>"^$PtContentLanguage(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Content-Language:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtContentLanguage(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Content-Language)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'language',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtLanguageTag(?:$PtCOMMA$PtLanguageTag)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Content-Length   = ( "Content-Length" / "l" ) HCOLON 1*DIGIT
# $PtContentLength = qq{(?i:Content-Length|l)$PtHCOLON(?:$PtDigit)+};
 {'##'=>'SIP:Content-Length','#Name#'=>'Content-Length',
  '#TX#'=>{'MT'=>"^$PtContentLength(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Content-Length:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtContentLength(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Content-Length|l)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'Length',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtDigit+)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Content-Type  = ( "Content-Type" / "c" ) HCOLON media-type
# PtContentType = qq{(?i:Content-Type|c)$PtHCOLON$PtMediaType};
 {'##'=>'SIP:Content-Type','#Name#'=>'Content-Type',
  '#TX#'=>{'MT'=>"^$PtContentType(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Content-Type:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtContentType(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Content-Type|c)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

#      {'NM'=>'mtype','DE'=>{'TY'=>'match','MT'=>"($PtMediaType)"},'EN'=>{'TY'=>'str'}},

      {'NM'=>'type',
       'DE'=>{'TY'=>'match','MT'=>"($PtMType)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V."/"}}},

      {'NM'=>'subtype',
       'DE'=>{'TY'=>'match','MT'=>"($PtMSubtype)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'param',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtSEMI$PtMParameter)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# CSeq    = "CSeq" HCOLON 1*DIGIT LWS Method
# $PtCSeq = qq{(?i:CSeq)$PtHCOLON(?:$PtDigit)+$PtLWS$PtMethod};
 {'##'=>'SIP:CSeq','#Name#'=>'CSeq',
  '#TX#'=>{'MT'=>"^$PtCSeq(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:CSeq:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtCSeq(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:CSeq)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'cseqnum',
       'DE'=>{'TY'=>'match','MT'=>"($PtDigit+)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'method',
       'DE'=>{'TY'=>'match','MT'=>"($PtMethod)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Date    = "Date" HCOLON SIPdate
# $PtDate = qq{(?i:Date)$PtHCOLON$PtSIPdate};
 {'##'=>'SIP:Date','#Name#'=>'Date',
  '#TX#'=>{'MT'=>"^$PtDate(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Date:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtDate(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Date)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

#      {'NM'=>'date','DE'=>{'TY'=>'match','MT'=>"($PtSIPdate)"},'EN'=>{'TY'=>'str'}},

      {'NM'=>'wkday',
       'DE'=>{'TY'=>'match','MT'=>"($PtWkday)"},
       'EN'=>{'TY'=>'str+sp','AC'=>\\q{$V.","}}},

      {'NM'=>'date1',
       'DE'=>{'TY'=>'match','MT'=>"($PtDate1)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'time',
       'DE'=>{'TY'=>'match','MT'=>"($PtTime1)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'zone',
       'DE'=>{'TY'=>'match','MT'=>"($PtZone)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

## Error-Info   = "Error-Info" HCOLON error-uri *(COMMA error-uri)
## $PtErrorInfo = qq{(?i:Error-Info)$PtHCOLON$PtErrorUri(?:$PtCOMMA$PtErrorUri)*};
 {'##'=>'SIP:Error-Info','#Name#'=>'Error-Info',
  '#TX#'=>{'MT'=>"^$PtErrorInfo(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Error-Info:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtErrorInfo(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Error-Info)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'error-uri',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtErrorUri(?:$PtCOMMA$PtErrorUri)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Expires    = "Expires" HCOLON delta-seconds
# $PtExpires = qq{(?i:Expires)$PtHCOLON$PtDeltaSeconds};
 {'##'=>'SIP:Expires','#Name#'=>'Expires',
  '#TX#'=>{'MT'=>"^$PtExpires(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Expires:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtExpires(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Expires)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'seconds',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtDeltaSeconds)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# from-param   = tag-param / generic-param
# $PtFromParam = qq{(?:$PtTagParam|$PtGenericParam)};
# from-spec    = ( name-addr / addr-spec ) *( SEMI from-param )
# $PtFromSpec  = qq{(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtFromParam)*};
# From         =  ( "From" / "f" ) HCOLON from-spec
# $PtFrom      = qq{(?i:From|f)$PtHCOLON$PtFromSpec};
 {'##'=>'SIP:From','#Name#'=>'From',
  '#TX#'=>{'MT'=>"^$PtFrom(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:from:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtFrom(?:$PtSP|$PtCRLF)*\$)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:From|f)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'addr',
        '#CHOICE#'=>[{'ST'=>'SIP:NameAddr'},{'ST'=>'SIP:AddrSpec'}]},


      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtFromParam)*)"},
         '#CHOICE#'=>[{'ST'=>'SIP:FromParams'}], },

     ],
 },

 {'##'=>'SIP:FromParams','#Name#'=>'FromParams',
  '#TX#'=>{'MT'=>"(?:$PtSEMI$PtFromParam)*"},
  'field'=>
     [

      {'NM'=>'list',
         '#ARRAY#'=>[{'DE'=>{'SL'=>"($PtFromParam)"},
           '#CHOICE#'=>[
              {'ST'=>'SIP:TagParam'},
              {'ST'=>'SIP:GenericParam'}], }], },

     ],
 },

# History-Info     = "History-Info" HCOLON hi-entry *(COMMA hi-entry)
# $PtHistoryInfo     = qq{(?i:History-Info)$PtHCOLON$PtHiEntry(?:$PtCOMMA$PtHiEntry)*};
 {'##'=>'SIP:History-Info','#Name#'=>'History-Info',
  '#TX#'=>{'MT'=>"^$PtHistoryInfo(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:History-Info:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtHistoryInfo(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:History-Info)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'entry',
       'DE'=>{'SL'=>"($PtHiEntry(?:$PtCOMMA$PtHiEntry)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
       '#ARRAY#'=>[
          {'ST'=>'SIP:HiEntry'}
       ],
      },

     ],
 },

# hi-targeted-to-uri= name-addr
# hi-entry         = hi-targeted-to-uri *( SEMI hi-param )
# $PtHiEntry         = qq{$PtNameAddr(?:$PtSEMI$PtHiParam)*};
 {'##'=>'SIP:HiEntry','#Name#'=>'HiEntry',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtHiEntry",
           'SL'=>"(^(?:$PtCOMMA)?$PtHiEntry)"},
  'field'=>
     [

      {'NM'=>'addr',
       'DE'=>{'SL'=>"($PtNameAddr)"},
       'EN'=>{'TY'=>'str','AC'=>\q{','.$V}},
         '#CHOICE#'=>[{'ST'=>'SIP:NameAddr'}]},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtHiParam)*)"},
         '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtHiParam)"},
             '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}]
           }
      ],},

     ],
 },

# In-Reply-To  = "In-Reply-To" HCOLON callid *( COMMA callid )
# $PtInReplyTo = qq{(?i:In-Reply-To)$PtHCOLON$PtCallid(?:$PtCOMMA$PtCallid)*};
 {'##'=>'SIP:In-Reply-To','#Name#'=>'In-Reply-To',
  '#TX#'=>{'MT'=>"^$PtInReplyTo(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:In-Reply-To:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtInReplyTo(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:In-Reply-To)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'call-id',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtCallid(?:$PtCOMMA$PtCallid)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Max-Forwards   = "Max-Forwards" HCOLON 1*DIGIT
# $PtMaxForwards = qq{(?i:Max-Forwards)$PtHCOLON$PtDigit+};
 {'##'=>'SIP:Max-Forwards','#Name#'=>'Max-Forwards',
  '#TX#'=>{'MT'=>"^$PtMaxForwards(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Max-Forwards:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtMaxForwards(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Max-Forwards)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'num',
       'DE'=>{'TY'=>'match','MT'=>"($PtDigit+)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

# MIME-Version   = "MIME-Version" HCOLON 1*DIGIT "." 1*DEGIT
# $PtMIMEversion = qq{(?i:MIME-Version)$PtHCOLON$PtDigit+\\.$PtDigit+};
 {'##'=>'SIP:MIME-Version','#Name#'=>'MIME-Version',
  '#TX#'=>{'MT'=>"^$PtMIMEversion(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:MIME-Version:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtMIMEversion(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:MIME-Version)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'version',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtDigit+)\\.(?:$PtDigit+))"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Min-SE   = 'Min-SE' HCOLON delta-seconds *(SEMI generic-param)
# $PtMinSE = qq{(?i:Min-SE)$PtHCOLON$PtDeltaSeconds(?:$PtSEMI$PtGenericParam)*};
 {'##'=>'SIP:Min-SE','#Name#'=>'Min-SE',
  '#TX#'=>{'MT'=>"^$PtMinSE(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Min-SE:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtMinSE(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Min-SE)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'seconds',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtDeltaSeconds)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtRrParam)*)"},
       '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtRrParam)"},
           '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}]}
       ],
      },

     ],
 },

# Min-Expires   = "Min-Expires" HCOLON delta-seconds
# $PtMinExpires = qq{(?i:Min-Expires)$PtHCOLON$PtDeltaSeconds};
 {'##'=>'SIP:Min-Expires','#Name#'=>'Min-Expires',
  '#TX#'=>{'MT'=>"^$PtMinExpires(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Min-Expires:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtMinExpires(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Min-Expires)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'seconds',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtDeltaSeconds)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Organization    = "Organization" HCOLON [TEXT-UTF8-TRIM]
# $PtOrganization = qq{(?i:Organization)$PtHCOLON(?:$PtTEXTUTF8TRIM)?};
 {'##'=>'SIP:Organization','#Name#'=>'Organization',
  '#TX#'=>{'MT'=>"^$PtOrganization(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Organization:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtOrganization(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Organization)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'name',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtTEXTUTF8TRIM)?)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Path             = "Path" HCOLON path-value *( COMMA path-value )
# $PtPath          = qq{(?i:Path)$PtHCOLON$PtRecRoute(?:$PtCOMMA$PtRecRoute)*};
 {'##'=>'SIP:Path','#Name#'=>'Path',
  '#TX#'=>{'MT'=>"^$PtPath(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Path:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtPath(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Path)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'routes',
       'DE'=>{'SL'=>"($PtRecRoute(?:$PtCOMMA$PtRecRoute)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[
           {'ST'=>'SIP:RecRoute'}
         ],
      },

     ]
},

# Reason           = "Reason" HCOLON reason-value *(COMMA reason-value)
# $PtReason        = qq{(?i:Reason)$PtHCOLON$PtReasonValue(?:$PtCOMMA$PtReasonValue)*};
 {'##'=>'SIP:Reason','#Name#'=>'Reason',
  '#TX#'=>{'MT'=>"^$PtReason(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Reason:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtReason(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Reason|x)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'protocol',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtToken)"},
       'EN'=>{'TY'=>'str'}},
      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtGenericParam)*)"},
       '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtGenericParam)"},
           '#CHOICE#'=>[{'ST'=>'SIP:ProtocolCause'},
			{'ST'=>'SIP:ReasonText'},
			{'ST'=>'SIP:GenericParam'},]}
       ],
      },
     ],
 },

# protocol-cause    =  "cause" EQUAL cause
# $PtProtocolCause    = qq{(?:(?i:cause)$PtEQUAL(?:$PtDigit)+)};
 {'##'=>'SIP:ProtocolCause','#Name#'=>'Cause',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtProtocolCause",
           'SL'=>"(^(?:$PtSEMI)?$PtProtocolCause)",},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:cause))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'cause',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtDigit)+)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

# reason-text       =  "text" EQUAL quoted-string
# $PtReasonText       = qq{(?:(?i:text)$PtEQUAL$PtQuotedString)};
 {'##'=>'SIP:ReasonText','#Name#'=>'Text',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtReasonText",
           'SL'=>"(^(?:$PtSEMI)?$PtReasonText)",},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:text))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'text',
       'DE'=>{'TY'=>'match','MT'=>"($PtQuotedString)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

# Priority    =  "Priority" HCOLON priority-value
# $PtPriority    = qq{(?i:Priority)$PtHCOLON$PtPriorityValue)};
 {'##'=>'SIP:Priority','#Name#'=>'Priority',
  '#TX#'=>{'MT'=>"^$PtPriority(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Priority:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtPriority(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Priority)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'priority',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtPriorityValue)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Proxy-Authenticate  =  "Proxy-Authenticate" HCOLON challenges
# $PtProxyAuthenticate = qq{(?i:Proxy-Authenticate)$PtHCOLON$PtChallenge};
 {'##'=>'SIP:Proxy-Authenticate','#Name#'=>'Proxy-Authenticate',
  '#TX#'=>{'MT'=>"^$PtProxyAuthenticate(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Proxy-Authenticate:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtProxyAuthenticate(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Proxy-Authenticate)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'challenge',
       'DE'=>{'SL'=>"($PtChallenge)"},
         '#CHOICE#'=>[{'ST'=>'SIP:Challenge'}], },

     ],
},

# challenge    = ("Digest" LWS digest-cln *(COMMA digest-cln)) / other-challenge
# $PtChallenge = qq{(?:(?:(?i:Digest)$PtLWS$PtDigestCln(?:$PtCOMMA$PtDigestCln)*)|$PtOtherChallenge)};
 {'##'=>'SIP:Challenge','#Name#'=>'Challenge', '#TX#'=>{'MT'=>$PtChallenge},
  'field'=>
     [

      {'NM'=>'credentials',
       'DE'=>{'SL'=>"($PtChallenge)"},
         '#CHOICE#'=>[
           {'ST'=>'SIP:DigestCln'},
           {'ST'=>'SIP:OtherChallenge'}], },

     ],
 },

 {'##'=>'SIP:DigestCln','#Name#'=>'DigestCln',
  '#TX#'=>{'MT'=>"(?:(?i:Digest)$PtLWS$PtDigestCln(?:$PtCOMMA$PtDigestCln)*)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Digest))"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'digestresp',
       'DE'=>{'SL'=>"((?:$PtDigestCln(?:$PtCOMMA$PtDigestCln)*))"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#CHOICE#'=>[{'ST'=>'SIP:DigestClns'}], },

     ],
 },

 {'##'=>'SIP:DigestClns','#Name#'=>'DigestDigestClns',
  '#TX#'=>{'MT'=>"(?:$PtDigestCln(?:$PtCOMMA$PtDigestCln)*)"},
  'field'=>
     [

      {'NM'=>'list',
         '#ARRAY#'=>[{'DE'=>{'SL'=>"((?:$PtCOMMA)?$PtDigestCln)"},
           '#CHOICE#'=>[
             {'ST'=>'SIP:Realm'},
             {'ST'=>'SIP:Domain'},
             {'ST'=>'SIP:Nonce'},
             {'ST'=>'SIP:Opaque'},
             {'ST'=>'SIP:Stale'},
             {'ST'=>'SIP:Algorithm'},
             {'ST'=>'SIP:QopOptions'},
             {'ST'=>'SIP:AuthParam'}], }], },

     ],
 },

# other-challenge   = auth-scheme LWS auth-param  *(COMMA auth-param)
# $PtOtherChallenge = qq{$PtAuthScheme$PtLWS$PtAuthParam(?:$PtCOMMA$PtAuthParam)*};
 {'##'=>'SIP:OtherChallenge','#Name#'=>'OtherChallenge',
  '#TX#'=>{'MT'=>$PtOtherChallenge},
  'field'=>
     [

      {'NM'=>'scheme',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtAuthScheme)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'params',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtAuthParam(?:$PtCOMMA$PtAuthParam)*))"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Proxy-Authorization  =  "Proxy-Authorization" HCOLON credentials
# $PtProxyAuthorization= qq{(?i:Proxy-Authorization)$PtHCOLON$PtCredentials};
 {'##'=>'SIP:Proxy-Authorization','#Name#'=>'Proxy-Authorization',
  '#TX#'=>{'MT'=>"^$PtProxyAuthorization(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Proxy-Authorization:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtProxyAuthorization(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Proxy-Authorization)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'credentials',
       'DE'=>{'SL'=>"($PtCredentials)"},
         '#CHOICE#'=>[{'ST'=>'SIP:Credentials'}], },

     ],
},

# P-Associated-URI = "P-Associated-URI" HCOLON (p-aso-uri-spec) *(COMMA p-aso-uri-spec)
# $PtPAssociatedURI  = qq{(?i:P-Associated-URI)$PtHCOLON$PtRecRoute(?:$PtCOMMA$PtRecRoute)*};
 {'##'=>'SIP:P-Associated-URI','#Name#'=>'P-Associated-URI',
  '#TX#'=>{'MT'=>"^$PtPAssociatedURI(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:P-Associated-URI:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtPAssociatedURI(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:P-Associated-URI)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'assocuri',
       'DE'=>{'SL'=>"($PtRecRoute(?:$PtCOMMA$PtRecRoute)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[
           {'ST'=>'SIP:RecRoute'}
         ],
      },

     ]
},

# P-Called-Party-ID = "P-Called-Party-ID" HCOLON called-pty-id-spec
# $PtPCalledPartyID  = qq{(?i:P-Called-Party-ID)$PtHCOLON$PtRecRoute(?:$PtCOMMA$PtRecRoute)*};
 {'##'=>'SIP:P-Called-Party-ID','#Name#'=>'P-Called-Party-ID',
  '#TX#'=>{'MT'=>"^$PtPCalledPartyID(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:P-Called-Party-ID:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtPCalledPartyID(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:P-Called-Party-ID)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'rr',
       'DE'=>{'SL'=>"($PtRecRoute(?:$PtCOMMA$PtRecRoute)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[
           {'ST'=>'SIP:RecRoute'}
         ],
      },

     ]
 },

# P-Visited-Network-ID = "P-Visited-Network-ID" HCOLON vnetwork-spec *(COMMA vnetwork-spec)
# $PtPVisitedNetworkID = qq{(?i:P-Visited-Network-ID)$PtHCOLON$PtVvnetworkSpec(?:$PtCOMMA$PtVvnetworkSpec)*};
 {'##'=>'SIP:P-Visited-Network-ID','#Name#'=>'P-Visited-Network-ID',
  '#TX#'=>{'MT'=>"^$PtPVisitedNetworkID(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:P-Visited-Network-ID:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtPVisitedNetworkID(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:P-Visited-Network-ID)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'network',
       'DE'=>{'SL'=>"($PtVvnetworkSpec(?:$PtCOMMA$PtVvnetworkSpec)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[
           {'ST'=>'SIP:VnetworkSpec'}
         ],
      },

     ]
 },


# vnetwork-param   = generic-param
# vnetwork-spec    = (token / quoted-string) *( SEMI vnetwork-param)
# $PtVvnetworkSpec   = qq{(?:$PtToken|$PtQuotedString)(?:$PtSEMI$PtGenericParam)*};
 {'##'=>'SIP:VnetworkSpec','#Name#'=>'VnetworkSpec',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtVvnetworkSpec",
           'SL'=>"(^(?:$PtCOMMA)?$PtVvnetworkSpec)"},
  'field'=>
     [

      {'NM'=>'name',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtToken|$PtQuotedString))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtGenericParam)*)"},
       '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtGenericParam)"},
           '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}]}
       ],
      },

     ],
 },

# P-Access-Network-Info  = "P-Access-Network-Info" HCOLON access-net-spec
# $PtPAccessNetworkInfo = qq{(?i:P-Access-Network-Info)$PtHCOLON$PtAccessType(?:$PtSEMI$PtAccessInfo)*};
 {'##'=>'SIP:P-Access-Network-Info','#Name#'=>'P-Access-Network-Info',
  '#TX#'=>{'MT'=>"^$PtPAccessNetworkInfo(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:P-Access-Network-Info:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtPAccessNetworkInfo(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:P-Access-Network-Info)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'type',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtAccessType)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'info',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtAccessInfo)*)"},
       'EN'=>{'TY'=>'str'},
         '#CHOICE#'=>[{'ST'=>'SIP:AccessInfo'}], },
      ],
 },

# access-info      = cgi-3gpp / utran-cell-id-3gpp / extension-access-info
# $PtAccessInfo      = qq{(?:$PtCgi3gpp|$PtUtranCellId3gpp|$PtGenericParam)};
 {'##'=>'SIP:AccessInfo','#Name#'=>'AccessInfo',
  '#TX#'=>{'MT'=>$PtAccessInfo},
  'field'=>
     [

      {'NM'=>'list',
          '#ARRAY#'=>[{'DE'=>{'SL'=>"($PtAccessInfo)"},
          '#CHOICE#'=>[
              {'ST'=>'SIP:Cgi3gpp'},
              {'ST'=>'SIP:UtranCellId3gpp'},
              {'ST'=>'SIP:GenericParam'}], }], },

     ],
 },

# cgi-3gpp         = "cgi-3gpp" EQUAL (token / quoted-string)
# $PtCgi3gpp         = qq{(?i:cgi-3gpp)$PtEQUAL$PtMValue};
 {'##'=>'SIP:Cgi3gpp','#Name#'=>'Cgi3gpp',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtCgi3gpp",
           'SL'=>"(^(?:$PtSEMI)?$PtCgi3gpp)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:cgi-3gpp))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'cgi',
       'DE'=>{'TY'=>'match','MT'=>"($PtMValue)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

# utran-cell-id-3gpp = "utran-cell-id-3gpp" EQUAL (token / quoted-string)
# $PtUtranCellId3gpp = qq{(?i:utran-cell-id-3gpp)$PtEQUAL$PtMValue};
 {'##'=>'SIP:UtranCellId3gpp','#Name#'=>'UtranCellId3gpp',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtUtranCellId3gpp",
           'SL'=>"(^(?:$PtSEMI)?$PtUtranCellId3gpp)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:utran-cell-id-3gpp))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'utran',
       'DE'=>{'TY'=>'match','MT'=>"($PtMValue)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

# P-Charging-Addr  = "P-Charging-Function-Addresses" HCOLON charge-addr-params *( SEMI charge-addr-params)
# $PtPChargingAddr   = qq{(?i:P-Charging-Function-Addresses)$PtHCOLON$PtChargeAddrParams(?:$PtSEMI$PtChargeAddrParams)*};
 {'##'=>'SIP:P-Charging-Addr','#Name#'=>'P-Charging-Addr',
  '#TX#'=>{'MT'=>"^$PtPChargingAddr(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:P-Charging-Function-Addresses:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtPChargingAddr(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:P-Charging-Function-Addresses)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'addr',
       'DE'=>{'SL'=>"($PtChargeAddrParams(?:$PtSEMI$PtChargeAddrParams)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
       '#ARRAY#'=>
	    [{'DE'=>{'SL'=>$PtChargeAddrParams}, # 
	      '#CHOICE#'=>      # 
	      [
               {'ST'=>'SIP:Ecf'},
               {'ST'=>'SIP:Ccf'},
               {'ST'=>'SIP:GenericParam'}], }],},
      ]
 },

# ecf              = "ecf" EQUAL gen-value
# $PtEcf             = qq{(?:(?i:ecf)$PtEQUAL$PtGenValue)};
 {'##'=>'SIP:Ecf','#Name#'=>'Ecf',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtEcf",
           'SL'=>"(^(?:$PtSEMI)?$PtEcf)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:ecf))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'ecf',
       'DE'=>{'TY'=>'match','MT'=>"($PtGenValue)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

# ccf              = "ccf" EQUAL gen-value
# $PtCcf             = qq{(?:(?i:ccf)$PtEQUAL$PtGenValue)};
 {'##'=>'SIP:Ccf','#Name#'=>'Ccf',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtCcf",
           'SL'=>"(^(?:$PtSEMI)?$PtCcf)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:ccf))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'ccf',
       'DE'=>{'TY'=>'match','MT'=>"($PtGenValue)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

# P-Charging-Vector= "P-Charging-Vector" HCOLON icid-value *( SEMI charge-params)
# $PtPChargingVector = qq{(?i:P-Charging-Vector)$PtHCOLON$PtIcidValue(?:$PtSEMI$PtChargeParams)*};
 {'##'=>'SIP:P-Charging-Vector','#Name#'=>'P-Charging-Vector',
  '#TX#'=>{'MT'=>"^$PtPChargingVector(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:P-Charging-Vector:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtPChargingVector(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:P-Charging-Vector)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'icid',
       'DE'=>{'SL'=>"((?:$PtIcidValue))"},
         '#CHOICE#'=>[{'ST'=>'SIP:IcidValue'}], },

      {'NM'=>'param',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtChargeParams)*)"},
       'EN'=>{'TY'=>'str'},
       '#ARRAY#'=>[{'DE'=>{'SL'=>"($PtChargeParams)"},
       '#CHOICE#'=>[
              {'ST'=>'SIP:IcidGenAddr'},
              {'ST'=>'SIP:OrigIoi'},
              {'ST'=>'SIP:TermIoi'},
              {'ST'=>'SIP:GenericParam'}], }], },

      ],
 },

# icid-value       = "icid-value" EQUAL gen-value
# $PtIcidValue       = qq{(?:(?i:icid-value)$PtEQUAL$PtGenValue)};
 {'##'=>'SIP:IcidValue','#Name#'=>'IcidValue',
  '#TX#'=>{'MT'=>"^$PtIcidValue",
           'SL'=>"(^$PtIcidValue)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:icid-value))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V.'='}}},

      {'NM'=>'icid',
       'DE'=>{'TY'=>'match','MT'=>"($PtGenValue)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

# icid-gen-addr    = "icid-generated-at" EQUAL host
# $PtIcidGenAddr     = qq{(?:(?i:icid-generated-at)$PtEQUAL$PtGenValue)};
 {'##'=>'SIP:IcidGenAddr','#Name#'=>'IcidGenAddr',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtIcidGenAddr",
           'SL'=>"(^(?:$PtSEMI)?$PtIcidGenAddr)",},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:icid-generated-at))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'icidaddr',
       'DE'=>{'TY'=>'match','MT'=>"($PtGenValue)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

# term-ioi         = "term-ioi" EQUAL gen-value
# $PtTermIoi         = qq{(?:(?i:term-ioi)$PtEQUAL$PtGenValue)};
 {'##'=>'SIP:TermIoi','#Name#'=>'TermIoi',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtTermIoi",
           'SL'=>"(^(?:$PtSEMI)?$PtTermIoi)",},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:term-ioi))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'term',
       'DE'=>{'TY'=>'match','MT'=>"($PtGenValue)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

# orig-ioi         = "orig-ioi" EQUAL gen-value
# $PtOrigIoi         = qq{(?:(?i:orig-ioi)$PtEQUAL$PtGenValue)};
 {'##'=>'SIP:OrigIoi','#Name#'=>'OrigIoi',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtOrigIoi",
           'SL'=>"(^(?:$PtSEMI)?$PtOrigIoi)",},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:orig-ioi))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'orig',
       'DE'=>{'TY'=>'match','MT'=>"($PtGenValue)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },


# Proxy-Require   =  "Proxy-Require" HCOLON option-tag *(COMMA option-tag)
# $PtProxyRequire   = qq{(?i:Proxy-Require)$PtHCOLON$PtOptionTag(?:$PtCOMMA$PtOptionTag)*};
 {'##'=>'SIP:Proxy-Require','#Name#'=>'Proxy-Require',
  '#TX#'=>{'MT'=>"^$PtProxyRequire(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Proxy-Require:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtProxyRequire(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Proxy-Require)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'option',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtOptionTag(?:$PtCOMMA$PtOptionTag)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Record-Route   = "Record-Route" HCOLON rec-route *(COMMA rec-route)
# $PtRecordRoute = qq{(?i:Record-Route)$PtHCOLON$PtRecRoute(?:$PtCOMMA$PtRecRoute)*};
 {'##'=>'SIP:Record-Route','#Name#'=>'Record-Route',
  '#TX#'=>{'MT'=>"^$PtRecordRoute(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Record-Route:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtRecordRoute(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Record-Route)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'routes',
       'DE'=>{'SL'=>"($PtRecRoute(?:$PtCOMMA$PtRecRoute)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[
           {'ST'=>'SIP:RecRoute'}
         ],
      },

     ]
},

# rec-route   = name-addr *( SEMI rr-param )
# $PtRecRoute = qq{$PtNameAddr(?:$PtSEMI$PtRrParam)*};
 {'##'=>'SIP:RecRoute','#Name#'=>'RecRoute',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtRecRoute",
           'SL'=>"(^(?:$PtCOMMA)?$PtRecRoute)"},
  'field'=>
     [

      {'NM'=>'addr',
       'DE'=>{'SL'=>"($PtNameAddr)"},
       'EN'=>{'TY'=>'str','AC'=>\q{','.$V}},
         '#CHOICE#'=>[{'ST'=>'SIP:NameAddr'}]},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtRrParam)*)"},
         '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtRrParam)"},
             '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}]}
         ],
      },

     ],
 },

# Remote-Party-ID    = "Remote-Party-ID" ":" [display-name] "<" addr-spec ">" *(";" rpi-token)
# $PtRemotePartyID     = qq{(?i:Remote-Party-ID)$PtHCOLON(?:$PtDisplayName)?$PtLAQUOT$PtAddrSpec$PtRAQUOT(?:$PtSEMI$PtRpiToken)*};
 {'##'=>'SIP:Remote-Party-ID','#Name#'=>'Remote-Party-ID',
  '#TX#'=>{'MT'=>"^$PtRemotePartyID(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Remote-Party-ID:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtRemotePartyID(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Remote-Party-ID)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'addr',
        '#CHOICE#'=>[{'ST'=>'SIP:NameAddr'}]
      },

      {'NM'=>'params',
       'DE'=>{'SL'=>"(((?:$PtSEMI$PtRpiToken)*))"},
         '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtRpiToken)"},
             '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}]}
         ],
      },
     ]
},

# Reply-To   = "Reply-To" HCOLON rplyto-spec
# $PtReplyTo = qq{(?i:Reply-To)$PtHCOLON$PtRplytoSpec};
 {'##'=>'SIP:Reply-To','#Name#'=>'Reply-To',
  '#TX#'=>{'MT'=>"^$PtReplyTo(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Reply-To:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtReplyTo(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Reply-To)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'addr',
        '#CHOICE#'=>[{'ST'=>'SIP:NameAddr'},{'ST'=>'SIP:AddrSpec'}]},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtRplytoParam)*)"},
       '#ARRAY#'=>[
         {'DE'=>{'SL'=>"($PtRplytoParam)"},
           '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}]}
       ],
      },

     ]
},

# Require    = "Require" HCOLON option-tag *(COMMA option-tag)
# $PtRequire = qq{(?i:Require)$PtHCOLON$PtOptionTag(?:$PtCOMMA$PtOptionTag)*};
 {'##'=>'SIP:Require','#Name#'=>'Require',
  '#TX#'=>{'MT'=>"^$PtRequire(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Require:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtRequire(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Require)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'option',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtOptionTag(?:$PtCOMMA$PtOptionTag)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Retry-After   = "Retry-After" HCOLON delta-seconds [ comment ] *( SEMI retry-param )
# $PtRetryAfter = qq{(?i:Retry-After)$PtHCOLON$PtDeltaSeconds(?:$PtComment)?(?:$PtSEMI$PtRetryParam)*};
 {'##'=>'SIP:Retry-After','#Name#'=>'Retry-After',
  '#TX#'=>{'MT'=>"^$PtRetryAfter(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Retry-After:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtRetryAfter(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Retry-After)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'seconds',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtDeltaSeconds)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'comment',
       'DE'=>{'TY'=>'match',
              'MT'=>"$PtLPAREN((?:$PtCtext|$PtQuotedPair|(?:$PtComment0))*)$PtRPAREN"},
       'EN'=>{'TY'=>'str','AC'=>\\q{"(".$V.")"}}},

      {'NM'=>'params',
       'DE'=>{'SL'=>"(((?:$PtSEMI$PtRetryParam)*))"},
         '#CHOICE#'=>[{'ST'=>'SIP:RetryParams'}], },

     ],
 },

# retry-param   = ("duration" EQUAL delta-seconds) / generic-param
# $PtRetryParam = qq{(?:(?i:duration)$PtEQUAL$PtDeltaSeconds|$PtGenericParam)};
 {'##'=>'SIP:RetryParams','#Name#'=>'RetryParams',
  '#TX#'=>{'MT'=>"((?:$PtSEMI$PtRetryParam)*)"},
  'field'=>
     [

      {'NM'=>'list',
        '#ARRAY#'=>[{'DE'=>{'SL'=>"(($PtRetryParam))"},
          '#CHOICE#'=>[
            {'ST'=>'SIP:Duration'},
            {'ST'=>'SIP:GenericParam'}], }],
      },

     ],
 },

 {'##'=>'SIP:Duration','#Name#'=>'Duration',
  '#TX#'=>{'MT'=>"(?i:duration)$PtEQUAL$PtDeltaSeconds",'SL'=>"^((?i:duration)$PtEQUAL$PtDeltaSeconds)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:duration))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'duration',
       'DE'=>{'TY'=>'match','MT'=>"($PtDeltaSeconds)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Route    = "Route" HCOLON route-param *(COMMA route-param)
# $PtRoute = qq{(?i:Route)$PtHCOLON$PtRouteParam(?:$PtCOMMA$PtRouteParam)*};
 {'##'=>'SIP:Route','#Name#'=>'Route',
  '#TX#'=>{'MT'=>"^$PtRoute(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Route:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtRoute(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Route)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'routes',
       'DE'=>{'SL'=>"($PtRouteParam(?:$PtCOMMA$PtRouteParam)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
       '#ARRAY#'=>[
          {'ST'=>'SIP:RouteParam'}
       ],
      },

     ]
},

# route-param   = name-addr *( SEMI rr-param )
# $PtRouteParam = qq{$PtNameAddr(?:$PtSEMI$PtRrParam)*};
 {'##'=>'SIP:RouteParam','#Name#'=>'RouteParam',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtRouteParam",
           'SL'=>"(^(?:$PtCOMMA)?$PtRouteParam)"},
  'field'=>
     [

      {'NM'=>'addr',
       'DE'=>{'SL'=>"($PtNameAddr)"},
       'EN'=>{'TY'=>'str','AC'=>\q{','.$V}},
         '#CHOICE#'=>[{'ST'=>'SIP:NameAddr'}]},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtRrParam)*)"},
         '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtRrParam)"},
             '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}]
           }
      ],},

     ],
 },

# security-client  = "Security-Client" HCOLON sec-mechanism *(COMMA sec-mechanism)
# $PtSecurityClient  = qq{(?i:Security-Client)$PtHCOLON$PtSecMechanism(?:$PtCOMMA$PtSecMechanism)*};
 {'##'=>'SIP:Security-Client','#Name#'=>'Security-Client',
  '#TX#'=>{'MT'=>"^$PtSecurityClient(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Security-Client:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtSecurityClient(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Security-Client)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'mechanism',
       'DE'=>{'SL'=>"($PtSecMechanism(?:$PtCOMMA$PtSecMechanism)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[
           {'ST'=>'SIP:Mechanism'}
         ],
      },

     ]
},

# security-server  = "Security-Server" HCOLON sec-mechanism *(COMMA sec-mechanism)
# $PtSecurityServer  = qq{(?i:Security-Server)$PtHCOLON$PtSecMechanism(?:$PtCOMMA$PtSecMechanism)*};
 {'##'=>'SIP:Security-Server','#Name#'=>'Security-Server',
  '#TX#'=>{'MT'=>"^$PtSecurityServer(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Security-Server:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtSecurityServer(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Security-Server)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'mechanism',
       'DE'=>{'SL'=>"($PtSecMechanism(?:$PtCOMMA$PtSecMechanism)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[
           {'ST'=>'SIP:Mechanism'}
         ],
      },

     ]
},

# security-verify  = "Security-Verify" HCOLON sec-mechanism *(COMMA sec-mechanism)
# $PtSecurityVerify  = qq{(?i:Security-Verify)$PtHCOLON$PtSecMechanism(?:$PtCOMMA$PtSecMechanism)*};
 {'##'=>'SIP:Security-Verify','#Name#'=>'Security-Verify',
  '#TX#'=>{'MT'=>"^$PtSecurityVerify(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Security-Verify:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtSecurityVerify(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Security-Verify)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'mechanism',
       'DE'=>{'SL'=>"($PtSecMechanism(?:$PtCOMMA$PtSecMechanism)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[
           {'ST'=>'SIP:Mechanism'}
         ],
      },

     ]
},

# sec-mechanism    = mechanism-name *(SEMI mech-parameters)
# $PtSecMechanism    = qq{$PtMechanismName(?:$PtSEMI$PtMechParameters)*};
 {'##'=>'SIP:Mechanism','#Name#'=>'Mechanism',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtSecMechanism",
           'SL'=>"(^(?:$PtCOMMA)?$PtSecMechanism)"},
  'field'=>
     [

      {'NM'=>'name',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtMechanismName)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtMechParameters)*)"},
         '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtMechParameters)"},
             '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}]}
         ],
      },

     ],
 },

# Server      =  "Server" HCOLON server-val *(LWS server-val)
# $PtServer     = qq{((?i:Server)$PtHCOLON$PtServerVal(?:$PtLWS$PtServerVal)*)};
 {'##'=>'SIP:Server','#Name#'=>'Server',
  '#TX#'=>{'MT'=>"^$PtServer(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Server:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtServer(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Server)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'server-val',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtServerVal(?:$PtLWS$PtServerVal)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Service-Route    = "Service-Route" HCOLON route-param *(COMMA route-param)
# $PtServiceRoute = qq{(?i:Service-Route)$PtHCOLON$PtRouteParam(?:$PtCOMMA$PtRouteParam)*};
 {'##'=>'SIP:Service-Route','#Name#'=>'Service-Route',
  '#TX#'=>{'MT'=>"^$PtServiceRoute(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Service-Route:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtServiceRoute(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:Service-Route)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'routes',
       'DE'=>{'SL'=>"($PtRouteParam(?:$PtCOMMA$PtRouteParam)*)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
       '#ARRAY#'=>[
          {'ST'=>'SIP:RouteParam'}
       ],
      },

     ]
},

# Session-Expires   = ('Session-Expires' / 'x') HCOLON delta-seconds *(SEMI se-params)
# $PtSessionExpires = qq{(?i:Session-Expires|x)$PtHCOLON$PtDeltaSeconds(?:$PtSEMI$PtSEParams)*};
 {'##'=>'SIP:Session-Expires','#Name#'=>'Session-Expires',
  '#TX#'=>{'MT'=>"^$PtSessionExpires(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Session-Expires:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtSessionExpires(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Session-Expires|x)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'seconds',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtDeltaSeconds)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtRrParam)*)"},
         '#ARRAY#'=>[
           {'DE'=>{'SL'=>"(($PtRrParam))"},
             '#CHOICE#'=>[
               {'ST'=>'SIP:RefresherParam'},
               {'ST'=>'SIP:GenericParam'}], }],
      },

     ],
 },

# Subject    = ( "Subject" / "s" ) HCOLON [TEXT-UTF8-TRIM]
# $PtSubject = qq{(?i:Subject|s)$PtHCOLON(?:$PtTEXTUTF8TRIM)?};
 {'##'=>'SIP:Subject','#Name#'=>'Subject',
  '#TX#'=>{'MT'=>"^$PtSubject(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Subject:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtSubject(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Subject|s)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'txt',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtTEXTUTF8TRIM)?)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Supported    = ( "Supported" / "k" ) HCOLON [option-tag *(COMMA option-tag)]
# $PtSupported = qq{(?i:Supported|k)$PtHCOLON(?:$PtOptionTag(?:$PtCOMMA$PtOptionTag)*)?};
 {'##'=>'SIP:Supported','#Name#'=>'Supported',
  '#TX#'=>{'MT'=>"^$PtSupported(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Supported:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtSupported(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Supported|k)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'option',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtOptionTag(?:$PtCOMMA$PtOptionTag)*)?)"},
       'EN'=>{'TY'=>'str'}},

     ]
},

# Timestamp    = "Timestamp" HCOLON 1*(DIGIT) [ "." *(DIGIT) ] [ LWS delay ]
# $PtTimestamp = qq{(?i:Timestamp)$PtHCOLON(?:$PtDigit)+(?:.(?:$PtDigit)*)?(?:$PtLWS$PtDelay)?};
 {'##'=>'SIP:Timestamp','#Name#'=>'Timestamp',
  '#TX#'=>{'MT'=>"^$PtTimestamp(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Timestamp:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtTimestamp(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Timestamp)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'timestamp',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtDigit)+(?:\\.(?:$PtDigit)*)?)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'delay',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtLWS$PtDelay)?)"},
       'EN'=>{'TY'=>'str'}},

     ]
},

# to-param   = tag-param / generic-param
# $PtToParam = qq{(?:$PtTagParam|$PtGenericParam)};
# to-spec    = ( name-addr / addr-spec ) *( SEMI to-param )
# $PtToSpec  = qq{(?:$PtNameAddr|$PtAddrSpec)(?:$PtSEMI$PtToParam)*};
# To         = ( "To" / "t" ) HCOLON to-spec
# $PtTo      = qq{(?i:To|t)$PtHCOLON$PtToSpec};
 {'##'=>'SIP:To','#Name#'=>'To',
  '#TX#'=>{'MT'=>"^$PtTo(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:to:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtTo(?:$PtSP|$PtCRLF)*\$)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:To|t)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}
      },

      {'NM'=>'addr',
        '#CHOICE#'=>[{'ST'=>'SIP:NameAddr'},
                     {'ST'=>'SIP:AddrSpec'}]
      },

      {'NM'=>'params',
       'DE'=>{'SL'=>"(((?:$PtSEMI$PtToParam)*))"},
         '#CHOICE#'=>[{'ST'=>'SIP:ToParams'}],
      },

     ],
 },

 {'##'=>'SIP:ToParams','#Name#'=>'ToParams',
  '#TX#'=>{'MT'=>"((?:$PtSEMI$PtToParam)*)"},
  'field'=>
     [

      {'NM'=>'list',
         '#ARRAY#'=>[{'DE'=>{'SL'=>"(($PtToParam))"},
           '#CHOICE#'=>[
              {'ST'=>'SIP:TagParam'},
              {'ST'=>'SIP:GenericParam'}], }],
      },

     ],
 },

# Unsupported    = "Unsupported" HCOLON option-tag *(COMMA option-tag)
# $PtUnsupported = qq{(?i:Unsupported)$PtHCOLON$PtOptionTag(?:$PtCOMMA$PtOptionTag)*};
 {'##'=>'SIP:Unsupported','#Name#'=>'Unsupported',
  '#TX#'=>{'MT'=>"^$PtUnsupported(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Unsupported:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtUnsupported(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Unsupported)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'option',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtOptionTag(?:$PtCOMMA$PtOptionTag)*)"},
       'EN'=>{'TY'=>'str'}},

     ]
},

# User-Agent   = "User-Agent" HCOLON server-val *(LWS server-val)
# $PtUserAgent = qq{(?i:User-Agent)$PtHCOLON$PtServerVal(?:$PtLWS$PtServerVal)*};
 {'##'=>'SIP:User-Agent','#Name#'=>'User-Agent',
  '#TX#'=>{'MT'=>"^$PtUserAgent(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:User-Agent:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtUserAgent(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:User-Agent)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'server-val',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtServerVal(?:$PtLWS$PtServerVal)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Via    = ( "Via" / "v" ) HCOLON via-parm *(COMMA via-parm)
# $PtVia = qq{(?i:Via|v)$PtHCOLON$PtViaParm(?:$PtCOMMA$PtViaParm)*};
 {'##'=>'SIP:Via','#Name#'=>'Via',
  '#TX#'=>{'MT'=>"^$PtVia(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Via:)(?:.*)$PtCRLF",
           'SL'=>"^($PtVia)(?:$PtCRLF)?\$",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Via|v)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'records',
       'DE'=>{'SL'=>"($PtViaParm(?:$PtCOMMA$PtViaParm)*)\$"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[
           {'ST'=>'SIP:ViaParm'}], },

     ],
 },

# WWW-Authenticate   = "WWW-Authenticate" HCOLON challenge
# $PtWWWAuthenticate = qq{(?i:WWW-Authenticate)$PtHCOLON$PtChallenge};
 {'##'=>'SIP:WWW-Authenticate','#Name#'=>'WWW-Authenticate',
  '#TX#'=>{'MT'=>"^$PtWWWAuthenticate(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:WWW-Authenticate:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtWWWAuthenticate(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:WWW-Authenticate)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'challenge',
       'DE'=>{'SL'=>"((?:$PtChallenge))"},
         '#CHOICE#'=>[{'ST'=>'SIP:Challenge'}], },

     ],
},

# Warning    = "Warning" HCOLON warning-value *(COMMA warning-value)
# $PtWarning = qq{(?i:Warning)$PtHCOLON$PtWarningValue(?:$PtCOMMA$PtWarningValue)*};
 {'##'=>'SIP:Warning','#Name#'=>'Warning',
  '#TX#'=>{'MT'=>"^$PtWarning(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Warning:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtWarning(?:$PtCRLF)?)",},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Warning)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'code',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtWarnCode))"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'agent',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtWarnAgent))"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'text',
       'DE'=>{'TY'=>'match',
              'MT'=>"$PtSWS\"((?:$PtQdtext|$PtQuotedPair)*)\""},
       'EN'=>{'TY'=>'str','AC'=>\\q{'"'.$V.'"'}}},

      {'NM'=>'warnings',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtCOMMA$PtWarningValue)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Privacy-hdr = "Privacy" HCOLON priv-value *(";" priv-value)
# $PtPrivacy  = qq{(?i:Privacy)$PtHCOLON$PtPrivValue(?:$PtSEMI$PtPrivValue)*};
 {'##'=>'SIP:Privacy','#Name#'=>'Privacy',
  '#TX#'=>{'MT'=>"^$PtPrivacy(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Privacy:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtPrivacy(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Privacy)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'priv',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtPrivValue(?:$PtSEMI$PtPrivValue)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# PAssertedID    = "P-Asserted-Identity" HCOLON PAssertedID-value *(COMMA PAssertedID-value)
# $PtPAssertedID =  qq{(?i:P-Asserted-Identity)$PtHCOLON$PtPAssertedIDValue(?:$PtCOMMA$PtPAssertedIDValue)*};
 {'##'=>'SIP:P-Asserted-Identity','#Name#'=>'P-Asserted-Identity',
  '#TX#'=>{'MT'=>"^$PtPAssertedID(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:P-Asserted-Identity:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtPAssertedID(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:P-Asserted-Identity)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'ids',
       'DE'=>{'SL'=>"((?:$PtPAssertedIDValue(?:$PtCOMMA$PtPAssertedIDValue)*)?)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[{'DE'=>{'SL'=>"((?:$PtCOMMA)?$PtPAssertedIDValue)"},
           '#CHOICE#'=>[ # 
             {'ST'=>'SIP:PAssertIdentityParam'}, ]}
       ],},

     ],
 },

# PAssertedID-value   = name-addr / addr-spec
# $PtPAssertedIDValue = qq{(?:$PtNameAddr|$PtAddrSpec)}; 
 {'##'=>'SIP:PAssertIdentityParam','#Name#'=>'PAssertIdentityParam',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtPAssertedIDValue",
           'SL'=>"(^(?:$PtCOMMA)?$PtPAssertedIDValue?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'addr',
       'DE'=>{'TY'=>'match',
              'MT'=>"(?:$PtCOMMA)?((?:$PtPAssertedIDValue))",
              'SL'=>"((?:$PtPAssertedIDValue))"},
       'EN'=>{'TY'=>'str','AC'=>\q{','.$V}},
         '#CHOICE#'=>[
           {'ST'=>'SIP:NameAddr'},
           {'ST'=>'SIP:AddrSpec'}]},

     ],
 },

# PPreferredID    = "P-Preferred-Identity" HCOLON PPreferredID-value *(COMMA PPreferredID-value)
# $PtPPreferredID = qq{(?i:P-Preferred-Identity)$PtHCOLON$PtPPreferredIDValue(?:$PtCOMMA$PtPPreferredIDValue)*};
 {'##'=>'SIP:P-Preferred-Identity','#Name#'=>'P-Preferred-Identity',
  '#TX#'=>{'MT'=>"^$PtPPreferredID(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:P-Preferred-Identity:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtPPreferredID(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:P-Preferred-Identity)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'ids',
       'DE'=>{'SL'=>"((?:$PtPPreferredIDValue(?:$PtCOMMA$PtPPreferredIDValue)*)?)"},
       'EN'=>{'TY'=>'str','AC'=>\q{$V=substr($V,1)}},
         '#ARRAY#'=>[{'DE'=>{'SL'=>"((?:$PtCOMMA)?$PtPPreferredIDValue)"},
           '#CHOICE#'=>[ # 
                   {'ST'=>'SIP:PPreferredIdentityParam'},
           ]}
         ],
      },

     ],
 },

# PPreferredID-value   = name-addr / addr-spec
# $PtPPreferredIDValue = qq{(?:$PtNameAddr|$PtAddrSpec)};
 {'##'=>'SIP:PPreferredIdentityParam','#Name#'=>'PPreferredIdentityParam',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtPPreferredIDValue",
           'SL'=>"(^(?:$PtCOMMA)?$PtPPreferredIDValue?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'addr',
       'DE'=>{'TY'=>'match',
              'MT'=>"(?:$PtCOMMA)?((?:$PtPPreferredIDValue))",
              'SL'=>"((?:$PtPPreferredIDValue))"},
       'EN'=>{'TY'=>'str','AC'=>\q{','.$V}},
         '#CHOICE#'=>[
           {'ST'=>'SIP:NameAddr'},
           {'ST'=>'SIP:AddrSpec'}]},

     ],
 },

# RAck    =  "RAck" HCOLON response-num LWS CSeq-num LWS Method
# $PtRAck = qq{(?i:RAck)$PtHCOLON$PtResponseNum$PtLWS$PtCSeqNum$PtLWS$PtMethod};
 {'##'=>'SIP:RAck','#Name#'=>'RAck', 
  '#TX#'=>{'MT'=>"^$PtRAck(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:RAck:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtRAck(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:RAck)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'responsenum',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtResponseNum)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'cseqnum', 
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtCSeqNum)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'method',
       'DE'=>{'TY'=>'match',
               'MT'=>"($PtMethod)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# RSeq    = "RSeq" HCOLON response-num
# $PtRSeq = qq{(?i:RSeq)$PtHCOLON$PtResponseNum};
 {'##'=>'SIP:RSeq','#Name#'=>'RSeq',
  '#TX#'=>{'MT'=>"^$PtRSeq(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:RSeq:)(?:.*)$PtCRLF",
           'SL'=>"(^$PtRSeq(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:RSeq)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'responsenum',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtResponseNum)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# Referred-By = ("Referred-By" / "b") HCOLON referrer-uri *(SEMI (referredby-id-param / generic-param) )
# $PtReferredBy = qq{(?i:Referred-By|b)$PtHCOLON$PtReferrerUri($PtSEMI(?:$PtReferredByIdParam|$PtGerericParam))*};
 {'##'=>'SIP:Referred-By','#Name#'=>'Referred-By',
  '#TX#'=>{'MT'=>"^$PtReferredBy(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Referred-By:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtReferredBy(?:$PtCRLF)?)\$",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Referred-By|b)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'addr',
       # $PtAddrSpec
       'DE'=>{'SL'=>"((?:$PtNameAddr|(?:(?i:sip:)|(?i:sips:))(?:$PtUserinfo)?$PtHostport))"},
       'EN'=>{'TY'=>'str','AC'=>\q{','.$V}},
         '#CHOICE#'=>[
           {'ST'=>'SIP:NameAddr'},
           {'ST'=>'SIP:AddrSpec'}]},

      {'NM'=>'ref-params',
       'DE'=>{'SL'=>"((?:$PtSEMI(?:$PtReferredByIdParam|$PtGerericParam))*)"},
        '#CHOICE#'=>[{'ST'=>'SIP:ReferredByParams'}], },

     ],
 },

 {'##'=>'SIP:ReferredByParams','#Name#'=>'ReferredByParams',
  '#TX#'=>{'MT'=>"(?:$PtSEMI(?:$PtReferredByIdParam|$PtGerericParam))*\$",
	   'SL'=>"((?:$PtSEMI(?:$PtReferredByIdParam|$PtGerericParam))*\$)"},
  'field'=>
     [

      {'NM'=>'list',
        '#ARRAY#'=>[{'DE'=>{'SL'=>"$PtSEMI((?:$PtReferredByIdParam|$PtGerericParam))"},
        '#CHOICE#'=>[
          {'ST'=>'SIP:CID'},
          {'ST'=>'SIP:GenericParam'}], }], },


     ],
 },

# sip-clean-msg-id = LDQUOT dot-atom "@" (dot-atom / host) RDQUOT
# $PtReferredByIdParam = qq{(?:cid)$PtEQUAL$PtSipCleanMsgId};
 {'##'=>'SIP:CID','#Name#'=>'CID',
  '#TX#'=>{'MT'=>"^$PtReferredByIdParam\$",'SL'=>"(^$PtReferredByIdParam\$)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:cid))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'cid',
       'DE'=>{'TY'=>'match','MT'=>"($PtSipCleanMsgId)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# Event             =  ( "Event" / "o" ) HCOLON event-type *( SEMI event-param )
# $PtEvent            = qq{(?i:Event|o)$PtHCOLON$PtEventType(?:$PtSEMI$PtEventParam)*};
 {'##'=>'SIP:Event','#Name#'=>'Event',
  '#TX#'=>{'MT'=>"^$PtEvent(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Event:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtEvent(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Event|o)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'eventtype',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtToken)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtGenericParam)*)"},
       '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtGenericParam)"},
           '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}]}
       ],
      },
     ],
 },

# Allow-Events =  ( "Allow-Events" / "u" ) HCOLON event-type *(COMMA event-type)
# $PtAllowEvents      = qq{(?i:Allow-Events|u)$PtHCOLON$PtEventType(?:$PtCOMMA$PtEventParam)*};
 {'##'=>'SIP:Allow-Events','#Name#'=>'Allow-Events',
  '#TX#'=>{'MT'=>"^$PtAllowEvents(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Allow-Events:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtAllowEvents(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Allow-Events|u)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'eventtype',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtToken)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtCOMMA$PtEventParam)*)"},
       '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtEventParam)"},
           '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}]}
       ],
      },
     ],
 },

 {'##'=>'SIP:EventReason','#Name#'=>'Reason',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?(?:(?i:reason)$PtEQUAL$PtEventReasonValue)",
           'SL'=>"(^(?:$PtSEMI)?(?:(?i:reason)$PtEQUAL$PtEventReasonValue))",},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:reason))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'reason',
       'DE'=>{'TY'=>'match','MT'=>"($PtEventReasonExtension)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

 {'##'=>'SIP:DeltaSeconds','#Name#'=>'Delta',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?(?:(?i:expires)$PtEQUAL$PtDeltaSeconds)",
           'SL'=>"(^(?:$PtSEMI)?(?:(?i:expires)$PtEQUAL$PtDeltaSeconds))",},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:expires))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'expires',
       'DE'=>{'TY'=>'match','MT'=>"($PtDeltaSeconds)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },

 {'##'=>'SIP:RetryAfter','#Name#'=>'Retry',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?(?:(?i:retry-after)$PtEQUAL$PtDeltaSeconds)",
           'SL'=>"(^(?:$PtSEMI)?(?:(?i:retry-after)$PtEQUAL$PtDeltaSeconds))",},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:retry-after))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'retry',
       'DE'=>{'TY'=>'match','MT'=>"($PtDeltaSeconds)"},
       'EN'=>{'TY'=>'str'}},
     ],
 },


# Subscription-State= "Subscription-State" HCOLON substate-value *( SEMI subexp-params )
# $PtSubscriptionState= qq{(?i:Subscription-State)$PtHCOLON$PtSubstateValue(?:$PtSEMI$PtSubexpParams)*};
 {'##'=>'SIP:Subscription-State','#Name#'=>'Subscription-State',
  '#TX#'=>{'MT'=>"^$PtSubscriptionState(?:$PtSP|$PtCRLF)*\$",'MM'=>"^(?i:Subscription-State:)(?:.*)$PtCRLF",
	   'SL'=>"(^$PtSubscriptionState(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:Subscription-State)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'substate',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtToken)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'params',
       'DE'=>{'SL'=>"((?:$PtSEMI$PtGenericParam)*)"},
       '#ARRAY#'=>[
           {'DE'=>{'SL'=>"($PtGenericParam)"},
           '#CHOICE#'=>[{'ST'=>'SIP:EventReason'},
			{'ST'=>'SIP:DeltaSeconds'},
			{'ST'=>'SIP:RetryAfter'},
			{'ST'=>'SIP:GenericParam'},]}
       ],
      },
     ],
 },

 {'##'=>'SIP:Unknown','#Name#'=>'Unknown',
  '#TX#'=>{'MT'=>"^$PtToken",
           'SL'=>"(^$PtToken$PtHCOLON(?:[^\x0D\x0A]*)(?:$PtCRLF)?)",'AC'=>'oneline'},
  'field'=>
     [
      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtToken)$PtHCOLON)",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'val',
       'DE'=>{'TY'=>'match','MT'=>'([^\x0D\x0A]*)',
	      'AC'=>sub{my($hexSt,$name)=@_;$hexSt->{ [split(':',$hexSt->{'tag'})]->[0] }=$name;}
	  },
       'EN'=>{'TY'=>'str'}},
     ],
 },

#======================
# 
#======================
 {'##'=>'SIP:Body',
  '#Name#'=>'BD', 
  '#TX#'=>{
      'SL'=>"(^(?:(?:.+)(?:$PtCRLF)?)+)",
  },
  'field'=>
     [

      {'NM'=>'bodys',
       '#ARRAY#'=>[{ # 
	  '#CHOICE#'=>[ # 
	    {'ST'=>'SIP:v='},
	    {'ST'=>'SIP:o='},
	    {'ST'=>'SIP:s='},
	    {'ST'=>'SIP:i='},
	    {'ST'=>'SIP:u='},
	    {'ST'=>'SIP:e='},
	    {'ST'=>'SIP:p='},
	    {'ST'=>'SIP:c='},
	    {'ST'=>'SIP:b='},
	    {'ST'=>'SIP:t='},
	    {'ST'=>'SIP:k='},
	    {'ST'=>'SIP:a='},
	    {'ST'=>'SIP:m='},
	    {'ST'=>'SIP:?='},
           ]
        }],

      },
     ]
  },

# proto-version   = "v=" 1*DIGIT CRLF
# $PtProtoVersion = qq{(?i:v)=(?:$PtDigit)+$PtCRLF};
 {'##'=>'SIP:v=','#Name#'=>'v=',
  '#TX#'=>{'MT'=>"^$PtProtoVersion",'MM'=>"^(?i:v)=(?:.*)$PtCRLF",'SL'=>"^($PtProtoVersion)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:v=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'version',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtDigit)+)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# origin-field   = "o=" username space sess-id space sess-version space nettype space addrtype space addr CRLF
# $PtOriginField = qq{(?i:o)=$PtSafeUsername$PtSpace$PtSessId$PtSpace$PtSessVersion$PtSpace$PtNetType$PtSpace$PtAddrType$PtSpace$PtAddr$PtCRLF};
 {'##'=>'SIP:o=','#Name#'=>'o=',
  '#TX#'=>{'MT'=>"^$PtOriginField",'MM'=>"^(?i:o)=(?:.*)$PtCRLF",'SL'=>"(^$PtOriginField)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:o=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'username',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtSafe)+)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'sessid',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtSessId)+)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'sessver',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtSessVersion)+)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'nettype',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtNetType)+)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'addrtype',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtAddrType)+)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'addr',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtAddr)+)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# session-name-field  = "s=" text CRLF
# $PtSessionNameField = qq{(?i:s)=(?:$PtText$PtCRLF)};
 {'##'=>'SIP:s=','#Name#'=>'s=',
  '#TX#'=>{'MT'=>"^$PtSessionNameField",'MM'=>"^(?i:s)=(?:.*)$PtCRLF",'SL'=>"(^$PtSessionNameField)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:s=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'sessname',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtText))"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# information-field   = ["i=" text CRLF]
# $PtInformationField = qq{(?i:i)=(?:$PtText$PtCRLF)};
 {'##'=>'SIP:i=','#Name#'=>'i=',
  '#TX#'=>{'MT'=>"^$PtInformationField",'MM'=>"^(?i:i)=(?:.*)$PtCRLF",'SL'=>"(^$PtInformationField)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:i=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'info',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtText))"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# uri-field   = ["u=" uri CRLF]
# $PtUriField = qq{(?i:u)=(?:$PtURI$PtCRLF)};
 {'##'=>'SIP:u=','#Name#'=>'u=',
  '#TX#'=>{'MT'=>"^$PtUriField",'MM'=>"^(?i:u)=(?:.*)$PtCRLF",'SL'=>"(^$PtUriField)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:u=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'ad',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtURI))"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# email-fields   = *("e=" email-address CRLF)
# $PtEmailFields = qq{(?i:e)=(?:$PtEmailAddress$PtCRLF)};
 {'##'=>'SIP:e=','#Name#'=>'e=',
  '#TX#'=>{'MT'=>"^$PtEmailFields",'MM'=>"^(?i:e)=(?:.*)$PtCRLF",},
  'field'=>
     [

      {'NM'=>'email-field',
       'DE'=>{'SL'=>"((?:$PtEmailFields*))"},
         '#ARRAY#'=>[{
            'DE'=>{'SL'=>"((?:$PtEmailFields))"},
            '#CHOICE#'=>[ # 
                {'ST'=>'SIP:EmailField01'},
                {'ST'=>'SIP:EmailField02'},
                {'ST'=>'SIP:EmailField03'},
            ]
        }],
      },

    ],
 },

# email-field[01] = "e=" email "(" email-safe ")" CRLF
 {'##'=>'SIP:EmailField01','#Name#'=>'EmailField01',
  '#TX#'=>{'MT'=>"^(?i:e)=$PtEmail(?:$PtSpace)*\\\($PtEmailSafe\\\)$PtCRLF",
           'SL'=>"(^(?i:e)=$PtEmail(?:$PtSpace)*\\\($PtEmailSafe\\\)$PtCRLF)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:e=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'mail',
       'EN'=>{'TY'=>'str','AC'=>\q{$V.' '}},
       '#CHOICE#'=>[{'ST'=>'SIP:Email'}]},

      {'NM'=>'etc',
       'DE'=>{'TY'=>'match','MT'=>"(?:$PtSpace)*\\\(((?:$PtEmailSafe))\\\)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{"(".$V.")"} }},

     ],
 },

# email-field[02] = "e=" email-safe "<" email ">" CRLF
 {'##'=>'SIP:EmailField02','#Name#'=>'EmailField02',
  '#TX#'=>{'MT'=>"^(?i:e)=$PtEmailSafe<$PtEmail>$PtCRLF",
           'SL'=>"(^(?i:e)=$PtEmailSafe<$PtEmail>$PtCRLF)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:e=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'etc',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtEmailSafe))"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'mail',
       'DE'=>{'SL'=>"($PtEmail)"},'#CHOICE#'=>[{'ST'=>'SIP:Email'}],
       'EN'=>{'TY'=>'str','AC'=>\q{'<'.$V.'>'}}},

     ],
 },

# email-field[03] = "e=" email CRLF
 {'##'=>'SIP:EmailField03','#Name#'=>'EmailField03',
  '#TX#'=>{'MT'=>"^(?i:e)=$PtEmail$PtCRLF",
           'SL'=>"(^(?i:e)=$PtEmail$PtCRLF)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:e=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'mail',
        '#CHOICE#'=>[{'ST'=>'SIP:Email'}]},

     ],
 },

# mail = [ [ userinfo "@" ] hostport ]
 {'##'=>'SIP:Email','#Name#'=>'Email',
  '#TX#'=>{'MT'=>"^$PtEmail",'SL'=>"(^$PtEmail)"},
  'field'=>
     [

       {'NM'=>'userinfo',
        'DE'=>{'TY'=>'match','MT'=>"$PtUserinfo"},
         '#CHOICE#'=>[ {'ST'=>'SIP:Userinfo'} ]
       },

      {'NM'=>'port',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtHostport))"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# phone-fields   = *("p=" phone-number CRLF)
# $PtPhoneFields = qq{(?i:p)=(?:$PtPhoneNumber$PtCRLF)};
 {'##'=>'SIP:p=','#Name#'=>'p=',
  '#TX#'=>{'MT'=>"^$PtPhoneFields",'MM'=>"^(?i:p)=(?:.*)$PtCRLF"},
  'field'=>
     [

      {'NM'=>'phone-field',
       'DE'=>{'SL'=>"((?:$PtPhoneFields)*)"},
         '#ARRAY#'=>[{ # 
           'DE'=>{'SL'=>"((?:$PtPhoneFields))"},
             '#CHOICE#'=>[ # 
               {'ST'=>'SIP:PhoneField01'},
               {'ST'=>'SIP:PhoneField02'},
               {'ST'=>'SIP:PhoneField03'},
             ],
        }],
      },

    ],
 },

# phone-field[01] = *("p=" phone "(" email-safe ")" CRLF)
 {'##'=>'SIP:PhoneField01','#Name#'=>'PhoneField01',
  '#TX#'=>{'MT'=>"^(?i:p)=$PtPhone\\\($PtEmailSafe\\\)$PtCRLF",
           'SL'=>"(^(?i:p)=$PtPhone\\\($PtEmailSafe\\\)$PtCRLF)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:p=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'phone',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtPhone))"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'etc',
       'DE'=>{'TY'=>'match',
              'MT'=>"(?:$PtSpace)*\\\(((?:$PtEmailSafe))\\\)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{"(".$V.")"} }},

     ],
 },

# phone-field[02] = *("p=" email-safe "<" phone ">" CRLF)
 {'##'=>'SIP:PhoneField02','#Name#'=>'PhoneField02',
  '#TX#'=>{'MT'=>"^(?i:p)=$PtEmailSafe<$PtPhone>$PtCRLF",
           'SL'=>"(^(?i:p)=$PtEmailSafe<$PtPhone>$PtCRLF)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:p=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'etc',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtEmailSafe))"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'phone',
       'DE'=>{'TY'=>'match','MT'=>"(((?:$PtPhone)))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'<'.$V.'>'}}},

     ],
 },

# phone-field[03] = *("p=" phone CRLF)
 {'##'=>'SIP:PhoneField03','#Name#'=>'PhoneField03',
  '#TX#'=>{'MT'=>"^(?i:p)=$PtPhone$PtCRLF",
           'SL'=>"(^(?i:p)=$PtPhone$PtCRLF)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:p=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'phone',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtPhone))"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# connection-field   = ["c=" nettype space addrtype space connection-address CRLF]
# $PtConnectionField = qq{(?i:c)=(?:$PtNetType$PtSpace$PtAddrType$PtSpace$PtConnectionAddress$PtCRLF)};
 {'##'=>'SIP:c=','#Name#'=>'c=',
  '#TX#'=>{'MT'=>"^$PtConnectionField",'MM'=>"^(?i:c)=(?:.*)$PtCRLF",'SL'=>"(^$PtConnectionField)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:c=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'nettype',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtNetType)+)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'addrtype',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtAddrType)+)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'addr',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtConnectionAddress)+)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# bandwidth-fields   = *("b=" bwtype ":" bandwidth CRLF)
# $PtBandwidthFields = qq{(?i:b)=$PtBwtype:$PtBandwidth$PtCRLF};
 {'##'=>'SIP:b=','#Name#'=>'b=',
  '#TX#'=>{'MT'=>"^$PtBandwidthFields",'MM'=>"^(?i:b)=(?:.*)$PtCRLF",},
  'field'=>
     [

      {'NM'=>'bandwith-field',
       'DE'=>{'SL'=>"((?:$PtBandwidthFields)*)"},
         '#ARRAY#'=>[{ # 
           'DE'=>{'SL'=>"((?:$PtBandwidthFields))"},
           '#CHOICE#'=>[ # 
              {'ST'=>'SIP:BandwithField'},
           ],}
        ]},

     ],
 },

# bandwith-field = ("b=" bwtype ":" bandwidth CRLF)
 {'##'=>'SIP:BandwithField','#Name#'=>'BandwithField', 
  '#TX#'=>{'MT'=>"^$PtBandwidthFields",
           'SL'=>"(^$PtBandwidthFields)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:b=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'bwtype',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtBwtype))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V.':'}}},

      {'NM'=>'bandwidth',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtBandwidth))"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# time-fields   = 1*( "t=" start-time space stop-time *(CRLF repeat-fields) CRLF) [zone-adjustments CRLF]
# $PtTimeFields = qq{(?:(?i:t)=(?:$PtStartTime$PtSpace$PtStopTime(?:$PtCRLF$PtRepeatFields)*$PtCRLF))+(?:$PtZoneAdjustments$PtCRLF)?};
 {'##'=>'SIP:t=','#Name#'=>'t=',
  '#TX#'=>{'MT'=>"^$PtTimeFields",'MM'=>"^(?i:t)=(?:.*)$PtCRLF(?:(?i:r)=(?:.*)$PtCRLF)*(?:(?i:z)=(?:.*)$PtCRLF)?",
	   'SL'=>"(^$PtTimeFields)"},
  'field'=>
     [

      {'NM'=>'times',
       'DE'=>{'SL'=>"((?:(?i:t)=(?:$PtStartTime$PtSpace$PtStopTime(?:$PtCRLF$PtRepeatFields)*$PtCRLF))+)"},
       '#ARRAY#'=>[{
         '#CHOICE#'=>[
           {'ST'=>'SIP:TimeUnit'},
         ]
       }],
      },

      {'NM'=>'zone',
       'DE'=>{'SL'=>"((?:$PtZoneAdjustments))"},
       '#ARRAY#'=>[{
         '#CHOICE#'=>[
           {'ST'=>'SIP:z='},
         ]
       }],
      },

    ],
 },

# times = "t=" start-time space stop-time *(CRLF repeat-fields) CRLF
 {'##'=>'SIP:TimeUnit','#Name#'=>'TimeUnit', 
  '#TX#'=>{'MT'=>"(?:(?i:t)=(?:$PtStartTime$PtSpace$PtStopTime(?:$PtCRLF$PtRepeatFields)*$PtCRLF))",
           'SL'=>"^((?:(?i:t)=(?:$PtStartTime$PtSpace$PtStopTime(?:$PtCRLF$PtRepeatFields)*$PtCRLF)))"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:t=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'start-time',
       'DE'=>{'TY'=>'match',
       'MT'=>"((?:$PtStartTime)+)"},'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'stop-time',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtStopTime)+)"},'EN'=>{'TY'=>'str'}},

      {'NM'=>'repeat-fields',
       'DE'=>{'SL'=>"(?:$PtCRLF)?((?:$PtRepeatFields(?:$PtCRLF)?)*)"},
       '#ARRAY#'=>[{
           '#CHOICE#'=>[
               {'ST'=>'SIP:r='},
           ]
       }],
      },

     ],
 },

# repeat-fields   = "r=" repeat-interval space typed-time 1*(space typed-time)
# $PtRepeatFields = qq{(?i:r)=(?:$PtRepeatInterval$PtSpace$PtTypedTime(?:$PtSpace$PtTypedTime)*)};
 {'##'=>'SIP:r=','#Name#'=>'r=',
  '#TX#'=>{'MT'=>"^$PtRepeatFields",'MM'=>"^(?i:r)=(?:.*)$PtCRLF",'SL'=>"^($PtRepeatFields(?:$PtCRLF)?)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:r=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'interval',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtRepeatInterval))"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'typedtime',
       'DE'=>{'TY'=>'match',
              'MT'=>"$PtSpace((?:$PtTypedTime))"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'typedtimes',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtTypedTime(?:$PtSpace$PtTypedTime)*))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{length($V)>0?(" ".$V):("");}}},

     ],
 },

# zone = "z=" time space ["-"] typed-time *(space time space ["-"] typed-time)  ;; add "z="
# $PtZoneAdjustments = qq{(?:(?i:z)=$PtTime$PtSpace(?:-)?$PtTypedTime(?:$PtSpace$PtTime$PtSpace(?:-)?$PtTypedTime)*)};
 {'##'=>'SIP:z=','#Name#'=>'z=',
  '#TX#'=>{'MT'=>"^$PtZoneAdjustments",'MM'=>"^(?i:z)=(?:.*)$PtCRLF",
           'SL'=>"(^$PtZoneAdjustments(?:$PtCRLF)?)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:z=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'time',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtTime)+)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'typedtime',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:(?:-)?$PtTypedTime)+)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'typedtimes',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtSpace(?:-)?$PtTypedTime)*)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# key-field   = ["k=" key-type CRLF]
# $PtKeyField = qq{(?i:k)=(?:$PtKeyType$PtCRLF)};
 {'##'=>'SIP:k=','#Name#'=>'k=',
  '#TX#'=>{'MT'=>"^$PtKeyField",'MM'=>"^(?i:k=)(?:.*)$PtCRLF",'SL'=>"(^$PtKeyField)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:k=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'key-type',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtKeyType)+)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# attribute-fields   = *("a=" attribute CRLF)
# $PtAttributeFields = qq{(?i:a)=(?:$PtAttribute$PtCRLF)};
 {'##'=>'SIP:a=','#Name#'=>'a=',
  '#TX#'=>{'MT'=>"^$PtAttributeFields",'MM'=>"^(?i:a=)(?:.*)$PtCRLF"},
  'field'=>
     [

      {'NM'=>'attribute-field',
       'DE'=>{'SL'=>"((?:$PtAttributeFields)*)"},
         '#ARRAY#'=>[{
           'DE'=>{'SL'=>"((?:$PtAttributeFields))"},
           '#CHOICE#'=>[
             {'ST'=>'SIP:AttributeField'},
           ]
         }],
      },

     ],
 },

#attribute-field = "a=" attribute CRLF
 {'##'=>'SIP:AttributeField','#Name#'=>'AttributeField',
  '#TX#'=>{'MT'=>"^$PtAttributeFields",
           'SL'=>"(^$PtAttributeFields)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:a=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'attribute',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtAttribute))"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# media-descriptions   = *( media-field information-field *(connection-field) bandwidth-fields key-field attribute-fields )
# $PtMediaDescriptions = qq{(?:$PtMediaField(?:$PtInformationField)?(?:$PtConnectionField)*(?:$PtBandwidthFields)*(?:$PtKeyField)?(?:$PtAttributeFields)*)};
 {'##'=>'SIP:m=','#Name#'=>'m=',
  '#TX#'=>{'MT'=>"^$PtMediaDescriptions",'MM'=>"^(?i:m=)(?:.*)$PtCRLF"},
  'field'=>
     [

      {'NM'=>'media-part',
       'DE'=>{'SL'=>"(($PtMediaDescriptions)+)"},
         '#ARRAY#'=>[{
           '#CHOICE#'=>[
               {'ST'=>'SIP:MediaDescriptions'},
           ]
         }],
      },

     ],
 },

# 
# media-part media-field information-field *(connection-field) bandwidth-fields key-field attribute-fields
 {'##'=>'SIP:MediaDescriptions','#Name#'=>'MediaDescriptions',
  '#TX#'=>{'MT'=>"^$PtMediaDescriptions",'SL'=>"^($PtMediaDescriptions)"},
  'field'=>
     [
      {'NM'=>'media-field',
       'DE'=>{'SL'=>"($PtMediaField)"},
         '#CHOICE#'=>[
           {'ST'=>'SIP:MediaField'},
         ]
      },

      {'NM'=>'descriptions',
       'DE'=>{'SL'=>"((?:$PtInformationField)?(?:$PtConnectionField)*(?:$PtBandwidthFields)*(?:$PtKeyField)?(?:$PtAttributeFields)*)"},
         '#ARRAY#'=>[{
           '#CHOICE#'=>[
             {'ST'=>'SIP:i='},
             {'ST'=>'SIP:c='},
             {'ST'=>'SIP:b='},
             {'ST'=>'SIP:k='},
             {'ST'=>'SIP:a='},
           ]
        }],
      },

     ],
 },

# media-field   = "m=" media space port ["/" integer] space proto 1*(space fmt) CRLF
# $PtMediaField = qq{(?i:m)=(?:$PtMedia$PtSpace$PtPort(?:/$PtInteger)?$PtSpace$PtProto(?:$PtSpace$PtFmt)+$PtCRLF)};
 {'##'=>'SIP:MediaField','#Name#'=>'MediaField',
  '#TX#'=>{'MT'=>"^$PtMediaField", 'SL'=>"(^$PtMediaField)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:m=))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'media',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtMedia)+)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'port',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtPort)+)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'int',
       'DE'=>{'TY'=>'match','MT'=>"/((?:$PtInteger)?)$PtSpace"},
       'EN'=>{'TY'=>'str','AC'=>\\q{length($V)>0?("/".$V):("");}}},

      {'NM'=>'proto',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtProto)+)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{" ".$V}}},

      {'NM'=>'fmt',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtFmt(?:$PtSpace$PtFmt)*))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{length($V)>0?(" ".$V):("");}}},

     ],
 },

# SDP unknown-field   = ["XXX=" text CRLF]
 {'##'=>'SIP:?=','#Name#'=>'Unknown',
#  '#TX#'=>{'MT'=>"^(?:.+)=(?:$PtText$PtCRLF)",'MM'=>"^(?:.+)=(?:.*)$PtCRLF",'SL'=>"(^(?:.+)=(?:$PtText$PtCRLF))"},
  '#TX#'=>{'MT'=>"^$PtCRLF",'MM'=>"^(?:.+)$PtCRLF",'SL'=>"(^(?:.+)(?:$PtText$PtCRLF))"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?:\\w+\\W))",'RT'=>'T'},
       'EN'=>{'TY'=>'str','AC'=>\\q{"\\r\\n".$V}}},

      {'NM'=>'val',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:.*))"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# SDP XML
 {'##'=>'XML','#Name#'=>'xml',
  '#TX#'=>{'SL'=>'^([\S\s]*)','MT'=>''},
  'field'=>
     [
      {'NM'=>'txt',
       'DE'=>{'TY'=>'any','SZ'=>'REST','AC'=>sub{my($hexSt,$xml)=@_;$hexSt->{'xml'}=XMLHexDEcode($xml);}}},
     ],
 },
 {'##'=>'UNSDP','#Name#'=>'bd',
  '#TX#'=>{'SL'=>'([\S\s]*)','MT'=>''},
  'field'=>
     [
      {'NM'=>'txt',
       'DE'=>{'TY'=>'any','SZ'=>'REST'}},
     ],
 },


#======================
# 
#======================
# Method   =  INVITEm / ACKm / OPTIONSm / BYEm / CANCELm / REGISTERm
# $PtMethod   = qq{(?:(?-i:INVITE|ACK|OPTIONS|BYE|CANCEL|REGISTER|SUBSCRIBE|NOTIFY|REFER|PRACK)|$PtExtensionMethod)};;
 {'##'=>'SIP:Method','#Name#'=>'Method',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtMethod",
           'SL'=>"(^(?:$PtCOMMA)?$PtMethod)"},
  'field'=>
     [

      {'NM'=>'method',
       'DE'=>{'TY'=>'match','MT'=>"($PtMethod)"},
       'EN'=>{'TY'=>'comma+str'}},

     ],
 },

# generic-param   = token [ EQUAL gen-value ]
# $PtGenericParam = qq{$PtToken(?:$PtEQUAL$PtGenValue)?};
 {'##'=>'SIP:GenericParam','#Name#'=>'GenericParam',
  '#TX#'=>{'MT'=>"^$PtGenericParam",'SL'=>"(^$PtGenericParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"($PtToken)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'generic',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtGenValue)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# refresher-param   = 'refresher' EQUAL  ('uas' / 'uac')
# $PtRefresherParam = qq{(?:(?i:refresher)$PtEQUAL(?i:uas|uac))};
 {'##'=>'SIP:RefresherParam','#Name#'=>'RefresherParam',
  '#TX#'=>{'MT'=>"^$PtRefresherParam",
           'SL'=>"(^$PtRefresherParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:refresher))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'refresher',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:uas|uac))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# tag-param   = "tag" EQUAL token
# $PtTagParam = qq{(?:(?i:tag)$PtEQUAL$PtToken)};
 {'##'=>'SIP:TagParam','#Name#'=>'TagParam',
  '#TX#'=>{'MT'=>"^$PtTagParam",'SL'=>"(^$PtTagParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:tag))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'tag-id',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtToken)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# addr-spec   = SIP-URI / SIPS-URI / absoluteURI
# $PtAddrSpec = qq{(?:$PtSIPUri|$PtSIPSUri|$PtAbsoluteUri)};
 {'##'=>'SIP:AddrSpec','#Name#'=>'AddrSpec',
  '#TX#'=>{'MT'=>"^$PtAddrSpec",'SL'=>"(^$PtAddrSpec)"},
  'field'=>
     [

      {'NM'=>'uri',
       '#CHOICE#'=>[
        {'ST'=>'SIP:SIPUri'},
        {'ST'=>'SIP:SIPSUri'},
        {'ST'=>'SIP:AbsoluteUri'}
     ]},

     ],
 },

# name-addr   = [ display-name ] LAQUOT addr-spec RAQUOT
# $PtNameAddr = qq{(?:$PtDisplayName)?$PtLAQUOT$PtAddrSpec$PtRAQUOT};
 {'##'=>'SIP:NameAddr','#Name#'=>'NameAddr',
  '#TX#'=>{'MT'=>"^$PtNameAddr",'SL'=>"(^$PtNameAddr)"},
  'field'=>
     [

      {'NM'=>'display',
       'DE'=>{'TY'=>'match',
              'MT'=>"^($PtDisplayName)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'uri',
#       'DE'=>{'AC'=>\q{$HXpkt =~ s/$PtLAQUOT($PtAddrSpec)$PtRAQUOT/$1/},},
       'DE'=>{'AC'=>\q{$HXpkt =~ /$PtLAQUOT($PtAddrSpec)$PtRAQUOT/;$HXpkt=$1},},
       'EN'=>{'AC'=>\q{'<'.$V.'>'}},
         '#CHOICE#'=>[
           {'ST'=>'SIP:SIPUri'},
           {'ST'=>'SIP:SIPSUri'},
           {'ST'=>'SIP:AbsoluteUri'}
      ]},

     ],
 },

# via-parm   = sent-protocol LWS sent-by *( SEMI via-params )
# $PtViaParm = qq{$PtSentProtocol$PtLWS$PtSentBy(?:$PtSEMI$PtViaParams)*};
 {'##'=>'SIP:ViaParm','#Name#'=>'ViaParm',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtViaParm",
           'SL'=>"(^(?:$PtCOMMA)?$PtViaParm)"},
  'field'=>
     [

#       {'NM'=>'proto',
#        'DE'=>{'TY'=>'match',
#               'MT'=>"($PtSentProtocol)"},
#        'EN'=>{'TY'=>'comma+str+sp'}},

      {'NM'=>'protoname',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtProtocolName)"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'version',
       'DE'=>{'TY'=>'match',
              'MT'=>"/($PtProtocolVersion)/"},
       'EN'=>{'TY'=>'str','AC'=>\\q{"/".$V."/"}}},

      {'NM'=>'transport',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtTransport)"},
       'EN'=>{'TY'=>'str+sp'}},

      {'NM'=>'sentby',
       'DE'=>{'SL'=>"(($PtSentBy))"},
        '#CHOICE#'=>[{'ST'=>'SIP:Sent-By'}]},

      {'NM'=>'params', 
       'DE'=>{'SL'=>"(^(?:$PtSEMI$PtViaParams)*)\$",
              'TY'=>'match',
              'MT'=>"^(?:$PtSEMI$PtViaParams)*"}, 
       'EN'=>{'TY'=>'str'},
          '#CHOICE#'=>[{'ST'=>'SIP:ViaParms'}],
      },

     ],
 },

# via-params   =  via-ttl / via-maddr / via-received / via-branch / via-extension
# $PtViaParams = qq{(?:$PtViaTtl|$PtViaMaddr|$PtViaReceived|$PtViaBranch|$PtViaExtension)};
 {'##'=>'SIP:ViaParms','#Name#'=>'ViaParms',
  '#TX#'=>{'SL'=>"(^(?:$PtSEMI$PtViaParams)*)\$",
           'MT'=>"^(?:$PtSEMI$PtViaParams)*"},
  'field'=>[

    {'NM'=>'list', 
     'DE'=>{'SL'=>"(^(?:$PtSEMI$PtViaParams)*)\$",
            'TY'=>'match','MT'=>"^(?:$PtSEMI$PtViaParams)*"},
      '#ARRAY#'=>[{
	  'DE'=>{'SL'=>"($PtSEMI$PtViaParams)".'(?=\s*(?:;|\z))'},
	  '#CHOICE#'=>[
            {'ST'=>'SIP:ViaTtl'},
            {'ST'=>'SIP:ViaMaddr'},
            {'ST'=>'SIP:ViaReceived'},
            {'ST'=>'SIP:ViaBranch'},
            {'ST'=>'SIP:ViaExtension'},
          ],
      },],
    },

  ],
 },

# sent-by   =  host [ COLON port ]
# $PtSentBy = qq{$PtHost(?:$PtCOLON$PtPort)?};
 {'##'=>'SIP:Sent-By','#Name#'=>'Sent-By',
  '#TX#'=>{'MT'=>"^$PtSentBy",
           'SL'=>"(^$PtSentBy)",'AC'=>'oneline'},
  'field'=>
     [

      {'NM'=>'host',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtHost))"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'port',
       'DE'=>{'TY'=>'match',
              'MT'=>"$PtCOLON((?:$PtPort)?)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{($V ne '')?(':'.$V):('')}}},

     ],
 },

# via-ttl   = "ttl" EQUAL ttl
# $PtViaTtl = qq{(?i:ttl)$PtEQUAL$PtTtl};
 {'##'=>'SIP:ViaTtl','#Name#'=>'ViaTtl',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?(?i:ttl)$PtEQUAL$PtTtl", 'SL'=>"^(?:$PtSEMI)?((?i:ttl)$PtEQUAL$PtTtl)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:ttl))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'ttl',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtTtl)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

 {'##'=>'SIP:ViaMaddr','#Name#'=>'ViaMaddr',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?(?i:maddr)$PtEQUAL$PtHost",'SL'=>"^(?:$PtSEMI)?((?i:maddr)$PtEQUAL$PtHost)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:maddr))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'host',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtHost)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

 {'##'=>'SIP:ViaReceived','#Name#'=>'ViaReceived',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?(?i:received)$PtEQUAL(?:$PtIPv4address|$PtIPv6address)",
       'SL'=>"^(?:$PtSEMI)?((?i:received)$PtEQUAL(?:$PtIPv4address|$PtIPv6address))"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:received))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'addr',
       'DE'=>{'SL'=>"((?:$PtIPv4address|$PtIPv6address))"},
         '#CHOICE#'=>[{'ST'=>'SIP:IPv4address'},
                      {'ST'=>'SIP:IPv6address'}]},

     ],
 },

 {'##'=>'SIP:ViaBranch','#Name#'=>'ViaBranch',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?(?i:branch)$PtEQUAL$PtToken",'SL'=>"^(?:$PtSEMI)?((?i:branch)$PtEQUAL$PtToken)"},
  'field'=>
     [
      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:branch))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V.'='}}},

      {'NM'=>'branch',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtToken)"},
              'EN'=>{'TY'=>'str'}},

     ],
 },

 {'##'=>'SIP:ViaExtension','#Name#'=>'ViaExtension',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtViaExtension",'SL'=>"^(?:$PtSEMI)?($PtViaExtension)"},
  'field'=>
     [
      {'NM'=>'extension',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtGenericParam)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

#----------------------------------------------------------
#
#      {'NM'=>'extension','DE'=>{'SL'=>"(($PtViaExtension))"},
#                         '#CHOICE#'=>[{'ST'=>'SIP:GenericParam'}], },

     ],
 },

 {'##'=>'SIP:IPv4address','#Name#'=>'IPv4address',
  '#TX#'=>{'MT'=>"^$PtIPv4address"},
  'field'=>
     [

      {'NM'=>'ip',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtIPv4address)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

 {'##'=>'SIP:IPv6address','#Name#'=>'IPv6address',
  '#TX#'=>{'MT'=>"^$PtIPv6address\$"},
  'field'=>
     [

      {'NM'=>'ip',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtIPv6address)"},
       'EN'=>{'TY'=>'str'}},

     ],
 },

# $PtSIPUri = qq{sip:(?:$PtUserinfo)?$PtHostport$PtUriParameters(?:$PtHeaders)?};
 {'##'=>'SIP:SIPUri',
  '#Name#'=>'SIPUri',
  '#TX#'=>{'SL'=>"($PtSIPUri\$)",'MT'=>"^$PtSIPUri\$"},  # 
  'field'=>
     [

      {'NM'=>'scheme',
       'DE'=>{'TY'=>'match','MT'=>"((?i:sip)):"},
       'IV'=>{"sip:"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V.":"}}},

      {'NM'=>'userinfo',
       'DE'=>{'TY'=>'match',
              'MT'=>"(?:((?:$PtUser(?::$PtPassword)?))\@)?"},
       'EN'=>{'TY'=>'str','AC'=>\\q{(length($V)>0)?($V."@"):("");}}},

      {'NM'=>'host',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtHost))"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'port',
       'DE'=>{'TY'=>'match','MT'=>"^$PtCOLON((?:$PtPort)?)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{($V ne '')?(':'.$V):('')}}},

      {'NM'=>'params',
       'DE'=>{'SL'=>"(^$PtUriParameters\$)",              # 
              'TY'=>'match','MT'=>"^$PtUriParameters"}, # 
       'EN'=>{'TY'=>'str'},
         '#CHOICE#'=>[{'ST'=>'SIP:UriParameters'}],
      },

      {'NM'=>'headers',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtHeaders))"},
       'EN'=>{'TY'=>'str'}},

     ],
  },

# SIPS-URI   = "sips:" [ userinfo ] hostport uri-parameters [ headers ]
# $PtSIPSUri = qq{sips:(?:$PtUserinfo)?$PtHostport$PtUriParameters(?:$PtHeaders)?};
 {'##'=>'SIP:SIPSUri',
  '#Name#'=>'SIPSUri',
  '#TX#'=>{'SL'=>"($PtSIPSUri)",'MT'=>"^$PtSIPSUri"},
  'field'=>
     [

      {'NM'=>'scheme',
       'DE'=>{'TY'=>'match','MT'=>"((?i:sips)):"},
       'IV'=>{"sips:"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V.":"}}},

      {'NM'=>'userinfo',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtUser(?::$PtPassword)?))\@"},
       'EN'=>{'TY'=>'str','AC'=>\\q{(length($V)>0)?($V."@"):("");}}},

      {'NM'=>'host',
       'DE'=>{'TY'=>'match',
              'MT'=>"^($PtHost)"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'port',
       'DE'=>{'TY'=>'match',
              'MT'=>"^$PtCOLON((?:$PtPort)?)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{($V ne '')?(':'.$V):('')}}},

      {'NM'=>'params',        # 
       'DE'=>{'SL'=>"(^$PtUriParameters\$)",
              'TY'=>'match',
              'MT'=>"^$PtUriParameters"}, # 
       'EN'=>{'TY'=>'str'},
         '#CHOICE#'=>[{'ST'=>'SIP:UriParameters'}],
      },

      {'NM'=>'headers',
       'DE'=>{'TY'=>'match','MT'=>"^($PtHeaders)"},
       'EN'=>{'TY'=>'str'}},
     ],
  },

# absoluteURI     =  scheme ":" ( hier-part / opaque-part )
# $PtAbsoluteUri    = qq{(?:$PtScheme:(?:$PtHierPart|$PtOpaquePart))};
 {'##'=>'SIP:AbsoluteUri',
  '#Name#'=>'AbsoluteUri',
  '#TX#'=>{'SL'=>"($PtAbsoluteUri)",'MT'=>"^$PtAbsoluteUri"},
  'field'=>
     [

      {'NM'=>'scheme',
        'DE'=>{'TY'=>'match',
               'MT'=>"^($PtScheme)"},
        'EN'=>{'TY'=>'str'}},

      {'NM'=>'absolute',
       'DE'=>{'TY'=>'match',
              'MT'=>"^((?:$PtHierPart|$PtOpaquePart))"},
       'EN'=>{'TY'=>'str'}},

     ],
  },

##
# $PtUriParameters  = qq{(?:(?!;tag=);$PtUriParameter)*};
# $PtUriParameter   = qq{(?:$PtTransportParam|$PtUserParam|$PtMethodParam|$PtTtlParam|$PtMaddrParam|$PtLrParam|$PtOtherParam)};
 {'##'=>'SIP:UriParameters','#Name#'=>'UriParameters',
  '#TX#'=>{'SL'=>"(^$PtUriParameters\$)",
           'MT'=>"^$PtUriParameters"}, # 
  'field'=>
      [

      {'NM'=>'list',
       'DE'=>{'SL'=>"(^$PtUriParameters\$)",
              'TY'=>'match','MT'=>"^($PtUriParameters)"},
         '#ARRAY#'=>[{
           '#CHOICE#'=>[
             {'ST'=>'SIP:TransportParam'},
             {'ST'=>'SIP:UserParam'},
             {'ST'=>'SIP:MethodParam'},
             {'ST'=>'SIP:TtlParam'},
             {'ST'=>'SIP:MaddrParam'},
             {'ST'=>'SIP:LrParam'},
             {'ST'=>'SIP:OtherParam'}
           ], },],
       },
      ],
 },

# transport-param   = "transport=" ( "udp" / "tcp" / "sctp" / "tls" / other-transport)
# $PtTransportParam = qq{(?:(?i:transport)=(?:(?i:udp|tcp|sctp|tls)|$PtOtherTransport))};
 {'##'=>'SIP:TransportParam','#Name#'=>'TransportParam',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtTransportParam",
           'SL'=>"^(?:$PtSEMI)?($PtTransportParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>'((?i:transport))'},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'transport',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtOtherTransport))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# user-param   = "user=" ( "phone" / "ip" / other-user)
# $PtUserParam = qq{(?:(?i:user)=(?:(?i:phone|ip)|$PtOtherUser))};
 {'##'=>'SIP:UserParam','#Name#'=>'UserParam',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtUserParam",
           'SL'=>"^(?:$PtSEMI)?($PtUserParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>'((?i:user))'},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'user',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtOtherUser))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# method-param   = "method=" Method
# $PtMethodParam = qq{(?:(?i:method)=$PtMethod)};
 {'##'=>'SIP:MethodParam','#Name#'=>'MethodParam',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtMethodParam",
           'SL'=>"^(?:$PtSEMI)?($PtMethodParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>'((?i:method))'},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'method',
       'DE'=>{'TY'=>'match','MT'=>"($PtMethod)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# ttl-param   = "ttl=" ttl
# $PtTtlParam = qq{(?:(?i:ttl)=$PtTtl)};
 {'##'=>'SIP:TtlParam','#Name#'=>'TtlParam',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtTtlParam",'SL'=>"^(?:$PtSEMI)?($PtTtlParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>'((?i:ttl))'},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'ttl',
       'DE'=>{'TY'=>'match','MT'=>"($PtTtl)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# maddr-param   = "maddr=" host
# $PtMaddrParam = qq{(?i:maddr)=$PtHost};
 {'##'=>'SIP:MaddrParam','#Name#'=>'MaddrParam',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtMaddrParam",
           'SL'=>"^(?:$PtSEMI)?($PtMaddrParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>'((?i:maddr))'},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'maddr',
       'DE'=>{'TY'=>'match','MT'=>"((?:$PtHost))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# lr-param   = "lr"
#   
# $PtLrParam = q{(?i:lr)};
 {'##'=>'SIP:LrParam','#Name#'=>'LrParam',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtLrParam(?:;|\$)",'SL'=>"^(?:$PtSEMI)?($PtLrParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>'((?i:lr))'},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},
     ],

 },

# other-param   = pname [ "=" pvalue ]
# $PtOtherParam = qq{$PtPname(?:=$PtPvalue)?};
 {'##'=>'SIP:OtherParam','#Name#'=>'OtherParam',
  '#TX#'=>{'MT'=>"^(?:$PtSEMI)?$PtOtherParam",'SL'=>"^(?:$PtSEMI)?($PtOtherParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"($PtPname)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{';'.$V}}},

      {'NM'=>'other',
       'DE'=>{'TY'=>'match','MT'=>"($PtPvalue)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},
     ],
 },

# username    = "username" EQUAL username-value
# $PtUserName = qq{(?i:username)$PtEQUAL$PtUserNameValue};
 {'##'=>'SIP:UserName','#Name#'=>'UserName',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtUserName",'SL'=>"(^(?:$PtCOMMA)?$PtUserName)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:username))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'username',
       'DE'=>{'TY'=>'match','MT'=>"(?:$PtSWS\"((?:$PtQdtext|$PtQuotedPair)*)\")"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'="'.$V.'"'}}},

     ],
 },

# realm    = "realm" EQUAL realm-value
# $PtRealm = qq{(?i:realm)$PtEQUAL$PtRealmValue};
 {'##'=>'SIP:Realm','#Name#'=>'Realm',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtRealm",
           'SL'=>"(^(?:$PtCOMMA)?$PtRealm)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:realm))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'realm',
       'DE'=>{'TY'=>'match','MT'=>"(?:$PtSWS\"((?:$PtQdtext|$PtQuotedPair)*)\")"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'="'.$V.'"'}}},

     ],
 },

# nonce    = "nonce" EQUAL nonce-value
# $PtNonce = qq{(?i:nonce)$PtEQUAL$PtNonceValue};
 {'##'=>'SIP:Nonce','#Name#'=>'Nonce',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtNonce",
           'SL'=>"(^(?:$PtCOMMA)?$PtNonce)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:nonce))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'nonce',
       'DE'=>{'TY'=>'match','MT'=>"(?:$PtSWS\"((?:$PtQdtext|$PtQuotedPair)*)\")"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'="'.$V.'"'}}},
     ],
 },

# digest-uri   = "uri" EQUAL LDQUOT digest-uri-value RDQUOT
# $PtDigestUri = qq{(?i:uri)$PtEQUAL$PtLDQUOT$PtDigestUriValue$PtRDQUOT};
 {'##'=>'SIP:DigestUri','#Name#'=>'DigestUri',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtDigestUri",'SL'=>"(^(?:$PtCOMMA)?$PtDigestUri)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:uri))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'uri',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtDigestUriValue)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'='.'"'.$V.'"'}}},
     ],
 },

# dresponse    = "response" EQUAL request-digest
# $PtDresponse = qq{(?i:response)$PtEQUAL$PtRequestDigest};
 {'##'=>'SIP:Dresponse','#Name#'=>'Dresponse',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtDresponse",
           'SL'=>"(^(?:$PtCOMMA)?$PtDresponse)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:response))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'response',
       'DE'=>{'TY'=>'match','MT'=>"(?:$PtSWS\"((?:$PtQdtext|$PtQuotedPair)*)\")"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'='.'"'.$V.'"'}}},

     ],
 },

# algorithm    = "algorithm" EQUAL ( "MD5" / "MD5-sess" / token )
   # 040301 
# $PtAlgorithm = qq{(?i:algorithm)$PtEQUAL(?:(?i:MD5-sess|MD5)|$PtToken)};
 {'##'=>'SIP:Algorithm','#Name#'=>'Algorithm',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtAlgorithm",
           'SL'=>"(^(?:$PtCOMMA)?$PtAlgorithm)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:algorithm))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'algorithm',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtToken))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},
     ],
 },

# cnonce    = "cnonce" EQUAL cnonce-value
# $PtCnonce = qq{(?i:cnonce)$PtEQUAL$PtCnonceValue};
 {'##'=>'SIP:Cnonce','#Name#'=>'Cnonce',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtCnonce",
           'SL'=>"(^(?:$PtCOMMA)?$PtCnonce)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:cnonce))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'cnonce',
       'DE'=>{'TY'=>'match','MT'=>"(?:$PtSWS\"((?:$PtQdtext|$PtQuotedPair)*)\")"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'='.'"'.$V.'"'}}},

     ],
 },

# opaque    = "opaque" EQUAL quoted-string
# $PtOpaque = qq{(?i:opaque)$PtEQUAL$PtQuotedString};
 {'##'=>'SIP:Opaque','#Name#'=>'Opaque',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtOpaque",
           'SL'=>"(^(?:$PtCOMMA)?$PtOpaque)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:opaque))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'opaque',
       'DE'=>{'TY'=>'match','MT'=>"(?:$PtSWS\"((?:$PtQdtext|$PtQuotedPair)*)\")"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'='.'"'.$V.'"'}}},

     ],
 },

# message-qop   = "qop" EQUAL qop-value
# $PtMessageQop = qq{(?i:qop)$PtEQUAL$PtQopValue};
 {'##'=>'SIP:MessageQop','#Name#'=>'MessageQop',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtMessageQop",
           'SL'=>"(^(?:$PtCOMMA)?$PtMessageQop)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:qop))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'qop',
       'DE'=>{'TY'=>'match','MT'=>"($PtQopValue)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# nonce-count   = "nc" EQUAL nc-value
# $PtNonceCount = qq{(?i:nc)$PtEQUAL$PtNcValue};
 {'##'=>'SIP:NonceCount','#Name#'=>'NonceCount',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtNonceCount",
           'SL'=>"(^(?:$PtCOMMA)?$PtNonceCount)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:nc))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'nc',
       'DE'=>{'TY'=>'match','MT'=>"($PtNcValue)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},
     ],
 },

# auth-param   = auth-param-name EQUAL ( token / quoted-string )
# $PtAuthParam = qq{$PtAuthParamName$PtEQUAL(?:$PtToken|$PtQuotedString)};
 {'##'=>'SIP:AuthParam','#Name#'=>'AuthParam',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtAuthParam",
           'SL'=>"(^(?:$PtCOMMA)?$PtAuthParam)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtAuthParamName)"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'auth',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtToken|$PtQuotedString))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},
     ],
 },

# domain    = "domain" EQUAL LDQUOT URI *( 1*SP URI ) RDQUOT
# $PtDomain = qq{(?i:domain)$PtEQUAL$PtLDQUOT$PtURI(?:\s+$PtURI)*$PtRDQUOT};
 {'##'=>'SIP:Domain','#Name#'=>'Domain',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtDomain",
           'SL'=>"(^(?:$PtCOMMA)?$PtDomain)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match','MT'=>"((?i:domain))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'domain',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtURI(?:\s+$PtURI)*)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'='.'"'.$V.'"'}}},

     ],
 },

# stale    = "stale" EQUAL ( "true" / "false" )
# $PtStale = qq{(?i:stale)$PtEQUAL(?i:true|false)};
 {'##'=>'SIP:Stale','#Name#'=>'Stale',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtStale",
           'SL'=>"(^(?:$PtCOMMA)?$PtStale)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:stale))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'stale',
       'DE'=>{'TY'=>'match','MT'=>"((?i:true|false))"},
       'EN'=>{'TY'=>'str','AC'=>\\q{$V ne '' ? '='.$V:''}}},

     ],
 },

# qop-options   = "qop" EQUAL LDQUOT qop-value *("," qop-value) RDQUOT
# $PtQopOptions = qq{(?i:qop)$PtEQUAL$PtLDQUOT$PtQopValue(?:,$PtQopValue)*$PtRDQUOT};
 {'##'=>'SIP:QopOptions','#Name#'=>'QopOptions', 
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtQopOptions",
           'SL'=>"(^(?:$PtCOMMA)?$PtQopOptions)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:qop))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'qop',
       'DE'=>{'TY'=>'match',
              'MT'=>"($PtQopValue(?:,$PtQopValue)*)"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'='.'"'.$V.'"'}}},

     ],
 },

#response-auth    =  "rspauth" EQUAL response-digest
#$PtResponseAuth   = qq{(?i:rspauth)$PtEQUAL$PtResponseDigest};
 {'##'=>'SIP:ResponseAuth','#Name#'=>'ResponseAuth',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtResponseAuth",
           'SL'=>"(^(?:$PtCOMMA)?$PtResponseAuth)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:rspauth))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'rspauth',
       'DE'=>{'TY'=>'match','MT'=>"(?:$PtSWS\"((?:$PtQdtext|$PtQuotedPair)*)\")"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'="'.$V.'"'}}},
     ],
 },

# nextnonce       =  "nextnonce" EQUAL nonce-value
# $PtNextNonce      = qq{(?i:nextnonce)$PtEQUAL$PtNonceValue};
 {'##'=>'SIP:NextNonce','#Name#'=>'NextNonce',
  '#TX#'=>{'MT'=>"^(?:$PtCOMMA)?$PtNextNonce",
           'SL'=>"(^(?:$PtCOMMA)?$PtNextNonce)"},
  'field'=>
     [

      {'NM'=>'tag',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?i:nextnonce))"},
       'EN'=>{'TY'=>'comma+str'}},

      {'NM'=>'nextnonce',
       'DE'=>{'TY'=>'match','MT'=>"(?:$PtSWS\"((?:$PtQdtext|$PtQuotedPair)*)\")"},
       'EN'=>{'TY'=>'str','AC'=>\\q{'="'.$V.'"'}}},
     ],
 },

# userinfo    = ( user / telephone-subscriber ) [ ":" password ] "@"
# $PtUserinfo = qq{(?:(?:$PtUser|$PtTelephoneSubscriber)(?::$PtPassword)?@)};
# $PtUserinfo = qq{(?:$PtUser(?::$PtPassword)?\@)}; 
 {'##'=>'SIP:Userinfo','#Name#'=>'Userinfo',
  '#TX#'=>{'MT'=>"^$PtUserinfo",'SL'=>"(^$PtUserinfo)"},
  'field'=>
     [

      {'NM'=>'user',
       'DE'=>{'TY'=>'match',
              'MT'=>"((?:$PtUser))"},
       'EN'=>{'TY'=>'str'}},

      {'NM'=>'passwd',
       'DE'=>{'TY'=>'match',
              'MT'=>":((?:$PtPassword)?)\@"},
       'EN'=>{'TY'=>'str','AC'=>\\q{length($V)>0?(":".$V."\@"):("\@")} }},

     ],
 },

##TRAILE##
);

# SDP
# v=,o=,s=,i=,u=,e=,p=,c=,b=,t=,k=,a=,m=
%SDPOrder=('v='=>0,'o='=>1,,'s='=>2,'i='=>3,'u='=>4,'e='=>5,'p='=>6,'c='=>6,'b='=>7,'t='=>8,'k='=>9,'a='=>10,'m='=>11,
	   'r='=>-1,'z='=>-1,'?='=>-1);
sub SDPOrderChk {
    my($v)=@_;
    my($tag,$ord);
    unless(ref($v) eq 'ARRAY'){return $v;}
    $ord=0;
    foreach $tag (@$v){
	if($tag->{'##'} != /SIP:/){next;}
	if($ord <= $SDPOrder{$tag->{'#Name#'}}){
	    $ord = $SDPOrder{$tag->{'#Name#'}};
	}
	else{
	    $tag->{'#INVALID#'}='SYNTAX ERROR';
	}
    }
    return $v;
}

# 
sub SIPAddOriginalHeader {
    my($nd)=@_;
    my($list);
    $list=$SIPPacketHexMap[0]->{'field'}->[1]->{'#ARRAY#'}->[0]->{'#CHOICE#'};
    $SIPPacketHexMap[0]->{'field'}->[1]->{'#ARRAY#'}->[0]->{'#CHOICE#'}=[{'ST'=>$nd},@$list];
#    splice(@$list,$#$list-1,1,{'ST'=>$nd});
    $list=$SIPPacketHexMap[3]->{'field'}->[0]->{'#ARRAY#'}->[0]->{'#CHOICE#'};
    $SIPPacketHexMap[3]->{'field'}->[0]->{'#ARRAY#'}->[0]->{'#CHOICE#'}=[{'ST'=>$nd},@$list];
#    splice(@$list,$#$list-1,1,{'ST'=>$nd});
}

# SIP
sub CtPkSIPEextractPkt {
    my($hexdata)=@_;
    my($txt,$ptHeader,$ptLength,$ptBody,$ptSpace,$header,$body,$rest,$leng);

    # HEX
    $txt=pack('H*',$hexdata);

    # SIP
    $ptHeader=q{(?:(?-i:INVITE|ACK|OPTIONS|BYE|CANCEL|REGISTER|SUBSCRIBE|NOTIFY|REFER|PRACK|UPDATE|INFO|MESSAGE|PUBLISH|SIP/2))(?:[^\x0D\x0A]+)(?:\x0D\x0A)(?:[^\x0D\x0A]+(?:\x0D\x0A))+?(?:\x0D\x0A)};
    # Content-Length
    $ptLength='(?i:Content-Length:)\s*([0-9]+)';
    # Body
    $ptBody='(?:[^\x0D\x0A]+(?:\x0D\x0A))+';
    # 
    $ptSpace='(?:[\x0D\x0A]+)';

    # 
    if($txt =~ /^($ptSpace)/){
	$txt = substr($txt,length($1));
    }

    # SIP
    if($txt =~ /^($ptHeader)/){
	$header=$1;
	$body=substr($txt,length($header)); # 

	if($header =~ /$ptLength/){
	  # 
            $leng=$1;
            if(length($body)<$leng){
	      # 
	      return 'NG',$hexdata;
	    }
	    # 
	    $rest=substr($body,$leng);
	    $body=substr($body,0,$leng);
	}
	elsif(!$body){
	  # 
	}
	elsif($body =~ /(($ptBody)(?:$ptSpace)*)$ptHeader/){
	  # 
	  $rest=substr($body,length($1));
	  $body=$2;
	}
	# 
	return '',unpack('H*',$rest),unpack('H*',$header.$body);
    }
    # 
    return 'NG',$hexdata;
}

# SIP
sub CtMkInetSip {
    my($sip,$proto,$trans,$srcMac,$dstMac,$srcIP,$dstIP,$srcPort,$dstPort)=@_;
    my($inet);
    $inet=CtPkInetCreate('','',[{'type'=>$proto||'IPV6','params'=>{'Protocol'=>$trans||'UDP','NextPayload'=>$trans||'UDP',
								   'SrcAddress'=>$srcIP,'DstAddress'=>$dstIP}},
				{'type'=>$trans||'UDP','params'=>{'SrcPort'=>$srcPort,'DstPort'=>$dstPort}}]);
    
    ($sip)=CtPkDecode('SIP',unpack('H*',$sip));
    CtPkAddLayer3($inet, $sip);
    return $inet;
}


1;
