#!/usr/bin/perl
#
# Copyright(C) IPv6 Promotion Council (2004,2005). All Rights Reserved.
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

#=================================
# 
#=================================
%CNT_CONF = (
	     'INITIALIZE'           => 'NO',    #  BOOT | SIP | NO
	     'FAILCONTINUE'         => 'ON',     #  ON | OFF
	     'SPECIFICATION'        => 'RFC',    #  RFC | IG
	     'ROUTER-PREFIX-ADDRESS'=> '3ffe:501:ffff:50::',
	     'DNS-ADDRESS'          => '3ffe:501:ffff:4::1',
	     'DNS-TTL'              => 30,
	     'UA-ADDRESS'           => '',
	     'UA-USER'              => 'NUT',
	     'UA-HOSTNAME'          => 'under.test.com',
	     'UA-CONTACT-HOSTNAME'  => 'node.under.test.com',
	     'UA-PORT'              => (($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
	     'REG-ADDRESS'          => '3ffe:501:ffff:50::60',
	     'REG-HOSTNAME'         => 'reg.under.test.com',
	     'PX1-ADDRESS'          => '3ffe:501:ffff:50::50',
	     'PX1-HOSTNAME'         => 'ss.under.test.com',
	     'PUA-ADDRESS'          => '3ffe:501:ffff:1::1',
	     'PUA-USER'             => 'UA1',
	     'PUA-HOSTNAME'         => 'atlanta.example.com',
	     'PUA-CONTACT-HOSTNAME' => 'client.atlanta.example.com',
	     'AUTH-USERNAME'        => 'NUT',
	     'AUTH-PASSWD'          => 'nutsip',
	     'AUTH-REALM-RG'        => 'reg.under.test.com', 
	     'AUTH-REALM-PX1'       => 'under.test.com', 
	     'AUTH-REALM-PX2'       => 'atlanta.example.com',
	     'AUTH-SUPPORT'         => 'T',
	     'AUTH-SUPPORT-AFTER-DIALOG'         => 'T',
	     'HOLD-MEDIA'           => 1,        
	     'TIMER-T1'             => 0.5,
	     'TIMER-T2'             => 4,
	     'TIMER-MAGIN'          => 0.2,
	     'MAX-FORWARDS'         => 70,
	     'EXPIRES'              => 3600,
	     'TIME-STAMP'           => 1000,
	     'PX2-ADDRESS'          => '3ffe:501:ffff:20::20',
	     'PX2-HOSTNAME'         => 'ss1.atlanta.example.com',
	     'OT1-ADDRESS'          => '3ffe:501:ffff:20::21',
	     'LOG-LEVEL'            => 'ERR,WAR',
	     'SIMULATE-Tagret'      => 'T',
	     'STATISTICS-OUTPUT'    => '',
	     'RULE-INFO-DETAIL'     => '',
);

#=================================
# 
#=================================
# 
%SIP_ScenarioModel = (
	     'Role'                 => 'IPv6 for Proxy',
);

#=================================
# 
#=================================

# 
#   
#   
#   
#                        SIP_TERM_GLOBAL(
#   
#                        
#   
#        
#        
#                

%SIPNodeTempl=
(
 'PX1' =>{'AD'=>'9001::1','RFRAME'=>'SIPtoPX1', 'SFRAME'=>'SIPfromPX1', 'ADNAME'=>'PSEUDO_PX1'},
 'PX2' =>{'AD'=>'9001::2','RFRAME'=>'SIPtoPX2', 'SFRAME'=>'SIPfromPX2', 'ADNAME'=>'PSEUDO_PX2'},
 'PX3' =>{'AD'=>'9001::2','RFRAME'=>'SIPtoPX3', 'SFRAME'=>'SIPfromPX3', 'ADNAME'=>'PSEUDO_PX3'},
 'UA11'=>{'AD'=>'9001::3','RFRAME'=>'SIPtoUA11','SFRAME'=>'SIPfromUA11','ADNAME'=>'PSEUDO_UA11','ICMPERR'=>'ICMPErrorFromUA11'},
 'UA12'=>{'AD'=>'9001::4','RFRAME'=>'SIPtoUA12','SFRAME'=>'SIPfromUA12','ADNAME'=>'PSEUDO_UA12','ICMPERR'=>'ICMPErrorFromUA12'},
 'UA13'=>{'AD'=>'9001::4','RFRAME'=>'SIPtoUA13','SFRAME'=>'SIPfromUA13','ADNAME'=>'PSEUDO_UA13'},
 'UA14'=>{'AD'=>'9001::4','RFRAME'=>'SIPtoUA14','SFRAME'=>'SIPfromUA14','ADNAME'=>'PSEUDO_UA14'},
 'UA21'=>{'AD'=>'9001::4','RFRAME'=>'SIPtoUA21','SFRAME'=>'SIPfromUA21','ADNAME'=>'PSEUDO_UA21'},
 'REG' =>{'AD'=>'9001::4','RFRAME'=>'SIPtoREG', 'SFRAME'=>'SIPfromREG', 'ADNAME'=>'PSEUDO_REG'},
 'DNS' =>{'AD'=>'9001::4','RFRAME'=>'SIPtoDNS', 'SFRAME'=>'SIPfromDNS_AAAA1', 'ADNAME'=>'PSEUDO_DNS'},
 'RT'  =>{},
 );


%SIPFrameTempl=
(
 'SIPtoPX1'   =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'PX1'},
 'SIPfromPX1' =>{'Module'=>'SOCK','Dir'=>'out','Node'=>'PX1'},
 'SIPtoPX2'   =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'PX2'},
 'SIPfromPX2' =>{'Module'=>'SOCK','Dir'=>'out','Node'=>'PX2'},
 'SIPtoPX3'   =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'PX3'},
 'SIPfromPX3' =>{'Module'=>'SOCK','Dir'=>'out','Node'=>'PX3'},
 'SIPtoUA11'  =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'UA11'},
 'SIPfromUA11'=>{'Module'=>'SOCK','Dir'=>'out','Node'=>'UA11'},
 'SIPtoUA12'  =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'UA12'},
 'SIPfromUA12'=>{'Module'=>'SOCK','Dir'=>'out','Node'=>'UA12'},
 'SIPtoUA13'  =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'UA13'},
 'SIPfromUA13'=>{'Module'=>'SOCK','Dir'=>'out','Node'=>'UA13'},
 'SIPtoUA14'  =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'UA14'},
 'SIPfromUA14'=>{'Module'=>'SOCK','Dir'=>'out','Node'=>'UA14'},
 'SIPtoREG'   =>{'Module'=>'SOCK','Dir'=>'in' ,'Node'=>'REG'},
 'SIPfromREG' =>{'Module'=>'SOCK','Dir'=>'out','Node'=>'REG'},
 'SIPfromREGtoUA11'=>{'Module'=>'SOCK','Dir'=>'in', 'Node'=>'UA11'},
 'SIPfromUA11toREG'=>{'Module'=>'SOCK','Dir'=>'out','Node'=>'UA11'},
 'SIPfromREGtoUA12'=>{'Module'=>'SOCK','Dir'=>'in', 'Node'=>'UA12'},
 'SIPfromUA12toREG'=>{'Module'=>'SOCK','Dir'=>'out','Node'=>'UA12'},
 'SIPfromREGtoUA13'=>{'Module'=>'SOCK','Dir'=>'in', 'Node'=>'UA13'},
 'SIPfromUA13toREG'=>{'Module'=>'SOCK','Dir'=>'out','Node'=>'UA13'},
 'SIPfromREGtoUA14'=>{'Module'=>'SOCK','Dir'=>'in', 'Node'=>'UA14'},
 'SIPfromUA14toREG'=>{'Module'=>'SOCK','Dir'=>'out','Node'=>'UA14'},
 'SIPtoDNS'   =>{'Module'=>'TAHI'},
 'SIPfromDNS_AAAA1'=>{'Module'=>'TAHI'},
 'SIPfromDNS_AAAA2'=>{'Module'=>'TAHI'},
 'SIPfromDNS_NONE' =>{'Module'=>'TAHI'},
 'SIPfromDNS_SRV'  =>{'Module'=>'TAHI'},
 'EchoRequestFromServ'=>{'Module'=>'TAHI','Trans'=>'ICMP'},
 'EchoReplyToServ'    =>{'Module'=>'TAHI','Trans'=>'ICMP'},
 'ICMPErrorFromUA11'  =>{'Module'=>'TAHI','Trans'=>'ICMP'},
 'ICMPErrorFromUA12'  =>{'Module'=>'TAHI','Trans'=>'ICMP'},
 'ICMPErrorFromUA11'  =>{'Module'=>'TAHI','Trans'=>'ICMP'},
 );

#=================================
# 
#=================================
# LOCAL:      UA
#             PX
# REMOTE:     UA
#             PX
# PROXY-UAC:  UA
#             PX
# PROXY-UAS:  UA
#             PX
%SIPCallVarTbl=(
		'REMOTE_CONTACT_URI'
		=> {'VA'=>'CNT_TUA_CONTACT_URI',
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{sprintf("%s:%s@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_CONF{'PUA-CONTACT-HOSTNAME'})},
			    'PX2'=>\q{sprintf("%s:%s@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'UA-USER'},$CNT_CONF{'UA-CONTACT-HOSTNAME'})}},
			'UA-UA'=>{
			    'UA11'=>\q{sprintf("%s:%s@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA11'),NDCFG('contact.hostname','UA11')},
			    'UA12'=>\q{sprintf("%s:%s@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA12'),NDCFG('contact.hostname','UA12')},
			    'UA13'=>\q{sprintf("%s:%s@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA13'),NDCFG('contact.hostname','UA13'))},
			    'UA14'=>\q{sprintf("%s:%s@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",NDCFG('aor.user','UA14'),NDCFG('contact.hostname','UA14'))}
			}
		    }
		},
		'REMOTE_IP_ADDRESS'
		=> {'VA'=>'CVA_TUA_IPADDRESS',
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{$CNT_CONF{'PUA2-ADDRESS'}},
			    'PX2'=>\q{$CNT_CONF{'PUA-ADDRESS'}}},
			'UA-UA'=>{
			    'UA11'=>\q{$CNT_CONF{'PUA2-ADDRESS'}},
			    'UA12'=>\q{$CNT_CONF{'PUA-ADDRESS'}},
			    'UA13'=>\q{NDCFG('aor-uri','UA13')},
			    'UA14'=>\q{NDCFG('aor-uri','UA14')}
			}
		    }
		},
		'REMOTE_AOR_URI'
		=> {'VA'=>'CVA_TUA_URI',
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_CONF{'PUA-HOSTNAME'})},
			    'PX2'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'UA-USER'},$CNT_CONF{'UA-HOSTNAME'})}},
			'UA-UA'=>{
			    'UA11'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_CONF{'UA-HOSTNAME'})},
			    'UA12'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'UA-USER'},$CNT_CONF{'UA-HOSTNAME'})},
			    'UA13'=>\q{sprintf("%s",NDCFG('aor-uri','UA11'))},
			    'UA14'=>\q{sprintf("%s",NDCFG('aor-uri','UA11'))}
			}
		    }},
		'LOCAL_AOR_URI'
		=> {'VA'=>'CVA_PUA_URI',            
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'UA-USER'},$CNT_CONF{'UA-HOSTNAME'})},
			    'PX2'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_CONF{'PUA-HOSTNAME'})}},
			'UA-UA'=>{
			    'UA11'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'UA-USER'},$CNT_CONF{'UA-HOSTNAME'})},
			    'UA12'=>\q{sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_CONF{'UA-HOSTNAME'})},
			    'UA13'=>\q{sprintf("%s",NDCFG('aor-uri','UA13'))},
			    'UA14'=>\q{sprintf("%s",NDCFG('aor-uri','UA14'))}
			}
		    }},
		'LOCAL_CONTACT_URI'
		=> {'VA'=>'CNT_PUA_CONTACT_URI',    
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{sprintf("%s:%s@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'UA-USER'},$CNT_CONF{'UA-CONTACT-HOSTNAME'})},
			    'PX2'=>\q{sprintf("%s:%s@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_CONF{'PUA-CONTACT-HOSTNAME'})}},
			'UA-UA'=>{
			    'UA11'=>\q{sprintf("%s",NDCFG('contact-uri','UA11'))},
			    'UA12'=>\q{sprintf("%s",NDCFG('contact-uri','UA12'))},
			    'UA13'=>\q{sprintf("%s",NDCFG('contact-uri','UA13'))},
			    'UA14'=>\q{sprintf("%s",NDCFG('contact-uri','UA14')}
			}
		    }
		},
		'LOCAL_HOSTNAME'
		=> {'VA'=>'CNT_PUA_HOSTNAME',            
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{$CNT_CONF{'PUA-CONTACT-HOSTNAME'}},
			    'PX2'=>\q{$CNT_CONF{'UA-CONTACT-HOSTNAME'}}},
			'UA-UA'=>{
			    'UA11'=>'',
			    'UA12'=>'',
			    'UA13'=>'',
			    'UA14'=>''
			}
		    }
		},
		'REMOTE_HOSTNAME'
		=> {'VA'=>'CNT_TUA_HOSTNAME',            
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{$CNT_CONF{'PUA-CONTACT-HOSTNAME'}},
			    'PX2'=>\q{$CNT_CONF{'UA-CONTACT-HOSTNAME'}}},
			'UA-UA'=>{
			    'UA11'=>'',
			    'UA12'=>'',
			    'UA13'=>'',
			    'UA14'=>''
			}
		    }
		},
		'LOCAL_PORT'
		=> {'VA'=>'CNT_PUA_PORT',            
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			    'PX2'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
			'UA-UA'=>{
			    'UA11'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			    'UA12'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			    'UA13'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			    'UA14'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060")
			}
		    }
		},
		'REMOTE_PORT'
		=> {'VA'=>'CNT_TUA_PORT',            
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			    'PX2'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
			'UA-UA'=>{
			    'UA11'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			    'UA12'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			    'UA13'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			    'UA14'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060")
			}
		    }
		},
		'LOCAL_IPADDRESS'
		=> {'VA'=>'CVA_PUA_IPADDRESS',      
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{$CNT_CONF{'PUA-ADDRESS'}},
			    'PX2'=>\q{$CNT_CONF{'PUA2-ADDRESS'}}},
			'UA-UA'=>{
			    'UA11'=>\q{$CNT_CONF{'PUA-ADDRESS'}},
			    'UA12'=>\q{$CNT_CONF{'PUA2-ADDRESS'}},
			    'UA13'=>\q{NDCFG('address','UA13')},
			    'UA14'=>\q{NDCFG('address','UA14')}
			}
		    }},
		'LOCAL_SDP_O_SESSION'
		=> {'VA'=>'CNT_PUA_SDP_O_SESSION',  
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{time()+2208988800},
			    'PX2'=>\q{time()+2208988800}},
			'UA-UA'=>{
			    'UA11'=>\q{time()+2208988800},
			    'UA12'=>\q{time()+2208988800},
			    'UA13'=>\q{time()+2208988800},
			    'UA14'=>\q{time()+2208988800}
			}
		    }},
		'LOCAL_SDP_O_VERSION'
		=> {'VA'=>'CNT_PUA_SDP_O_VERSION',  
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{$callTbl{'LOCAL_SDP_O_SESSION'}-1},
			    'PX2'=>\q{$callTbl{'LOCAL_SDP_O_SESSION'}-1}},
			'UA-UA'=>{
			    'UA11'=>\q{$callTbl{'LOCAL_SDP_O_SESSION'}-1},
			    'UA12'=>\q{$callTbl{'LOCAL_SDP_O_SESSION'}-1},
			    'UA13'=>\q{$callTbl{'LOCAL_SDP_O_SESSION'}-1},
			    'UA14'=>\q{$callTbl{'LOCAL_SDP_O_SESSION'}-1}
			}
		    }},
		'REMOTE_TAG'
		=> {'VA'=>'CVA_REMOTE_TAG',         
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>'',
			    'PX2'=>''},
			'UA-UA'=>{
			    'UA11'=>'',
			    'UA12'=>'',
			    'UA13'=>'',
			    'UA14'=>''
			}
		    }
		},
		'LOCAL_TAG'
		=> {'VA'=>'CVA_LOCAL_TAG',          
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{'100' . ($CVA_LOCAL_CSEQ_NUM)},
			    'PX2'=>\q{'200' . ($CVA_LOCAL_CSEQ_NUM)}},
			'UA-UA'=>{
			    'UA11'=>\q{'100' . ($CVA_LOCAL_CSEQ_NUM)},
			    'UA12'=>\q{'200' . ($CVA_LOCAL_CSEQ_NUM)},
			    'UA13'=>\q{'300' . ($CVA_LOCAL_CSEQ_NUM)},
			    'UA14'=>\q{'400' . ($CVA_LOCAL_CSEQ_NUM)}
			}
		    }},
		'LOCAL_CSEQ_NUM'
		=> {'VA'=>'CVA_LOCAL_CSEQ_NUM',     
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>'',
			    'PX2'=>''},
			'UA-UA'=>{
			    'UA11'=>'',
			    'UA12'=>'',
			    'UA13'=>'',
			    'UA14'=>''
			}
		    }
		},
		'COUNT_BRANCH'
		=> {'VA'=>'CVA_COUNT_BRANCH',       
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{$CVA_COUNT_BRANCH},
			    'PX2'=>\q{$CVA_COUNT_BRANCH+1000}},
			'UA-UA'=>{
			    'UA11'=>\q{$CVA_COUNT_BRANCH},
			    'UA12'=>\q{$CVA_COUNT_BRANCH+1000},
			    'UA13'=>\q{$CVA_COUNT_BRANCH+2000},
			    'UA14'=>\q{$CVA_COUNT_BRANCH+3000}
			}
		    }
		},
		'LOCAL_HOSTPORT'
		=> {'VA'=>'CNT_PUA_HOSTPORT',            
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{$CNT_CONF{'UA-CONTACT-HOSTNAME'}.':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
			    'PX2'=>\q{$CNT_CONF{'PUA-CONTACT-HOSTNAME'}.':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")}},
			'UA-UA'=>{
			    'UA11'=>\q{NDCFG('contact.hostname','UA11').':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
			    'UA12'=>\q{NDCFG('contact.hostname','UA12').':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
			    'UA13'=>\q{NDCFG('contact.hostname','UA13')},
			    'UA14'=>\q{NDCFG('contact.hostname','UA14')}
			}
		    }
		},

### 20050420 usako add start ###
        'LOCAL_HOSTADDRESS'
        => {'VA'=>'CNT_PUA_HOSTADDRESS',
            'IV'=>{
		'UA-PX'=>{
		    'UA11'=>\q{$CNT_CONF{'PUA-ADDRESS'}},
		    'PX2'=>\q{$CNT_CONF{'PUA2-ADDRESS'}}},
		'UA-UA'=>{
		    'UA11'=>\q{$CNT_CONF{'PUA-ADDRESS'}},
		    'UA12'=>\q{$CNT_CONF{'PUA2-ADDRESS'}},
		    'UA13'=>\q{NDCFG('address','UA13')},
		    'UA14'=>\q{NDCFG('address','UA14')}
		}
	    }
	},
### 20050420 usako add end ###

		'PROXY_UAC_HOSTNAME'
		=> {'VA'=>'CNT_PX1_HOSTNAME',            
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{$CNT_CONF{'PX1-HOSTNAME'}},
			    'PX2'=>\q{$CNT_CONF{'PX1-HOSTNAME'}}},
			'UA-UA'=>{
			    'UA11'=>'',
			    'UA12'=>'',
			    'UA13'=>'',
			    'UA14'=>''
			}
		    }
		},
		'PROXY_UAC_PORT'
		=> {'VA'=>'CNT_PX1_PORT',            
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			    'PX2'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
			'UA-UA'=>{
			    'UA11'=>'',
			    'UA12'=>'',
			    'UA13'=>'',
			    'UA14'=>''
			}
		    }
		},
		'PROXY_UAC_IPADDRESS'
		=> {'VA'=>'CVA_PX1_IPADDRESS',            
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{$CNT_CONF{'UA-ADDRESS'}},
			    'PX2'=>\q{$CNT_CONF{'PX1-ADDRESS'}}},
			'UA-UA'=>{
			    'UA11'=>'',
			    'UA12'=>'',
			    'UA13'=>'',
			    'UA14'=>''
			}
		    }
		},
		'PROXY_UAS_HOSTNAME'
		=> {'VA'=>'CNT_PX2_HOSTNAME',       
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{$CNT_CONF{'PUA-HOSTNAME'}},
			    'PX2'=>\q{$CNT_CONF{'UA-HOSTNAME'}}},
			'UA-UA'=>{
			    'UA11'=>'',
			    'UA12'=>'',
			    'UA13'=>'',
			    'UA14'=>''
			}
		    }
		},
		'PROXY_UAS_PORT'
		=> {'VA'=>'CNT_PX2_PORT',       
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			    'PX2'=>(($SIP_PL_TRNS eq "TLS")?"5061":"5060")},
			'UA-UA'=>{
			    'UA11'=>'',
			    'UA12'=>'',
			    'UA13'=>'',
			    'UA14'=>''
			}
		    }
		},
		'PROXY_UAS_IPADDRESS'
		=> {'VA'=>'CVA_PX2_IPADDRESS',       
		    'IV'=>{
			'UA-PX'=>{
			    ## 'UA11'=>\q{$CNT_CONF{'UA-ADDRESS'}},
			    'UA11'=>\q{$CNT_CONF{'PX1-ADDRESS'}},
			    'PX2'=>\q{$CNT_CONF{'UA-ADDRESS'}}},
			'UA-UA'=>{
			    'UA11'=>\q{$CNT_CONF{'UA-ADDRESS'}},
			    'UA12'=>\q{$CNT_CONF{'UA-ADDRESS'}},
			    'UA13'=>\q{$CNT_CONF{'UA-ADDRESS'}},
			    'UA14'=>\q{$CNT_CONF{'UA-ADDRESS'}}
			}
		    }
		},
		'LOCAL_ROUTESET_ONEURI'
		=> {'VA'=>'CNT_PUA_ONEPX_ROUTESET', 'TY'=>'ARRAY', 
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{[sprintf("sip:$CNT_CONF{'REG-HOSTNAME'}",($SIP_PL_TRNS eq "TLS")?"sips":"sip")]},
			    'PX2'=>\q{[sprintf("sip:$CNT_CONF{'REG-HOSTNAME'}",($SIP_PL_TRNS eq "TLS")?"sips":"sip")]}},
			'UA-UA'=>{
			    'UA11'=>'',
			    'UA12'=>'',
			    'UA13'=>'',
			    'UA14'=>''
			}
		    }
		},
		'LOCAL_ROUTESET_TWOURIS'
		=> {'VA'=>'CNT_PUA_TWOPX_ROUTESET', 'TY'=>'ARRAY',
		    'IV'=>{
			'UA-PX'=>{
			    'UA11'=>\q{[sprintf("%s:$CNT_CONF{'REG-HOSTNAME'}",($SIP_PL_TRNS eq "TLS")?"sips":"sip"),
							sprintf("%s:$CNT_PX1_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip")]},
			    'PX2'=>\q{[sprintf("%s:$CNT_PX1_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip"),
						   sprintf("%s:$CNT_CONF{'REG-HOSTNAME'}",($SIP_PL_TRNS eq "TLS")?"sips":"sip")]}},
			'UA-UA'=>{
			    'UA11'=>\q{[sprintf("%s:$CNT_CONF{'REG-HOSTNAME'}",($SIP_PL_TRNS eq "TLS")?"sips":"sip")]},
			    'UA12'=>\q{[sprintf("%s:$CNT_CONF{'REG-HOSTNAME'}",($SIP_PL_TRNS eq "TLS")?"sips":"sip")]},
			    'UA13'=>\q{[sprintf("%s:$CNT_CONF{'REG-HOSTNAME'}",($SIP_PL_TRNS eq "TLS")?"sips":"sip")]},
			    'UA14'=>\q{[sprintf("%s:$CNT_CONF{'REG-HOSTNAME'}",($SIP_PL_TRNS eq "TLS")?"sips":"sip")]}
			}
		    }
		},
		'PUA_BRANCH_HISTORY'
		=> {'VA'=>'CVA_PUA_BRANCH_HISTORY'},
		'PX1_BRANCH_HISTORY'
		=> {'VA'=>'CVA_PX1_BRANCH_HISTORY'},
		'PX2_BRANCH_HISTORY'
		=> {'VA'=>'CVA_PX2_BRANCH_HISTORY'},
		'NOPX_SEND_VIAS'
		=> {'VA'=>'CNT_NOPX_SEND_VIAS','TY'=>'ARRAY'},
		'ONEPX_SEND_VIAS'
		=> {'VA'=>'CNT_ONEPX_SEND_VIAS','TY'=>'ARRAY'},
		'TWOPX_SEND_VIAS'
		=> {'VA'=>'CNT_TWOPX_SEND_VIAS','TY'=>'ARRAY'},
		);
	    
#=================================
# Proxy/Registrar parameter
#=================================



sub SetupSIPParam {
    my($index)=@_;
    my($puaContactRedirect);
    my($key,$num)=SIPLoadMagic($index);

# LOG
    $SIPLOGO='T';

# RTP
    $SIP_RTP_RECOGNIZE_TIME=1;

# 
# URI
    $CNT_TUA_CONTACT_URI=sprintf("%s:%s\@%s:%s",
  				 ($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'UA-USER'},
				 $CNT_CONF{'UA-CONTACT-HOSTNAME'},$CNT_CONF{'UA-PORT'});
    $CNT_TUA_HOSTNAME=$CNT_CONF{'UA-CONTACT-HOSTNAME'};
    $CVA_TUA_O_VERSION="";
# header component at the end of Contact
    $CVA_TUA_CONTACT_HEADER = "";
# IP
    $CVA_TUA_IPADDRESS=$CNT_CONF{'UA-ADDRESS'};
    # LOGO
    if($SIPLOGO && !$CVA_TUA_IPADDRESS){
	$CVA_TUA_IPADDRESS=GenerateIPv6FromMac($V6evalTool::NutDef{'Link0_addr'},$CNT_CONF{'ROUTER-PREFIX-ADDRESS'});
    }
    $CVA_TUA_URI=sprintf("%s:%s\@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'UA-USER'},$CNT_CONF{'UA-HOSTNAME'});
# 
    $CNT_TUA_PORT=$CNT_CONF{'UA-PORT'};
    $CNT_PORT_DEFAULT_RTP='49172';
    $CNT_PORT_CHANGE_RTP='49172';
    
# 
# URI
    $CNT_PUA_CONTACT_URI=sprintf("%s:%s@%s",($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_CONF{'PUA-CONTACT-HOSTNAME'});
    $CNT_PUA_HOSTNAME=$CNT_CONF{'PUA-CONTACT-HOSTNAME'};
    $CNT_PUA_PORT=(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
    $CNT_PUA_HOSTPORT=$CNT_CONF{'PUA-CONTACT-HOSTNAME'} . ':' . $CNT_PUA_PORT;


# IP
    $CVA_PUA_URI=sprintf('%s:%s@%s',($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_CONF{'PUA-HOSTNAME'});
    $CVA_PUA_IPADDRESS=$CNT_CONF{'PUA-ADDRESS'};

# 
    $CNT_PX1_HOSTNAME=$CNT_CONF{'PX1-HOSTNAME'};
    $CNT_PX1_PORT=(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
    $CNT_PX1_HOSTPORT=$CNT_CONF{'PX1-HOSTNAME'} . ':' . $CNT_PX1_PORT;
    $CVA_PX1_IPADDRESS=$CNT_CONF{'PX1-ADDRESS'};

    $CNT_PX2_HOSTNAME=$CNT_CONF{'PX2-HOSTNAME'};
    $CNT_PX2_PORT=(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
    $CNT_PX2_HOSTPORT=$CNT_CONF{'PX2-HOSTNAME'} . ':' . $CNT_PX2_PORT;
    $CVA_PX2_IPADDRESS=$CNT_CONF{'PX2-ADDRESS'};

#    $CNT_PUA_SDP_FMT=0;
    $CNT_PUA_SDP_O_SESSION=time()+2208988800;
    $CNT_PUA_SDP_O_VERSION=$CNT_PUA_SDP_O_SESSION-1;

# URI
    $CNT_ROUTE_PX_URI=sprintf('%s:%s:%s;lr',($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PX1-HOSTNAME'},$CNT_PX1_PORT);
# 
    $CNT_RG_URI=$CNT_CONF{'REG-HOSTNAME'}.':'.(($SIP_PL_TRNS eq "TLS")?"5061":"5060");
# IP
    $CVA_RG_IPADDRESS=$CNT_CONF{'REG-ADDRESS'};
# 
    $CNT_RG_FRAME=($CVA_RG_IPADDRESS eq $CVA_PX1_IPADDRESS) ? 'SIPtoPROXY' : 'SIPtoREG';


# 
    $CNT_AUTH_NONCE ='"1cec4341ae6cbe5a359ea9c8e88df84f"';
    $CNT_AUTH_NONCE2='"84f1c1ae6cbe5ua9c8e88dfa3ecm3459"';
    $CNT_AUTH_NEXTNONCE_COUNTER=1;
    @CNT_AUTH_NEXTNONCE =($CNT_AUTH_NONCE                     ,'"1cec4341ae6cbe5a359ea9c8e88df841"',
			  '"1cec4341ae6cbe5a359ea9c8e88df842"','"1cec4341ae6cbe5a359ea9c8e88df843"',
			  '"1cec4341ae6cbe5a359ea9c8e88df844"','"1cec4341ae6cbe5a359ea9c8e88df845"');
    $CNT_AUTH_REALM_RG ="\"$CNT_CONF{'AUTH-REALM-RG'}\"";
    $CNT_AUTH_REALM ="\"$CNT_CONF{'AUTH-REALM-PX1'}\"";
    $CNT_AUTH_REALM2="\"$CNT_CONF{'AUTH-REALM-PX2'}\"";
    $CNT_AUTH_USRNAME="\"$CNT_CONF{'AUTH-USERNAME'}\"";
    $CNT_AUTH_PASSWD="$CNT_CONF{'AUTH-PASSWD'}";

# 
# 
    $CVA_CALLID = '123' . $num . '@' . $key . '.example.com';
    $CVA_REMOTE_TAG=''; 
    $CVA_REMOTE_CSEQ_NUM='';
    $CVA_LOCAL_TAG = '100'. $num;
    $CVA_LOCAL_CSEQ_NUM=$num;
    
# 
# 
    $CVA_TUA_CURRENT_BRANCH;
# 
    @CVA_TUA_BRANCH_HISTORY;
# 
# PX1,PX2,*****,PUA
    @CVA_PUA_BRANCH_ALL;

# 
    $CVA_PUA_URI_REDIRECT=sprintf('%s:%s@%s',($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'}, 'chicago.example.com');
    $CVA_PUA_IPADDRESS_REDIRECT='3ffe:501:ffff:3::3';
    $CNT_PUA_HOSTNAME_CONTACT_REDIRECT='client.chicago.example.com';
    $puaContactRedirect=sprintf('%s:%s@%s',
					  ($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'},$CNT_PUA_HOSTNAME_CONTACT_REDIRECT);

    $CVA_PUA_URI_REDIRECT2=sprintf('%s:%s@chicago2.example.com',($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'PUA-USER'});

# 

    @CNT_TUA_ONEPX_ROUTESET=sprintf("%s:$CNT_PX1_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip");
    @CNT_PUA_ONEPX_ROUTESET=sprintf("%s:$CNT_PX1_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip");
    @CNT_PUA_TWOPX_ROUTESET=(sprintf("%s:$CNT_PX2_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip"),
							 sprintf("%s:$CNT_PX1_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip"));
    @CNT_PUA_TWOPX_ROUTESET_REDIRECT=(sprintf("%s:ss2.chicago.example.com;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip"),
									  sprintf("%s:$CNT_PX1_HOSTNAME;lr",($SIP_PL_TRNS eq "TLS")?"sips":"sip"));


# 
    @CVA_UNSUPPORTED_LIST_REQUIRE=('nothingSupportsThis', 'nothingSupportsThisEither');
    @CVA_UNSUPPORTED_LIST_P_REQUIRE=("noProxiesSupportThis", "norDoAnyProxiesSupportThis");

# Via
    $CVA_COUNT_BRANCH=100+$num;
    SetupViaParam($CVA_COUNT_BRANCH);

# 
    $CVA_TIME_STAMP = $CNT_CONF{'TIME-STAMP'};

    $CVA_AUTH_SUPPORT_AFTER_DIALOG = $CNT_CONF{'AUTH-SUPPORT-AFTER-DIALOG'};

# 
     $CVA_DNS_IPADDRESS=$CNT_CONF{'DNS-ADDRESS'};
# AAAA 
    @SIP_AAAA_RECORD =
	( {'FQDN'=>"$CNT_CONF{'PX1-HOSTNAME'}.",            'IPV6'=>$CVA_PX1_IPADDRESS, '2RECORD'=>'YES'}, # 
	  {'FQDN'=>"$CNT_CONF{'PUA-HOSTNAME'}.",            'IPV6'=>$CVA_PUA_IPADDRESS},
##	  {'FQDN'=>"$CNT_CONF{'PUA-CONTACT-HOSTNAME'}.",    'IPV6'=>$CVA_PUA_IPADDRESS},
	  {'FQDN'=>NDCFG('contact.hostname','UA12'),        'IPV4'=>NDCFG('address','UA12')},
	  {'FQDN'=>NDCFG('contact.hostname','UA13'),        'IPV4'=>NDCFG('address','UA13')},
	  {'FQDN'=>"$puaContactRedirect.",                  'IPV6'=>$CVA_PUA_IPADDRESS_REDIRECT},
	  {'FQDN'=>"$CNT_CONF{'UA-HOSTNAME'}.",             'IPV6'=>''},
	  {'FQDN'=>"$CNT_CONF{'REG-HOSTNAME'}.",            'IPV6'=>$CVA_RG_IPADDRESS},
##	  {'FQDN'=>"NDCFG('contact.hostname','UA12')".'.',  'IPV6'=>$CNT_CONF{'PUA2-ADDRESS'}},
	  );
# 
    $SIP_OTHER_AAAA=$CNT_CONF{'OT1-ADDRESS'};
# DNS
    $SIP_DNS_ANSWER_MODE='AAAA1';
# DNS
    $SIP_DNS_TTL=$CNT_CONF{'DNS-TTL'};

# ------------------  

# 
    # Emulating Register Node: SIP-URI
    $CNT_RG_URI_2 = sprintf('%s:%s:%s',($SIP_PL_TRNS eq "TLS")?"sips":"sip",$CNT_CONF{'REG-HOSTNAME'}, $CNT_PX1_PORT);

# 
    ## nonce-count(nc parameter) for Authorization/Proxy-Authrozation
    $CNT_AUTH_NONCECOUNT ='00000001';
    ## cnonce-value(cnonce parameter) for Authorization/Proxy-Authrozation
    $CNT_AUTH_CNONCE='"6f54a149"';
    ## redefination of uri parameter for Authorization/Proxy-Authorization
    ## when sending authentication response, it must equal the Request-URI.

# by HOK
    $CNT_TUA_HOSTPORT=$CNT_CONF{'REG-HOSTNAME'};

    SIPSaveMagic($num);
}

# Via
sub SetupViaParam {
    my($num)=@_;

    if($CNT_VIA_INIT_SEED eq ''){$CNT_VIA_INIT_SEED=$num;}
    if($num eq ''){$CNT_VIA_INIT_SEED++;$num=$CNT_VIA_INIT_SEED;}

# 
    $CVA_PUA_BRANCH_HISTORY=sprintf("z9hG4bKPUA%s%s", $$, $num);
    $CVA_PX1_BRANCH_HISTORY=sprintf("z9hG4bKPONE%s%s", $$, $num);
    $CVA_PX2_BRANCH_HISTORY=sprintf("z9hG4bKPTWO%s%s", $$, $num);

# 
    @CNT_TWOPX_SEND_VIAS_REDIRECT= ("$CNT_PX1_HOSTPORT;branch=$CVA_PX1_BRANCH_HISTORY",
               sprintf("ss2.chicago.example.com:%s;branch=$CVA_PX2_BRANCH_HISTORY;received=$CVA_PX2_IPADDRESS",($SIP_PL_TRNS eq "TLS")?"5061":"5060"),
			   sprintf("$CNT_PUA_HOSTNAME_CONTACT_REDIRECT:%s;branch=$CVA_PUA_BRANCH_HISTORY;received=$CVA_PUA_IPADDRESS_REDIRECT",($SIP_PL_TRNS eq "TLS")?"5061":"5060"));
# 
    @CNT_NOPX_SEND_VIAS = ("$CNT_PUA_HOSTPORT;branch=$CVA_PUA_BRANCH_HISTORY");
    @CNT_NOPX_SEND_VIAS_BRANCH = (";branch=$CVA_PUA_BRANCH_HISTORY");
    # NDxxx
    @CNT_ONEPX_SEND_VIAS= ("$CNT_PX1_HOSTPORT;branch=$CVA_PX1_BRANCH_HISTORY",
						   "$CNT_PUA_HOSTPORT;branch=$CVA_PUA_BRANCH_HISTORY;received=$CNT_PUA_HOSTADDRESS");
    @CNT_TWOPX_SEND_VIAS= ("$CNT_PX1_HOSTPORT;branch=$CVA_PX1_BRANCH_HISTORY",
                           "$CNT_PX2_HOSTPORT;branch=$CVA_PX2_BRANCH_HISTORY;received=$CVA_PX2_IPADDRESS",
						   "$CNT_PUA_HOSTPORT;branch=$CVA_PUA_BRANCH_HISTORY;received=$CNT_PUA_HOSTADDRESS");

# 
    @CVA_PUA_BRANCH_ALL=("$CVA_PX1_BRANCH_HISTORY",
                         "$CVA_PX2_BRANCH_HISTORY",
                         "$CVA_PUA_BRANCH_HISTORY",
                         'z9hG4bK2dummy1',
                         'z9hG4bK2dummy2',
                         'z9hG4bK2dummy3',
                         'z9hG4bK2dummy4');

}

# 
sub SIPStoreContextValue {
    my($calltbl)=@_;
    my(%context,$key,$tbl,$name);

    while(($key,$tbl)=each(%SIPCallVarTbl)){
	$name=$tbl->{'VA'};
	if($tbl->{'TY'} eq 'ARRAY'){
	    @{$context{$key}}=@$name;
	}
	else{
	    $context{$key}=$$name;
	}
    }
    return \%context;
}


#########################################################################
#
#  
#
#
#########################################################################
%NEWandOLDTbl =
(
 'PXnode'=>{
     'CVA_CALLID'=>'DLOG.CallID', 
     'CVA_LOCAL_CSEQ_NUM'=>'DLOG.LocalCSeqNum', 
     'CVA_LOCAL_TAG'=>'DLOG.LocalTag', 
     'CVA_REMOTE_CSEQ_NUM'=>'DLOG.RemoteCSeqNum', 
     'CVA_REMOTE_TAG'=>'DLOG.RemoteTag', 
     'CNT_PX1_HOSTPORT'=>'HostPort', 
     'CVA_PX1_IPADDRESS'=>'IPaddr', 
     'CNT_PX2_PORT'=>'SIPSrcPort', 
     'CVA_REMOTE_RSEQ_NUM'=>'TRNS.LocalRSeqNum', 
     'CVA_LOCAL_RSEQ_NUM'=>'TRNS.RemoteRSeqNum', 
     'P1'=>'RemotePeer', 
     'P2'=>'LocalPeer', 
     'P3'=>'Forward', 
 },
 'UAnode'=>{
     'CNT_AUTH_PASSWD'=>'AuthPasswd', 
     'CNT_AUTH_REALM'=>'AuthRealm', 
     'CNT_AUTH_USRNAME'=>'AuthUserName', 
     'CNT_PUA_CONTACT_URI'=>'LocalContactURI', 
     'CNT_PUA_HOSTPORT'=>'HostPort', 
     'CNT_PUA_SDP_O_SESSION'=>'SDP_o_Session', 
     'CNT_PUA_SDP_O_VERSION'=>'SDP_o_Version', 
     'CVA_PUA_DISPNAME'=>'DisplayName', 
     'CVA_PX1_IPADDRESS'=>'IPaddr', 
     'CVA_PUA_URI'=>'LocalAoRURI', 
     'CNT_TUA_CONTACT_URI'=>'RemoteContactURI', 
     'CNT_PX2_PORT'=>'SIPPort', 
     'CNT_PORT_DEFAULT_RTP'=>'RTPPort', 
     'CVA_TUA_URI'=>'RemoteAoRURI', 
     'CVA_CALLID'=>'DLOG.CallID', 
     'CVA_LOCAL_TAG'=>'DLOG.LocalTag', 
     'CVA_REMOTE_TAG'=>'DLOG.RemoteTag', 
     'CVA_LOCAL_CSEQ_NUM'=>'DLOG.LocalCSeqNum', 
     'CVA_REMOTE_CSEQ_NUM'=>'DLOG.RemoteCSeqNum', 
     'CVA_REMOTE_RSEQ_NUM'=>'TRNS.LocalRSeqNum', 
     'CVA_LOCAL_RSEQ_NUM'=>'TRNS.RemoteRSeqNum', 
     'P1'=>'RemotePeer', 
     'P3'=>'Forward', 
 },
 'Other'=>{
     'NDMAP'=>{
	 'SCALR'=>
	     [CVA_TUA_IPADDRESS,
	      CVA_TUA_URI,
	      CNT_TUA_PORT,
	      CNT_PORT_DEFAULT_RTP,
	      CNT_PUA_CONTACT_URI,
	      CNT_PUA_HOSTPORT,
	      CVA_PUA_URI,
	      CNT_PX1_HOSTPORT,
	      CVA_PX1_IPADDRESS,
	      CNT_PX2_PORT,
	      CNT_PUA_SDP_O_SESSION,
	      CNT_PUA_SDP_O_VERSION,
	      CNT_AUTH_REALM,
	      CNT_AUTH_USRNAME,
	      CNT_AUTH_PASSWD,
	      CVA_CALLID,
	      CVA_REMOTE_TAG,
	      CVA_REMOTE_CSEQ_NUM,
	      CVA_LOCAL_TAG,
	      CVA_LOCAL_CSEQ_NUM,
	      CNT_TUA_HOSTPORT,],
	 'ARRAY'=>
	 [CNT_PUA_TWOPX_ROUTESET,],},

     'NONMAP'=>{
	 'SCALR'=>
	     [CNT_TUA_HOSTNAME,
	      CVA_TUA_O_VERSION,
	      CVA_TUA_CONTACT_HEADER,
	      CNT_PORT_CHANGE_RTP,
	      CNT_PUA_HOSTNAME,
	      CNT_PUA_PORT,
	      CVA_PUA_IPADDRESS,
	      CNT_PX1_HOSTNAME,
	      CNT_PX1_PORT,
	      CNT_PX2_HOSTNAME,
	      CNT_PX2_HOSTPORT,
	      CVA_PX2_IPADDRESS,
	      CNT_ROUTE_PX_URI,
	      CNT_RG_URI,
	      CVA_RG_IPADDRESS,
	      CNT_RG_FRAME,
	      CNT_AUTH_NONCE,
	      CNT_AUTH_NONCE2,
	      CNT_AUTH_NEXTNONCE_COUNTER,
	      CNT_AUTH_REALM_RG,
	      CNT_AUTH_REALM2,
	      CVA_TUA_CURRENT_BRANCH,
	      CVA_PUA_URI_REDIRECT,
	      CVA_PUA_IPADDRESS_REDIRECT,
	      CVA_PUA_URI_REDIRECT2,
	      CVA_COUNT_BRANCH,
	      CVA_TIME_STAMP,
	      CVA_AUTH_SUPPORT_AFTER_DIALOG,
	      CVA_DNS_IPADDRESS,
	      SIP_OTHER_AAAA,
	      SIP_DNS_ANSWER_MODE,
	      SIP_DNS_TTL,
	      CNT_RG_URI_2,
	      CNT_AUTH_NONCECOUNT,
	      CNT_AUTH_CNONCE,
	      CVA_PUA_BRANCH_HISTORY,
	      CVA_PX1_BRANCH_HISTORY,
	      CVA_PX2_BRANCH_HISTORY,],
        'ARRAY'=>
	     [CNT_AUTH_NEXTNONCE,
	      CVA_TUA_BRANCH_HISTORY,
	      CVA_PUA_BRANCH_ALL,
	      CNT_TUA_ONEPX_ROUTESET,
	      CNT_PUA_ONEPX_ROUTESET,
	      CNT_PUA_TWOPX_ROUTESET_REDIRECT,
	      CVA_UNSUPPORTED_LIST_REQUIRE,
	      CVA_UNSUPPORTED_LIST_P_REQUIRE,
	      SIP_AAAA_RECORD,
	      CNT_TWOPX_SEND_VIAS_REDIRECT,
	      CNT_NOPX_SEND_VIAS,
	      CNT_ONEPX_SEND_VIAS,
	      CNT_TWOPX_SEND_VIAS,]}}
);

sub NewAndOldVar {
    my($node)=@_;
    my(@olds,$old,$tbl,$name,$var,@msg,$msg,@fields,$field);

# 
    if($node->{'ID'} =~ /UA/){
	@olds=sort(keys(%{$NEWandOLDTbl{'UAnode'}}));
	$tbl=$NEWandOLDTbl{'UAnode'};
    }
    else{
	@olds=sort(keys(%{$NEWandOLDTbl{'PXnode'}}));
	$tbl=$NEWandOLDTbl{'PXnode'};
    }
    printf("\n-------[%s]----[%s]------------------------------------\n",$NDTopology,$node->{'ID'});
    foreach $old (@olds){
	printf("%-23.23s|%-23.23s| %-23.23s|%-23.23s|\n",
	       $tbl->{$old},$old,$node->{'CALL'}->{$tbl->{$old}},$$old);
    }

    printf("\n------- Mapped Old var to note table-------------------\n");
    printf("%-23.23s|%-23.23s|%-23.23s\n",'Node maped',' ');
    $old=$NEWandOLDTbl{'Other'}->{'NDMAP'}->{'SCALR'};
    @olds=sort(@$old);
    foreach $old (@olds){
	printf("%-23.23s|%-23.23s|%-23.23s\n",' ',$old,$$old);
    }
    $old=$NEWandOLDTbl{'Other'}->{'NDMAP'}->{'ARRAY'};
    @olds=sort(@$old);
    foreach $old (@olds){
	printf("%-23.23s|%-23.23s|\n",'  A',$old);
	foreach $var (@$old){
	    printf("%-23.23s|%-23.23s|%-40.40s\n",' ',' ',$var);
	}
    }
    
    printf("\n------- Non Mapped Old var to note table----------------\n");
    printf("%-23.23s|%-23.23s|%-23.23s\n",'None maped',' ');
    $old=$NEWandOLDTbl{'Other'}->{'NONMAP'}->{'SCALR'};
    @olds=sort(@$old);
    foreach $old (@olds){
	printf("%-23.23s|%-23.23s|%-23.23s\n",' ',$old,$$old);
    }
    $old=$NEWandOLDTbl{'Other'}->{'NONMAP'}->{'ARRAY'};
    @olds=sort(@$old);
    foreach $old (@olds){
	printf("%-23.23s|%-23.23s|\n",'  A',$old);
	foreach $var (@$old){
	    printf("%-23.23s|%-23.23s|%-40.40s\n",' ',' ',$var);
	}
    }
}

1
