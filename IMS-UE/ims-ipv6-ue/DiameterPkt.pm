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
#============================================
# Diameter
#============================================
%DIAMETERDic=
(
  1  => {'NM'=>'UserName',                    'ST'=>'DIAMETER_USERNAME'},
  25 => {'NM'=>'Class',                       'ST'=>'DIAMETER_CLASS'},
  27 => {'NM'=>'SessionTimeout',              'ST'=>'DIAMETER_SESSION-TIMEOUT'},
  33 => {'NM'=>'ProxyState',                  'ST'=>'DIAMETER_PROXY-STATE'},
  44 => {'NM'=>'AccountingSessionID',         'ST'=>'DIAMETER_ACCOUNTING-SESSION-ID'},
  50 => {'NM'=>'AcctMultiSessionID',          'ST'=>'DIAMETER_ACCT-MULTI-SESSION-ID'},
  55 => {'NM'=>'EventTimestamp',              'ST'=>'DIAMETER_EVENT-TIMESTAMP'},
  85 => {'NM'=>'AcctInterimInterval',         'ST'=>'DIAMETER_ACCT-INTERIM-INTERVAL'},
  257=> {'NM'=>'HostIpAddress',               'ST'=>'DIAMETER_HOST-IP-ADDRESS'},
  258=> {'NM'=>'AuthApplicationID',           'ST'=>'DIAMETER_AUTH-APPLICATION-ID'},
  259=> {'NM'=>'AcctApplicationID',           'ST'=>'DIAMETER_ACCT-APPLICATION-ID'},
  260=> {'NM'=>'VendorSpecificApplicationID', 'ST'=>'DIAMETER_VENDOR-SPECIFIC-APPLICATION-ID'},
  261=> {'NM'=>'RedirectHostUsage',           'ST'=>'DIAMETER_REDIRECT-HOST-USAGE'},
#  262=> {'NM'=>'RedirectMaxCacheTime',        'ST'=>'DIAMETER_REDIRECT-MAX-CACHE-TIME'},
  263=> {'NM'=>'SessionID',                   'ST'=>'DIAMETER_SESSION-ID'},
  264=> {'NM'=>'OriginHost',                  'ST'=>'DIAMETER_ORIGIN-HOST'},
  265=> {'NM'=>'SupportedVendorID',           'ST'=>'DIAMETER_SUPPORTED-VENDOR-ID'},
  266=> {'NM'=>'VendorID',                    'ST'=>'DIAMETER_VENDOR-ID'},
#  267=> {'NM'=>'FirmwareRevision',            'ST'=>'DIAMETER_FIRMWARE-REVISION'},
  268=> {'NM'=>'ResultCode',                  'ST'=>'DIAMETER_RESULT-CODE'},
  269=> {'NM'=>'ProductName',                 'ST'=>'DIAMETER_PRODUCT-NAME'},
  270=> {'NM'=>'SessionBinding',              'ST'=>'DIAMETER_SESSION-BINDING'},
  271=> {'NM'=>'SessionServerFailover',       'ST'=>'DIAMETER_SESSION-SERVER-FAILOVER'},
#  272=> {'NM'=>'MultiRoundTimeOut',           'ST'=>'DIAMETER_MULTI-ROUND-TIME-OUT'},
  273=> {'NM'=>'DisconnectCause',             'ST'=>'DIAMETER_DISCONNECT-CAUSE'},
  274=> {'NM'=>'AuthRequestType',             'ST'=>'DIAMETER_AUTH-REQUEST-TYPE'},
#  276=> {'NM'=>'AuthGracePeriod',             'ST'=>'DIAMETER_AUTH-GRACE-PERIOD'},
  277=> {'NM'=>'AuthSessionState',            'ST'=>'DIAMETER_AUTH-SESSION-STATE'},
  278=> {'NM'=>'OriginStateID',               'ST'=>'DIAMETER_ORIGIN-STATE-ID'},
  279=> {'NM'=>'FailedAVP',                   'ST'=>'DIAMETER_FAILED-AVP'},
  280=> {'NM'=>'ProxyHost',                   'ST'=>'DIAMETER_PROXY-HOST'},
  281=> {'NM'=>'ErrorMessage',                'ST'=>'DIAMETER_ERROR-MESSAGE'},
  282=> {'NM'=>'RouteRecord',                 'ST'=>'DIAMETER_ROUTE-RECORD'},
  283=> {'NM'=>'DestinationRealm',            'ST'=>'DIAMETER_DESTINATION-REALM'},
  284=> {'NM'=>'ProxyInfo',                   'ST'=>'DIAMETER_PROXY-INFO'},
  285=> {'NM'=>'ReAuthRequestType',           'ST'=>'DIAMETER_RE-AUTH-REQUEST-TYPE'},
#  287=> {'NM'=>'AccountingSubSessionID',      'ST'=>'DIAMETER_ACCOUNTING-SUB-SESSION-ID'},
  291=> {'NM'=>'AuthorizationLifetime',       'ST'=>'DIAMETER_AUTHORIZATION-LIFETIME'},
  292=> {'NM'=>'RedirectHost',                'ST'=>'DIAMETER_REDIRECT-HOST'},
  293=> {'NM'=>'DestinationHost',             'ST'=>'DIAMETER_DESTINATION-HOST'},
  294=> {'NM'=>'ErrorReportingHost',          'ST'=>'DIAMETER_ERROR-REPORTING-HOST'},
  295=> {'NM'=>'TerminationCause',            'ST'=>'DIAMETER_TERMINATION-CAUSE'},
  296=> {'NM'=>'OriginRealm',                 'ST'=>'DIAMETER_ORIGIN-REALM'},
  297=> {'NM'=>'ExperimentalResult',          'ST'=>'DIAMETER_EXPERIMENTAL-RESULT'},
  298=> {'NM'=>'ExperimentalResultCode',      'ST'=>'DIAMETER_EXPERIMENTAL-RESULT-CODE'},
#  299=> {'NM'=>'InbandSecurityID',            'ST'=>'DIAMETER_INBAND-SECURITY-ID'},
#  300=> {'NM'=>'E2ESequence',                 'ST'=>'DIAMETER_E2E-SEQUENCE'},
  480=> {'NM'=>'AccountingRecordType',        'ST'=>'DIAMETER_ACCOUNTING-RECORD-TYPE'},
#  483=> {'NM'=>'AccountingRealtimeRequired',  'ST'=>'DIAMETER_ACCOUNTING-REALTIME-REQUIRED'},
  485=> {'NM'=>'AccountingRecordNumber',      'ST'=>'DIAMETER_ACCOUNTING-RECORD-NUMBER'},
  600=> {'NM'=>'VisitedNetworkIdentity',      'ST'=>'DIAMETER_VISITED-NETWORK-IDENTITY'},
  601=> {'NM'=>'PublicIdentity',              'ST'=>'DIAMETER_PUBLIC-IDENTITY'},
  602=> {'NM'=>'ServerName',                  'ST'=>'DIAMETER_SERVER-NAME'},
  603=> {'NM'=>'ServerCapabilities',          'ST'=>'DIAMETER_SERVER-CAPABILITIES'},
  604=> {'NM'=>'MandatoryCapabilities',       'ST'=>'DIAMETER_MANDATORY-CAPABILITIES'},
  605=> {'NM'=>'OptionalCapabilities',        'ST'=>'DIAMETER_OPTIONAL-CAPABILITIES'},
  606=> {'NM'=>'UserData',                    'ST'=>'DIAMETER_USER-DATA'},
  607=> {'NM'=>'SIPNumberAuthItems',          'ST'=>'DIAMETER_SIP-NUMBER-AUTH-ITEMS'},
  608=> {'NM'=>'SIPAuthenticationScheme',     'ST'=>'DIAMETER_SIP-AUTHENTICATION-SCHEME'},
  609=> {'NM'=>'SIPAuthenticate',             'ST'=>'DIAMETER_SIP-AUTHENTICATE'},
  610=> {'NM'=>'SIPAuthorization',            'ST'=>'DIAMETER_SIP-AUTHORIZATION'},
  611=> {'NM'=>'SIPAuthcenticationContext',   'ST'=>'DIAMETER_SIP-AUTHCENTICATION-CONTEXT'},
  612=> {'NM'=>'SIPAuthDataItem',             'ST'=>'DIAMETER_SIP-AUTH-DATA-ITEM'},
  613=> {'NM'=>'SIPItemNumber',               'ST'=>'DIAMETER_SIP-ITEM-NUMBER'},
  614=> {'NM'=>'ServerAssignmentType',        'ST'=>'DIAMETER_SERVER-ASSIGNMENT-TYPE'},
  615=> {'NM'=>'DeregistrationReason',        'ST'=>'DIAMETER_DEREGISTRATION-REASON'},
  616=> {'NM'=>'ReasonCode',                  'ST'=>'DIAMETER_REASON-CODE'},
  617=> {'NM'=>'ReasonInfo',                  'ST'=>'DIAMETER_REASON-INFO'},
  618=> {'NM'=>'ChargingInformation',         'ST'=>'DIAMETER_CHARGING-INFORMATION'},
  619=> {'NM'=>'PrimaryEventChargingFunctionName','ST'=>'DIAMETER_PRIMARY-EVENT-CHARGING-FUNCTION-NAME'},
  620=> {'NM'=>'SecondaryEventChargingFunctionName','ST'=>'DIAMETER_SECONDARY-EVENT-CHARGING-FUNCTION-NAME'},
  621=> {'NM'=>'PrimaryChargingCollectionFunctionName','ST'=>'DIAMETER_PRIMARY-CHARGING-COLLECTION-FUNCTION-NAME'},
  622=> {'NM'=>'SecondaryChargingCollectionFunctionName','ST'=>'DIAMETER_SECONDARY-CHARGING-COLLECTION-FUNCTION-NAME'},
  623=> {'NM'=>'UserAuthorizationType',       'ST'=>'DIAMETER_USER-AUTHORIZATION-TYPE'},
  624=> {'NM'=>'UserDataAlreadyAvailable',    'ST'=>'DIAMETER_USER-DATA-ALREADY-AVAILABLE'},
  625=> {'NM'=>'ConfidentialityKey',          'ST'=>'DIAMETER_CONFIDENTIALITY-KEY'},
  626=> {'NM'=>'IntegrityKey',                'ST'=>'DIAMETER_INTEGRITY-KEY'},
  628=> {'NM'=>'SupportedFeatures',           'ST'=>'DIAMETER_SUPPORTED-FEATURES'},
  629=> {'NM'=>'FeatureListID',               'ST'=>'DIAMETER_FEATURE-LIST-ID'},
  630=> {'NM'=>'FeatureList',                 'ST'=>'DIAMETER_FEATURE-LIST'},
  631=> {'NM'=>'SupportedApplications',       'ST'=>'DIAMETER_SUPPORTED-APPLICATIONS'},
  632=> {'NM'=>'AssociatedIdentities',        'ST'=>'DIAMETER_ASSOCIATED-IDENTITIES'},
  633=> {'NM'=>'OriginatingRequest',          'ST'=>'DIAMETER_ORIGINATING-REQUEST'},
  634=> {'NM'=>'WildcardedSPI',               'ST'=>'DIAMETER_WILDCARDED-SPI'},
  635=> {'NM'=>'SipDigestAuthenticate',       'ST'=>'DIAMETER_SIP-DIGEST-AUTHENTICATE'},
  636=> {'NM'=>'WildcardedIMPU',              'ST'=>'DIAMETER_WILDCARDED-IMPU'},
  637=> {'NM'=>'UARFlags',                    'ST'=>'DIAMETER_UAR-FLAGS'},
  638=> {'NM'=>'LooseRouteIndication',        'ST'=>'DIAMETER_LOOSE-ROUTE-INDICATION'},
  639=> {'NM'=>'SCSCFRestorationInfo',        'ST'=>'DIAMETER_SCSCF-RESTORATION-INFO'},
  640=> {'NM'=>'Path',                        'ST'=>'DIAMETER_PATH'},
  641=> {'NM'=>'Contact',                     'ST'=>'DIAMETER_CONTACT'},
  642=> {'NM'=>'SubscriptionInfo',            'ST'=>'DIAMETER_SUBSCRIPTION-INFO'},
  643=> {'NM'=>'CallIDSIPHeader',             'ST'=>'DIAMETER_CALL-ID-SIP-HEADER'},
  644=> {'NM'=>'FromSIPHeader',               'ST'=>'DIAMETER_FROM-SIP-HEADER'},
  645=> {'NM'=>'ToSIPHeader',                 'ST'=>'DIAMETER_TO-SIP-HEADER'},
  646=> {'NM'=>'RecordRoute',                 'ST'=>'DIAMETER_RECORD-ROUTE'},
  647=> {'NM'=>'AssociatedRegisteredIdentities','ST'=>'DIAMETER_ASSOCIATED-REGISTERED-IDENTITIES'},


 'AVP_UserName'                    => 1,
 'AVP_Class'                       => 25,
 'AVP_SessionTimeout'              => 27,
 'AVP_ProxyState'                  => 33,
 'AVP_AccountingSessionID'         => 44,
 'AVP_AcctMultiSessionID'          => 50,
 'AVP_EventTimestamp'              => 55,
 'AVP_AcctInterimInterval'         => 85,
 'AVP_HostIpAddress'               => 257,
 'AVP_AuthApplicationID'           => 258,
 'AVP_AcctApplicationID'           => 259,
 'AVP_VendorSpecificApplicationID' => 260,
 'AVP_RedirectHostUsage'           => 261,
 'AVP_RedirectMaxCacheTime'        => 262,
 'AVP_SessionID'                   => 263,
 'AVP_OriginHost'                  => 264,
 'AVP_SupportedVendorID'           => 265,
 'AVP_VendorID'                    => 266,
 'AVP_FirmwareRevision'            => 267,
 'AVP_ResultCode'                  => 268,
 'AVP_ProductName'                 => 269,
 'AVP_SessionBinding'              => 270,
 'AVP_SessionServerFailover'       => 271,
 'AVP_MultiRoundTimeOut'           => 272,
 'AVP_DisconnectCause'             => 273,
 'AVP_AuthRequestType'             => 274,
 'AVP_AuthGracePeriod'             => 276,
 'AVP_AuthSessionState'            => 277,
 'AVP_OriginStateID'               => 278,
 'AVP_FailedAVP'                   => 279,
 'AVP_ProxyHost'                   => 280,
 'AVP_ErrorMessage'                => 281,
 'AVP_RouteRecord'                 => 282,
 'AVP_DestinationRealm'            => 283,
 'AVP_ProxyInfo'                   => 284,
 'AVP_ReAuthRequestType'           => 285,
 'AVP_AccountingSubSessionID'      => 287,
 'AVP_AuthorizationLifetime'       => 291,
 'AVP_RedirectHost'                => 292,
 'AVP_DestinationHost'             => 293,
 'AVP_ErrorReportingHost'          => 294,
 'AVP_TerminationCause'            => 295,
 'AVP_OriginRealm'                 => 296,
 'AVP_ExperimentalResult'          => 297,
 'AVP_ExperimentalResultCode'      => 298,
 'AVP_InbandSecurityID'            => 299,
 'AVP_E2ESequencei'                => 300,
 'AVP_AccountingRecordType'        => 480,
 'AVP_AccountingRealtimeRequired'  => 483,
 'AVP_AccountingRecordNumber'      => 485,
 'AVP_VisitedNetworkIdentity'      => 600,
 'AVP_PublicIdentity'              => 601,
 'AVP_ServerName'                  => 602,
 'AVP_ServerCapabilities'          => 603,
 'AVP_MandatoryCapabilities'       => 604,
 'AVP_OptionalCapabilities'        => 605,
 'AVP_UserData'                    => 606,
 'AVP_SIPNumberAuthItems'          => 607,
 'AVP_SIPAuthenticationScheme'     => 608,
 'AVP_SIPAuthenticate'             => 609,
 'AVP_SIPAuthorization'            => 610,
 'AVP_SIPAuthcenticationContext'   => 611,
 'AVP_SIPAuthDataItem'             => 612,
 'AVP_SIPItemNumber'               => 613,
 'AVP_ServerAssignmentType'        => 614,
 'AVP_DeregistrationReason'        => 615,
 'AVP_ReasonCode'                  => 616,
 'AVP_ReasonInfo'                  => 617,
 'AVP_ChargingInformation'         => 618,
 'AVP_PrimaryEventChargingFunctionName' => 619,
 'AVP_SecondaryEventChargingFunctionName' => 620,
 'AVP_PrimaryChargingCollectionFunctionName' => 621,
 'AVP_SecondaryChargingCollectionFunctionName' => 622,
 'AVP_UserAuthorizationType'       => 623,
 'AVP_UserDataAlreadyAvailable'    => 624,
 'AVP_ConfidentialityKey'          => 625,
 'AVP_IntegrityKey'                => 626,
 'AVP_SupportedFeatures'           => 628,
 'AVP_FeatureListID'               => 629,
 'AVP_FeatureList'                 => 630,
 'AVP_SupportedApplications'       => 631,
 'AVP_AssociatedIdentities'        => 632,
 'AVP_OriginatingRequest'          => 633,
 'AVP_WildcardedSPI'               => 634,
 'AVP_SipDigestAuthenticate'       => 635,
 'AVP_WildcardedIMPU'              => 636,
 'AVP_UARFlags'                    => 637,
 'AVP_LooseRouteIndication'        => 638,
 'AVP_SCSCFRestorationInfo'        => 639,
 'AVP_Path'                        => 640,
 'AVP_Contact'                     => 641,
 'AVP_SubscriptionInfo'            => 642,
 'AVP_CallIDSIPHeader'             => 643,
 'AVP_FromSIPHeader'               => 644,
 'AVP_ToSIPHeader'                 => 645,
 'AVP_RecordRoute'                 => 646,
 'AVP_AssociatedRegisteredIdentities' => 647,

 'Capabilities-Exchange'          => 257,
 'Re-Auth'                        => 258,
 'Accounting'                     => 271,
 'Abort-Session'                  => 274,
 'Session-Termination'            => 275,
 'Device-Watchdog'                => 280,
 'Disconnect-Peer'                => 282,
 'User-Authorization'             => 300,
 'Server-Assignment'              => 301,
 'Location-Info'                  => 302,
 'Multimedia-Auth'                => 303,
# 'Multimedia-Authorization'      => 304,
 'Registration-Termination'       => 304,
 'Push-Profile'                   => 305,
 );

%DiameterCommandName=
(
 257  => 'Capabilities-Exchange',
 258  => 'Re-Auth',
 271  => 'Accounting',
 274  => 'Abort-Session',
 275  => 'Session-Termination',
 280  => 'Device-Watchdog',
 282  => 'Disconnect-Peer',
 300  => 'User-Authorization',
 301  => 'Server-Assignment',
 302  => 'Location-Info',
 303  => 'Multimedia-Auth',
# 304  => 'Multimedia-Authorization',
 304  => 'Registration-Termination',
 305  => 'Push-Profile',
);
%DiameterCommandName2=
(
 257  => 'CE',
 258  => 'RA',
 271  => 'AC',
 274  => 'AS',
 275  => 'ST',
 280  => 'DW',
 282  => 'DP',
 300  => 'UA',
 301  => 'SA',
 302  => 'LI',
 303  => 'MA',
 304  => 'RT',
 305  => 'PP',
);
%DiameterAppIDName=
(
 0x1000000 => '3GPP Cx',
 );
%DiameterAttName=
(
 1 => 'User-Name',
 25 => 'Class',
 27 => 'Session-Timeout',
 33 => 'Proxy-State',
 44 => 'Accounting-SessionID',
 50 => 'Acct-Multi-SessionID',
 55 => 'Event-Timestamp',
 85 => 'Acct-Interim-Interval',
 257 => 'Host-IP-Address',
 258 => 'Auth-Application-ID',
 259 => 'Acct-Application-ID',
 260 => 'Vendor-Specific-Application-ID',
 261 => 'Redirec-tHost-Usage',
 262 => 'Redirect-Max-Cache-Time',
 263 => 'Session-ID',
 264 => 'Origin-Host',
 265 => 'Supported-Vendor-ID',
 266 => 'Vendor-ID',
 267 => 'Firmware-Revision',
 268 => 'Result-Code',
 269 => 'Product-Name',
 270 => 'Session-Binding',
 271 => 'Session-Server-Failover',
 272 => 'Multi-Round-TimeOut',
 273 => 'Disconnect-Cause',
 274 => 'Auth-Request-Type',
 276 => 'Auth-Grace0Period',
 277 => 'Auth-Session-State',
 278 => 'Origin-State-ID',
 279 => 'Failed-AVP',
 280 => 'Proxy-Host',
 281 => 'Error-Message',
 282 => 'Route-Record',
 283 => 'Destination-Realm',
 284 => 'Proxy-Info',
 285 => 'Re-Auth-Request-Type',
 287 => 'Accounting-Sub-Session-ID',
 291 => 'Authorization-Lifetime',
 292 => 'Redirect-Host',
 293 => 'Destination-Host',
 294 => 'Error-Reporting-Host',
 295 => 'Termination-Cause',
 296 => 'Origin-Realm',
 297 => 'Experimental-Result',
 298 => 'Experimental-Result-Code',
 299 => 'Inband-Security-ID',
 300 => 'E2E-Sequencei',
 480 => 'Accounting-Record-Type',
 483 => 'Accounting-Realtime-Required',
 485 => 'Accounting-Record-Number',
 600 => 'Visited-Network-Identity',
 601 => 'Public-Identity',
 602 => 'Server-Name',
 603 => 'Server-Capabilities',
 604 => 'Mandatory-Capabilities',
 605 => 'Optional-Capabilities',
 606 => 'User-Data',
 607 => 'SIP-Number-Auth-Items',
 608 => 'SIP-Authentication-Scheme',
 609 => 'SIP-Authenticate',
 610 => 'SIP-Authorization',
 611 => 'SIP-Authcentication-Context',
 612 => 'SIP-Auth-Data-Item',
 613 => 'SIP-Item-Number',
 614 => 'Server-Assignment-Type',
 615 => 'Deregistration-Reason',
 616 => 'Reason-Code',
 617 => 'Reason-Info',
 618 => 'Changing-Information',
 619 => 'Primary-Event-Charging-Function-Name',
 620 => 'Secondary-Event-Charging-Function-Name',
 621 => 'Primary-Charging-Collection-Function-Name',
 622 => 'Secondary-Charging-Collection-Function-Name',
 623 => 'User-Authorization-Type',
 624 => 'User-Data-Already-Available',
 625 => 'Confidentiality-Key',
 626 => 'Integrity-Key',
 628 => 'Supported-Features',
 629 => 'Feature-List-ID',
 630 => 'Feature-List',
 631 => 'Supported-Applications',
 632 => 'Associated-Identities',
 633 => 'Originating-Request',
 634 => 'Wildcarded-SPI',
 635 => 'SIP-Digest-Authenticate',
 636 => 'Wildcarded-IMPU',
 637 => 'UAR-Flags',
 638 => 'Loose-Route-Indication',
 639 => 'SCSCF-Restoration-Info',
 640 => 'Path',
 641 => 'Contact',
 642 => 'Subscription-Info',
 643 => 'Call-ID-SIP-Header',
 644 => 'From-SIP-Header',
 645 => 'To-SIP-Header',
 646 => 'Record-Route',
 647 => 'Associated-Registered-Identities',
 );
%DiameterVendorName=
(
 10415 => '3GPP',
 );

@DIAMETERAttList =
(
 'DIAMETER_USERNAME',
 'DIAMETER_CLASS',
 'DIAMETER_SESSION-TIMEOUT',
 'DIAMETER_PROXY-STATE',
 'DIAMETER_ACCOUNTING-SESSION-ID',
 'DIAMETER_ACCT-MULTI-SESSION-ID',
 'DIAMETER_EVENT-TIMESTAMP',
 'DIAMETER_ACCT-INTERIM-INTERVAL',
 'DIAMETER_HOST-IP-ADDRESS',
 'DIAMETER_AUTH-APPLICATION-ID',
 'DIAMETER_ACCT-APPLICATION-ID',
 'DIAMETER_VENDOR-SPECIFIC-APPLICATION-ID',
 'DIAMETER_REDIRECT-HOST-USAGE',
 'DIAMETER_REDIRECT-MAX-CACHE-TIME',
 'DIAMETER_SESSION-ID',
 'DIAMETER_ORIGIN-HOST',
 'DIAMETER_SUPPORTED-VENDOR-ID',
 'DIAMETER_VENDOR-ID',
 'DIAMETER_FIRMWARE-REVISION',
 'DIAMETER_RESULT-CODE',
 'DIAMETER_PRODUCT-NAME',
 'DIAMETER_SESSION-BINDING',
 'DIAMETER_SESSION-SERVER-FAILOVER',
 'DIAMETER_MULTI-ROUND-TIME-OUT',
 'DIAMETER_DISCONNECT-CAUSE',
 'DIAMETER_AUTH-REQUEST-TYPE',
 'DIAMETER_AUTH-GRACE-PERIOD',
 'DIAMETER_AUTH-SESSION-STATE',
 'DIAMETER_ORIGIN-STATE-ID',
 'DIAMETER_FAILED-AVP',
 'DIAMETER_PROXY-HOST',
 'DIAMETER_ERROR-MESSAGE',
 'DIAMETER_ROUTE-RECORD',
 'DIAMETER_DESTINATION-REALM',
 'DIAMETER_PROXY-INFO',
 'DIAMETER_RE-AUTH-REQUEST-TYPE',
 'DIAMETER_ACCOUNTING-SUB-SESSION-ID',
 'DIAMETER_AUTHORIZATION-LIFETIME',
 'DIAMETER_REDIRECT-HOST',
 'DIAMETER_DESTINATION-HOST',
 'DIAMETER_ERROR-REPORTING-HOST',
 'DIAMETER_TERMINATION-CAUSE',
 'DIAMETER_ORIGIN-REALM',
 'DIAMETER_EXPERIMENTAL-RESULT',
 'DIAMETER_EXPERIMENTAL-RESULT-CODE',
 'DIAMETER_INBAND-SECURITY-ID',
 'DIAMETER_E2E-SEQUENCE',
 'DIAMETER_ACCOUNTING-RECORD-TYPE',
 'DIAMETER_ACCOUNTING-REALTIME-REQUIRED',
 'DIAMETER_ACCOUNTING-RECORD-NUMBER',
 'DIAMETER_VISITED-NETWORK-IDENTITY',
 'DIAMETER_PUBLIC-IDENTITY',
 'DIAMETER_SERVER-NAME',
 'DIAMETER_SERVER-CAPABILITIES',
 'DIAMETER_MANDATORY-CAPABILITIES',
 'DIAMETER_OPTIONAL-CAPABILITIES',
 'DIAMETER_USER-DATA',
 'DIAMETER_SIP-NUMBER-AUTH-ITEMS',
 'DIAMETER_SIP-AUTHENTICATION-SCHEME',
 'DIAMETER_SIP-AUTHENTICATE',
 'DIAMETER_SIP-AUTHORIZATION',
 'DIAMETER_SIP-AUTHCENTICATION-CONTEXT',
 'DIAMETER_SIP-AUTH-DATA-ITEM',
 'DIAMETER_SIP-ITEM-NUMBER',
 'DIAMETER_SERVER-ASSIGNMENT-TYPE',
 'DIAMETER_DEREGISTRATION-REASON',
 'DIAMETER_REASON-CODE',
 'DIAMETER_REASON-INFO',
 'DIAMETER_CHARGING-INFORMATION',
 'DIAMETER_PRIMARY-EVENT-CHARGING-FUNCTION-NAME',
 'DIAMETER_SECONDARY-EVENT-CHARGING-FUNCTION-NAME',
 'DIAMETER_PRIMARY-CHARGING-COLLECTION-FUNCTION-NAME',
 'DIAMETER_SECONDARY-CHARGING-COLLECTION-FUNCTION-NAME',
 'DIAMETER_USER-AUTHORIZATION-TYPE',
 'DIAMETER_USER-DATA-ALREADY-AVAILABLE',
 'DIAMETER_CONFIDENTIALITY-KEY',
 'DIAMETER_INTEGRITY-KEY',
 'DIAMETER_SUPPORTED-FEATURES',
 'DIAMETER_FEATURE-LIST-ID',
 'DIAMETER_FEATURE-LIST',
 'DIAMETER_SUPPORTED-APPLICATIONS',
 'DIAMETER_ASSOCIATED-IDENTITIES',
 'DIAMETER_ORIGINATING-REQUEST',
 'DIAMETER_WILDCARDED-SPI',
 'DIAMETER_SIP-DIGEST-AUTHENTICATE',
 'DIAMETER_WILDCARDED-IMPU',
 'DIAMETER_UAR-FLAGS',
 'DIAMETER_LOOSE-ROUTE-INDICATION',
 'DIAMETER_SCSCF-RESTORATION-INFO',
 'DIAMETER_PATH',
 'DIAMETER_CONTACT',
 'DIAMETER_SUBSCRIPTION-INFO',
 'DIAMETER_CALL-ID-SIP-HEADER',
 'DIAMETER_FROM-SIP-HEADER',
 'DIAMETER_TO-SIP-HEADER',
 'DIAMETER_RECORD-ROUTE',
 'DIAMETER_ASSOCIATED-REGISTERED-IDENTITIES',
 );

# reffer Wire-Shark : packet-diameter.c
%DiameterAddressFamily =
(
 'IPv4'=>1,
 'IPv6'=>2,
 'NSAP'=>3,
 'HDLC'=>4,
 'BBN'=>5,
 'IEEE-802'=>6,
 'E-163'=>7,
 'E-164'=>8,
 'F-69'=>9,
 'X-121'=>10,
 'IPX'=>11,
 'Appletalk'=>12,
 'Decnet4'=>13,
 'Vines'=>14,
 'E-164-NSAP'=>15,
 'DNS'=>16,
 'DistinguishedName'=>17,
 'AS'=>18,
 'XTPoIPv4'=>19,
 'XTPoIPv6'=>20,
 'XTPNative'=>21,
 'FibrePortName'=>22,
 'FibreNodeName'=>23,
 'GWID'=>24,
 );

%DiameterVendorID = 
(
 0x28af  => '3GPP',
 '3GPP'  => 0x28af,
 );

%DiameterAuthAppID = 
(
 0x1000000 => '3GPP CX/DX',
 0x1000001 => '3GPP Sh',
 0x1000005 => '3GPP Zh',
 '3GPP CX/DX' => 0x1000000,
 '3GPP Sh'    => 0x1000001, 
 '3GPP Zh'    => 0x1000005,
 );

%DiameterIMSResultCode = 
(
 'Diameter-Success'=>2001,
 'First-Registration'=>2001,
 'Subsequent-Registration'=>2002,
 'Unregistered-Service'=>2003,
 'Success-Server-Name-Not-Stored'=>2004,
 'User-Unknown'=>5001,
 'Identities-Dont-Match'=>5002,
 'Identity-Not-Registered'=>5003,
 'Roaming-Not-Allowed'=>5004,
 'Identity-Already-Registered'=>5005,
 'Auth-Scheme-Not-Supported'=>5006,
 'In-Assignment-Type'=>5007,
 'Too-Much-Data'=>5008,
 'Not-Supported-User-Data'=>5009,
 'Feature-Unsupported'=>5011,

 2001=>'First-Registration',
 2002=>'Subsequent-Registration',
 2003=>'Unregistered-Service',
 2004=>'Success-Server-Name-Not-Stored',
 5001=>'User-Unknown',
 5002=>'Identities-Dont-Match',
 5003=>'Identity-Not-Registered',
 5004=>'Roaming-Not-Allowed',
 5005=>'Identity-Already-Registered',
 5006=>'Auth-Scheme-Not-Supported',
 5007=>'In-Assignment-Type',
 5008=>'Too-Much-Data',
 5009=>'Not-Supported-User-Data',
 5011=>'Feature-Unsupported',
);

%DiameterResultCode =
(
 'Multi-Round-Auth' =>          1001,
 'Success' =>                   2001,
 'Command-Unsupported' =>       3001,
 'Unable-To-Deliver' =>         3002,
 'Realm-Not-Served' =>          3003,
 'Too-Busy' =>                  3004,
 'Loop-Detected' =>             3005,
 'Redirect-Indication' =>       3006,
 'Application-Unsupported' =>   3007,
 'Invalid-Hdr_Bits' =>          3008,
 'Invalid-AVP-Bits' =>          3009,
 'Unknown-Peer' =>              3010,
 'Authentication-Rejected' =>   4001,
 'Out-Of-Space' =>              4002,
 'Lost' =>                      4003,
 'AVP-Unsupported' =>           5001,
 'Unknown-Session-ID' =>        5002,
 'Authorization-Rejected' =>    5003,
 'Invalid-AVP-Value' =>         5004,
 'Missing-AVP' =>               5005,
 'Resources-Exceeded' =>        5006,
 'Contradicting-AVPS' =>        5007,
 'AVP-Not-Allowed' =>           5008,
 'AVP-Occurs-Too-Many-Times' => 5009,
 'No-Common-Application' =>     5010,
 'Unsupported-Version' =>       5011,
 'Unable-To-Comply' =>          5012,
 'Invalid-Bit-In-Header' =>     5013,
 'Invalid-AVP-Length' =>        5014,
 'Invalid-Message-Length' =>    5015,
 'Invalid-AVP-Bit-Combo' =>     5016,
 'No-Common-Security' =>        5017,

 1001=>'Multi-Round-Auth',
 2001=>'Success',
 3001=>'Command-Unsupported',
 3002=>'Unable-To-Deliver',
 3003=>'Realm-Not-Served',
 3004=>'Too-Busy',
 3005=>'Loop-Detected',
 3006=>'Redirect-Indication',
 3007=>'Application-Unsupported',
 3008=>'Invalid-Hdr_Bits',
 3009=>'Invalid-AVP-Bits',
 3010=>'Unknown-Peer',
 4001=>'Authentication-Rejected',
 4002=>'Out-Of-Space',
 4003=>'Lost',
 5001=>'AVP-Unsupported',
 5002=>'Unknown-Session-ID',
 5003=>'Authorization-Rejected',
 5004=>'Invalid-AVP-Value',
 5005=>'Missing-AVP',
 5006=>'Resources-Exceeded',
 5007=>'Contradicting-AVPS',
 5008=>'AVP-Not-Allowed',
 5009=>'AVP-Occurs-Too-Many-Times',
 5010=>'No-Common-Application',
 5011=>'Unsupported-Version',
 5012=>'Unable-To-Comply',
 5013=>'Invalid-Bit-In-Header',
 5014=>'Invalid-AVP-Length',
 5015=>'Invalid-Message-Length',
 5016=>'Invalid-AVP-Bit-Combo',
 5017=>'No-Common-Security',

 ## for IMS
 %DiameterIMSResultCode,
);


@DIAMETERHexMap = 
(
  {'##'=>'DIAMETER','#Name#'=>'DIAMETER',
   'sub'=>{'NM'=>'AVP','pattern'=>\@DIAMETERAttList},
   'field'=>
     [
      {'NM'=>'Version',        'EN'=>{'SZ'=>1,'TY'=>'uchar'},'IV'=>1,
                               'DE'=>{'SZ'=>1,'TY'=>'uchar'}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\\q{DIACalcHdrLen($F,$S)}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'Request',        'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Proxyable',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Error',          'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'ReTransmit',     'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>4},'IV'=>0,
                               'DE'=>{'SZ'=>0,'MK'=>4}},
      {'NM'=>'Command',        'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Command})}}, 
                               'DE'=>{'SZ'=>3,'TY'=>'hex','AC'=>\q{$F->{Command}=hex($V)}},
                               'TXT'=>{'AC'=>\q{$DiameterCommandName{$V}.'('.$V.')'}}},
      {'NM'=>'ApplicationID',  'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},
                               'TXT'=>{'AC'=>\q{$DiameterAppIDName{$V}.'('.$V.')'}}},
      {'NM'=>'HopByHopID',     'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'}},
      {'NM'=>'EndToEndID'   ,  'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'}},
      ]
  },

 {'##'=>'DIAMETER_USERNAME','#Name#'=>'UN','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>1,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>1},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{UserName})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'UserName',       'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_CLASS','#Name#'=>'CL','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>25,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>25},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{Class})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'Class',       'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SESSION-TIMEOUT','#Name#'=>'ST','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>27,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>27},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SessionTimeout', 'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_PROXY-STATE','#Name#'=>'PS','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>33,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>33},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{ProxyState})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ProxyState',     'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_ACCOUNTING-SESSION-ID','#Name#'=>'ACSI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>44,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>44},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{AccountingSessionID})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'AccountingSessionID','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_ACCT-MULTI-SESSION-ID','#Name#'=>'ACMSI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>50,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>50},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{AcctMultiSessionID})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'AcctMultiSessionID','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_EVENT-TIMESTAMP','#Name#'=>'ET','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>55,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>55},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'EventTimestamp', 'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_ACCT-INTERIM-INTERVAL','#Name#'=>'ACII','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>85,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>85},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'AcctInterimInterval', 'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_HOST-IP-ADDRESS','#Name#'=>'HIA','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>257,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>257},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=(IsIPV4Address($F->{HostIpAddress})?4:16)+2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'Family',         'EN'=>{'SZ'=>2,'TY'=>'short','AC'=>\q{IsIPV4Address($F->{HostIpAddress})?$DiameterAddressFamily{IPv4}:$DiameterAddressFamily{IPv6}}},
                               'DE'=>{'SZ'=>2,'TY'=>'short'},},
      {'NM'=>'HostIpAddress',  'EN'=>{'SZ'=>\q{$F->{Family} eq $DiameterAddressFamily{IPv4}?4:16},
			              'TY'=>\q{$F->{Family} eq $DiameterAddressFamily{IPv4}?'ipv4':'ipv6'}},
                               'DE'=>{'SZ'=>\q{$F->{Family} eq $DiameterAddressFamily{IPv4}?4:16},
		                      'TY'=>\q{$F->{Family} eq $DiameterAddressFamily{IPv4}?'ipv4':'ipv6'}}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_AUTH-APPLICATION-ID','#Name#'=>'AAI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>258,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>258},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'AuthApplicationID','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},
                               'TXT'=>{'AC'=>\q{$V?$DiameterAuthAppID{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_ACCT-APPLICATION-ID','#Name#'=>'ACAI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>259,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>259},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'AcctApplicationID', 'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_VENDOR-SPECIFIC-APPLICATION-ID','#Name#'=>'VSAI',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>260,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>260},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_REDIRECT-HOST-USAGE','#Name#'=>'RHU','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>261,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>261},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'RedirectHostUsage','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_SESSION-ID','#Name#'=>'SI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>263,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>263},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{SessionID})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SessionID','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_ORIGIN-HOST','#Name#'=>'OH','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>264,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>264},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{OriginHost})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'OriginHost',   'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SUPPORTED-VENDOR-ID','#Name#'=>'SVI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>265,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>265},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SupportedVendorID','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_VENDOR-ID','#Name#'=>'VI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>266,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>266},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'VendorID',       'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_RESULT-CODE','#Name#'=>'RC','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>268,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>268},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ResultCode',     'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},
                               'TXT'=>{'AC'=>\q{$DiameterResultCode{$V}.'('.$V.')'}}},
      ]
  },

 {'##'=>'DIAMETER_PRODUCT-NAME','#Name#'=>'PN','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>269,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>269},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{ProductName})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ProductName','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SESSION-BINDING','#Name#'=>'SB','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>270,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>270},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SessionBinding', 'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_SESSION-SERVER-FAILOVER','#Name#'=>'SSF','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>271,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>271},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SessionServerFailover','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_DISCONNECT-CAUSE','#Name#'=>'DC','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>273,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>273},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'DisconnectCause','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_AUTH-REQUEST-TYPE','#Name#'=>'ART','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>274,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>274},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'AuthRequestType','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_AUTH-SESSION-STATE','#Name#'=>'ASS','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>277,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>277},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'AuthSessionState','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_ORIGIN-STATE-ID','#Name#'=>'OSI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>278,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>278},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'OriginStateID',  'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_FAILED-AVP','#Name#'=>'FA',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>279,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>279},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_PROXY-HOST','#Name#'=>'PH','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>280,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>280},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{ProxyHost})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ProxyHost',      'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_ERROR-MESSAGE','#Name#'=>'EM','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>281,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>281},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{ErrorMessage})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ErrorMessage','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_ROUTE-RECORD','#Name#'=>'RRD','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>282,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>282},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{RouteRecord})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'RouteRecord',    'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_DESTINATION-REALM','#Name#'=>'DR','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>283,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>283},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{DestinationRealm})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'DestinationRealm','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_PROXY-INFO','#Name#'=>'PI',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>284,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>284},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_RE-AUTH-REQUEST-TYPE','#Name#'=>'RAET','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>285,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>285},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ReAuthRequestType', 'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_AUTHORIZATION-LIFETIME','#Name#'=>'AL','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>291,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>291},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'AuthorizationLifetime','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_REDIRECT-HOST','#Name#'=>'RH','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>292,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>292},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{RedirectHost})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'RedirectHost','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_DESTINATION-HOST','#Name#'=>'DH','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>293,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>293},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{DestinationHost})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'DestinationHost',       'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_ERROR-REPORTING-HOST','#Name#'=>'ERH','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>294,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>294},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{ErrorReportingHost})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ErrorReportingHost', 'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_TERMINATION-CAUSE','#Name#'=>'TC','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>295,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>295},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'TerminationCause','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_ORIGIN-REALM','#Name#'=>'OR','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>296,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>296},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{OriginRealm})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'OriginRealm',   'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_EXPERIMENTAL-RESULT','#Name#'=>'ER',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>297,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>297},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_EXPERIMENTAL-RESULT-CODE','#Name#'=>'ERC','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>298,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>298},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ExperimentalResultCode','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_ACCOUNTING-RECORD-TYPE','#Name#'=>'ACRT','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>480,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>480},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'AccountingRecordType','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_ACCOUNTING-RECORD-NUMBER','#Name#'=>'ACRN','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>485,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>485},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'AccountingRecordNumber','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_VISITED-NETWORK-IDENTITY','#Name#'=>'VNI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>600,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>600},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{VisitedNetworkIdentity})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'VisitedNetworkIdentity','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_PUBLIC-IDENTITY','#Name#'=>'PUI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>601,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>601},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{PublicIdentity})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex','AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'PublicIdentity', 'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SERVER-NAME','#Name#'=>'SN','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>602,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>602},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{ServerName})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ServerName','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SERVER-CAPABILITIES','#Name#'=>'SC',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>603,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>603},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_MANDATORY-CAPABILITIES','#Name#'=>'NC','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>604,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>604},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'MandatoryCapabilities','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_OPTIONAL-CAPABILITIES','#Name#'=>'OC','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>605,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>605},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'OptionalCapabilities','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_USER-DATA','#Name#'=>'UD','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>606,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>606},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{UserData})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'UserData','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SIP-NUMBER-AUTH-ITEMS','#Name#'=>'SNAI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>607,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>607},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SIPNumberAuthItems','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_SIP-AUTHENTICATION-SCHEME','#Name#'=>'SAS','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>608,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>608},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{SIPAuthenticationScheme})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SIPAuthenticationScheme','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SIP-AUTHENTICATE','#Name#'=>'SAE','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>609,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>609},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{SIPAuthenticate})/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SIPAuthenticate','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'hex'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SIP-AUTHORIZATION','#Name#'=>'SAO','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>610,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>610},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{SIPAuthorization})/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SIPAuthorization','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'hex'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SIP-AUTHCENTICATION-CONTEXT','#Name#'=>'SAC','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>611,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>611},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{SIPAuthcenticationContext})/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SIPAuthcenticationContext','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'hex'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SIP-AUTH-DATA-ITEM','#Name#'=>'SADI',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>612,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>612},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_SIP-ITEM-NUMBER','#Name#'=>'SIN','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>613,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>613},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SIPItemNumber', 'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_SERVER-ASSIGNMENT-TYPE','#Name#'=>'SAT','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>614,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>614},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ServerAssignmentType', 'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_DEREGISTRATION-REASON','#Name#'=>'DRR',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>615,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>615},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_REASON-CODE','#Name#'=>'RSC','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>616,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>616},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ReasonCode',     'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_REASON-INFO','#Name#'=>'RI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>617,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>617},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{ReasonInfo})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ReasonInfo',     'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_CHARGING-INFORMATION','#Name#'=>'CI',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>618,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>618},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_PRIMARY-EVENT-CHARGING-FUNCTION-NAME','#Name#'=>'PECFN','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>619,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>619},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{PrimaryEventChargingFunctionName})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'PrimaryEventChargingFunctionName','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SECONDARY-EVENT-CHARGING-FUNCTION-NAME','#Name#'=>'SECFN','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>620,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>620},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{SecondaryEventChargingFunctionName})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SecondaryEventChargingFunctionName','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_PRIMARY-CHARGING-COLLECTION-FUNCTION-NAME','#Name#'=>'PCCFN','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>621,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>621},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{PrimaryChargingCollectionFunctionName})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'PrimaryChargingCollectionFunctionName','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SECONDARY-CHARGING-COLLECTION-FUNCTION-NAME','#Name#'=>'SCCFN','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>622,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>622},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{SecondaryChargingCollectionFunctionName})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'SecondaryChargingCollectionFunctionName','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_USER-AUTHORIZATION-TYPE','#Name#'=>'UAT','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>623,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>623},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'UserAuthorizationType','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_USER-DATA-ALREADY-AVAILABLE','#Name#'=>'UDAA','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>624,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>624},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'UserDataAlreadyAvailable', 'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_CONFIDENTIALITY-KEY','#Name#'=>'CK','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>625,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>625},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{ConfidentialityKey})/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ConfidentialityKey','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'hex'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_INTEGRITY-KEY','#Name#'=>'IK','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>626,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>626},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{IntegrityKey})/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'IntegrityKey','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'hex'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SUPPORTED-FEATURES','#Name#'=>'SF',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>628,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>628},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_FEATURE-LIST-ID','#Name#'=>'FLI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>629,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>629},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'FeatureListID','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_FEATURE-LIST','#Name#'=>'FL','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>630,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>630},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'FeatureList',    'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_SUPPORTED-APPLICATIONS','#Name#'=>'SA',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>631,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>631},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_ASSOCIATED-IDENTITIES','#Name#'=>'AI',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>632,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>632},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_ORIGINATING-REQUEST','#Name#'=>'ORQ','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>633,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>633},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'OriginatingRequest','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_WILDCARDED-SPI','#Name#'=>'WCS','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>634,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>634},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{WildcardedSPI})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'WildcardedSPI','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SIP-DIGEST-AUTHENTICATE','#Name#'=>'SDA',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>635,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>635},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_WILDCARDED-IMPU','#Name#'=>'WCI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>636,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>636},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{WildcardedIMPU})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'WildcardedIMPU','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_UAR-FLAGS','#Name#'=>'UF','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>637,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>637},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'UARFlags',       'EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_LOOSE-ROUTE-INDICATION','#Name#'=>'LRI','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>638,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>638},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=4+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'LooseRouteIndication','EN'=>{'SZ'=>4,'TY'=>'long'},
                               'DE'=>{'SZ'=>4,'TY'=>'long'},}
      ]
  },

 {'##'=>'DIAMETER_SCSCF-RESTORATION-INFO','#Name#'=>'SRI',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>639,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>639},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_PATH','#Name#'=>'P','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>640,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>640},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{Path})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'Path','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_CONTACT','#Name#'=>'C','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>641,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>641},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{Contact})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'Contact','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_SUBSCRIPTION-INFO','#Name#'=>'SSI',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>642,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>642},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 {'##'=>'DIAMETER_CALL-ID-SIP-HEADER','#Name#'=>'CISH','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>643,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>643},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{CallIDSIPHeader})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'CallIDSIPHeader','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_FROM-SIP-HEADER','#Name#'=>'FSH','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>644,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>644},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{FromSIPHeader})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'FromSIPHeader','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_TO-SIP-HEADER','#Name#'=>'TSH','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>645,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>645},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{ToSIPHeader})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'ToSIPHeader','EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_RECORD-ROUTE','#Name#'=>'RDR','field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>646,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>646},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1, 'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($F->{RecordRoute})+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      {'NM'=>'RecordRoute',    'EN'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'},
                               'DE'=>{'SZ'=>\'$F->{Length}-($F->{Vendor}?4:0)-8','TY'=>'byte'}},
      {'NM'=>'Padding',        'EN'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'},
                               'DE'=>{'SZ'=>\'(4-($F->{Length})%4)%4','TY'=>'hex'}},
      ]
  },

 {'##'=>'DIAMETER_ASSOCIATED-REGISTERED-IDENTITIES','#Name#'=>'ARI',
  'sub'=>{'NM'=>'grp','AC'=>\q{$SZ=$F->{Length}-8-($F->{VndID}?4:0);},'pattern'=>\@DIAMETERAttList},
  'field'=>
     [
      {'NM'=>'Code',           'EN'=>{'SZ'=>4,'TY'=>'long'},'IV'=>647,
                               'DE'=>{'SZ'=>4,'TY'=>'long', 'PT'=>647},
                               'TXT'=>{'AC'=>\q{$DiameterAttName{$V}.'('.$V.')'}}},
      {'NM'=>'Vendor',         'EN'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1,'AC'=>\q{$F->{VndID}?1:0}},
                               'DE'=>{'SZ'=>1,'TY'=>'uchar','MK'=>1}},
      {'NM'=>'Mandatory',      'EN'=>{'SZ'=>0,'MK'=>1},'IV'=>1,
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Protected',      'EN'=>{'SZ'=>0,'MK'=>1},
                               'DE'=>{'SZ'=>0,'MK'=>1}},
      {'NM'=>'Reserved',       'EN'=>{'SZ'=>0,'MK'=>5},
                               'DE'=>{'SZ'=>0,'MK'=>5}},
      {'NM'=>'Length',         'EN'=>{'SZ'=>3,'TY'=>'hex','AC'=>\\q{sprintf("%06x",$F->{Length}=length($S)/2+8+($F->{VndID}?4:0))}},
                               'DE'=>{'SZ'=>3,'TY'=>'hex', 'AC'=>\q{$F->{Length}=hex($V)}}},
      {'NM'=>'VndID',          'EN'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\\q{$F->{VndID}?sprintf("%08x",$F->{VndID}):''}},
                               'DE'=>{'SZ'=>\'$F->{Vendor}?4:0','TY'=>'hex','AC'=>\q{$F->{VndID}=($F->{Vendor}?hex($V):0)}},
                               'TXT'=>{'AC'=>\q{$V?$DiameterVendorName{$V}.'('.$V.')':0}}},
      ]
  },

 );


sub DIACalcHdrLen {
    my($hexStr,$substr)=@_;
    $hexStr->{'Length'} = length($substr)/2+20;
    return sprintf("%06x",$hexStr->{'Length'});
}

# 
sub DIADicCheck {
    my($dic,$no,$name,$st);
    foreach $no (sort(keys(%DIAMETERDic))){
	unless(ref($DIAMETERDic{$no})){next;}
	$name = $DIAMETERDic{$no}->{'NM'};
	$st = $DIAMETERDic{$no}->{'ST'};
	unless( $HXPKTPatternDB{$st} ){
	    printf("[%s] %s no defined\n",$no,$st);
	    next;
	}
	if($DIAMETERDic{'AVP_'.$name} ne $no){
	    printf("[%s] %s not exist in DIAMETERDic\n",$no,'AVP_'.$name);
	}
	if($HXPKTPatternDB{$st}->{sub}){next;}
	unless(grep{$_->{'NM'} eq $name} @{$HXPKTPatternDB{$st}->{field}}){
	    printf("[%s] %s not exist in %s\n",$no,$name,$st);
	}
    }
}

#============================================
# 
#============================================
sub DIAMPacket {
    my($command,$request,$apID,$hbhID,$eteID,$avps)=@_;
    my($hexSt);
    $hexSt=CtPkAddHex('','DIAMETER',
		     {'Command'=>$DIAMETERDic{$command},
		      'Request'=> ($request=~/^req/i) ? 1:0,
		      'ApplicationID'=>$apID,'EndToEndID'=>$eteID,'HopByHopID'=>$hbhID});
    return DIAMPacketAVP($hexSt,$avps);
}
sub DIAMPacketAVP {
    my($upper,$avps)=@_;
    my($name,$avp,$val);

    foreach $avp (@$avps){
	foreach $name (keys(%$avp)){
	    $val=$avp->{$name};
	    unless(ref($val)){
		$val={$name=>$val};
	    }
	    # 
	    if($val->{'ResultCode'}){
		$val->{'ResultCode'}=$DiameterResultCode{$val->{'ResultCode'}};
	    }
	    if($val->{'VendorID'}){
		$val->{'VendorID'}=$DiameterVendorID{$val->{'VendorID'}};
	    }
	    if($val->{'VndID'}){
		$val->{'VndID'}=$DiameterVendorID{$val->{'VndID'}};
	    }
	    if($val->{'AuthApplicationID'}){
		$val->{'AuthApplicationID'}=$DiameterAuthAppID{$val->{'AuthApplicationID'}};
	    }
	    if($val->{'ExperimentalResultCode'}){
		$val->{'ExperimentalResultCode'}=$DiameterResultCode{$val->{'ExperimentalResultCode'}};
	    }
	    if($val->{'grp'}){
		DIAMPacketAVP(CtPkAddHex($upper,$DIAMETERDic{$DIAMETERDic{'AVP_'.$name}}->{'ST'},$val),$val->{'grp'});
	    }
	    else{
		CtPkAddHex($upper,$DIAMETERDic{$DIAMETERDic{'AVP_'.$name}}->{'ST'},$val);
	    }
	}
    }
    return $upper
}

sub DIAMAddAVPs {
    my($avps,$avp)=@_;
    my($av);
    unless(defined($avp)){return;}
    unless(ref($avp) eq 'ARRAY'){$avp=[$avp]}
    foreach $av (@$avp){
	push(@$avps,$av);
    }
}
sub DIAMAddAVP {
    my($avps,$key,$val,$multi,$grp,$mandatory)=@_;
    my($avp);
    if(!defined($val) || $val eq ''){
	if($mandatory){MsgPrint('WAR',"Diameter mandatory AVP(%s) empty in command(%s)\n",$key,$mandatory)}
	return;
    }

    if(!ref($val)){$val={$key=>$val,'Mandatory'=>$mandatory?1:0}}
    elsif(ref($val) eq 'HASH' && !defined($val->{'Mandatory'})){$val->{'Mandatory'}=$mandatory?1:0}

    if($grp){
	# 
	if(ref($val) eq 'HASH' && $val->{'grp'}){
	    if(!defined($val->{'Mandatory'})){$val->{'Mandatory'}=$mandatory?1:0}
	    push(@$avps,{$key=>$val});
	}
	else{
	    if($multi){
		# AVS[subAVS...],AVS[subAVS...],...
		if(ref($val) eq 'HASH'){$val=[[$val]];}
		elsif(ref($val) eq 'ARRAY'){
		    if(ref($val->[0]) ne 'ARRAY'){$val=[$val];}
		}
		else{
		    MsgPrint('ERR',"%s arg(%s) format invalid\n",$key,$val);
		}
		foreach $avp (@$val){
		    push(@$avps,{$key=>{'grp'=>$avp,'Mandatory'=>$mandatory?1:0}});
		    #            {AVS=>{grp=>[{AVS=>val},{AVS=>val}...]}}
		}
	    }
	    else{
		# AVS[subAVS...]
		if(ref($val) ne 'ARRAY'){$val=[$val]}
		push(@$avps,{$key=>{'grp'=>$val,'Mandatory'=>$mandatory?1:0}});
	    }
	}
	
    }
    elsif($multi){
	unless(ref($val) eq 'ARRAY'){$val=[$val]}
	foreach $avp (@$val){
	    if(!ref($avp)){$avp={$key=>$avp,'Mandatory'=>$mandatory?1:0}}
	    elsif(ref($avp) eq 'HASH' && !defined($avp->{'Mandatory'})){$avp->{'Mandatory'}=$mandatory?1:0}
	    push(@$avps,{$key=>$avp});
	}
    }
    else{
	push(@$avps,{$key=>$val});
    }
}

sub DiameterCommand {
    my($command,$req)=@_;
    return $DiameterCommandName2{$command} . ($req ? 'R':'A');
}

#============================================
# 
#============================================
# Device-Watchdog-Request
#
#  ::= < Diameter Header: 280, REQ >
#      { Origin-Host }
#      { Origin-Realm }
#      [ Origin-State-Id ]
#
sub DIAWatchdogReq {
    my($apID,$hbhID,$eteID,$host,$realm,$stateID)=@_;
    my($avp);
    $avp=[];

    DIAMAddAVP($avp,'OriginHost', $host,'','','Device-Watchdog-Request');
    DIAMAddAVP($avp,'OriginRealm',$realm,'','','Device-Watchdog-Request');
    DIAMAddAVP($avp,'OriginStateID',$stateID);

    return DIAMPacket('Device-Watchdog','req',$apID,$hbhID,$eteID,$avp);
}

# Device-Watchdog-Answer
#
#  ::= < Diameter Header: 280 >
#      { Result-Code }
#      { Origin-Host }
#      { Origin-Realm }
#      [ Error-Message ]
#    * [ Failed-AVP ]
#      [ Original-State-Id ]
#
sub DIAWatchdogAns {
    my($apID,$hbhID,$eteID,$result,$host,$realm,$errmsg,$stateID,$faildAVP)=@_;
    my($avp);
    $avp=[];

    DIAMAddAVP($avp,'ResultCode', $result,'','','Device-Watchdog-Answer');
    DIAMAddAVP($avp,'OriginHost', $host,'','','Device-Watchdog-Answer');
    DIAMAddAVP($avp,'OriginRealm',$realm,'','','Device-Watchdog-Answer');

    DIAMAddAVP($avp,'ErrorMessage',$errmsg);
    DIAMAddAVP($avp,'OriginStateID',$stateID);
    DIAMAddAVP($avp,'FailedAVP',$faildAVP,'multi','grp');

    return DIAMPacket('Device-Watchdog','',$apID,$hbhID,$eteID,$avp);
}

# Capabilities-Exchange-Request (CER)
#
#  ::= < Diameter Header: 257, REQ >
#       { Origin-Host }
#       { Origin-Realm }
#    1* { Host-IP-Address }
#       { Vendor-Id }
#       { Product-Name }
#       [ Origin-State-Id ]
#     * [ Supported-Vendor-Id ]
#     * [ Auth-Application-Id ]
#     * [ Inband-Security-Id ]
#     * [ Acct-Application-Id ]
#     * [ Vendor-Specific-Application-Id ]
#       [ Firmware-Revision ]
#     * [ AVP ]
sub DIACapabilitiesExReq {
    my($apID,$hbhID,$eteID,$host,$realm,$hostIP,$vendorID,$product,$stateID,$vndSpID,
       $authAppID,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Capabilities-Exchange-Request';
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'VendorID',   $vendorID,'','',$cmd);
    DIAMAddAVP($avp,'ProductName',$product,'','',$cmd);

    DIAMAddAVP($avp,'HostIpAddress',$hostIP,'multi');
    DIAMAddAVP($avp,'OriginStateID',$stateID);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp');
    DIAMAddAVP($avp,'AuthApplicationID',$authAppID,'multi');
    DIAMAddAVPs($avp,$etcAVP);

    return DIAMPacket('Capabilities-Exchange','req',$apID,$hbhID,$eteID,$avp);
}


# Capabilities-Exchange-Answer (CEA)
#
#  ::= < Diameter Header: 257 >
#       { Result-Code }
#       { Origin-Host }
#       { Origin-Realm }
#    1* { Host-IP-Address }
#       { Vendor-Id }
#       { Product-Name }
#       [ Origin-State-Id ]
#       [ Error-Message ]
#     * [ Failed-AVP ]
#     * [ Supported-Vendor-Id ]
#     * [ Auth-Application-Id ]
#     * [ Inband-Security-Id ]
#     * [ Acct-Application-Id ]
#     * [ Vendor-Specific-Application-Id ]
#       [ Firmware-Revision ]
#     * [ AVP ]
sub DIACapabilitiesExAns {
    my($apID,$hbhID,$eteID,$result,$host,$realm,$hostIP,$vendorID,$product,$stateID,
       $vndSpID,$errmsg,$authAppID,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Capabilities-Exchange-Answer';
    DIAMAddAVP($avp,'ResultCode', $result,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'VendorID',   $vendorID,'','',$cmd);
    DIAMAddAVP($avp,'ProductName',$product,'','',$cmd);

    DIAMAddAVP($avp,'HostIpAddress',$hostIP,'multi');
    DIAMAddAVP($avp,'OriginStateID',$stateID);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp');
    DIAMAddAVP($avp,'ErrorMessage',$errmsg);
    DIAMAddAVP($avp,'AuthApplicationID',$authAppID,'multi');
    DIAMAddAVPs($avp,$etcAVP);

    return DIAMPacket('Capabilities-Exchange','',$apID,$hbhID,$eteID,$avp);
}

# User-Authorization-Request (UAR)  <<IMS>>
#
#  ::= < Diameter Header: 283, REQ, PXY >
#    < Session-Id >
#    { Vendor-Specific-Application-Id }
#    { Auth-Session-State }
#    { Origin-Host }
#    { Origin-Realm }
#    [ Destination-Host ]
#    { Destination-Realm }
#    { User-Name }
#   *[ Supported-Features ]
#    { Public-Identity }
#    { Visited-Network-Identifier }
#    [ User-Authorization-Type ]
#    [ UAR-Flags ]
#   *[ AVP ]
#   *[ Proxy-Info ]
#   *[ Route-Record ]
#
sub DIAUserAuthorizationReq {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$authSesState,$host,$realm,$dstHost,$dstRealm,
       $user,$publicID,$visitedNetID,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='User-Authorization-Request';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'DestinationHost', $dstHost);
    DIAMAddAVP($avp,'DestinationRealm', $dstRealm,'','',$cmd);
    DIAMAddAVP($avp,'UserName', $user,'','',$cmd);
    DIAMAddAVP($avp,'PublicIdentity', $publicID,'','',$cmd);
    DIAMAddAVP($avp,'VisitedNetworkIdentity', $visitedNetID,'','',$cmd);
    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('User-Authorization','req',$apID,$hbhID,$eteID,$avp);
}


# User-Authorization-Answer (UAA)  <<IMS>>
#
#  ::= < Diameter Header: 283, PXY >
#    < Session-Id >
#    { Vendor-Specific-Application-Id }
#    [ Result-Code ]
#    [ Experimental-Result ]
#    { Auth-Session-State }
#    { Origin-Host }
#    { Origin-Realm }
#   *[ Supported-Features ]
#    [ Server-Name ]
#    [ Server-Capabilities ]
#    [ Wildcarded-IMPU ]
#   *[ AVP ]
#   *[ Failed-AVP ]
#   *[ Proxy-Info ]
#   *[ Route-Record ]
#
sub DIAUserAuthorizationAns {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$result,$extResult,$authSesState,$host,$realm,
       $srvName,$srvCapa,$wildIMPU,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='User-Authorization-Answer';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'ResultCode', $result);
    DIAMAddAVP($avp,'ExperimentalResult',$extResult,'multi','grp');
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'ServerName', $srvName);
    DIAMAddAVP($avp,'ServerCapabilities', $srvCapa,'','grp');
    DIAMAddAVP($avp,'WildcardedIMPU', $wildIMPU);
    DIAMAddAVPs($avp,$etcAVP);

    return DIAMPacket('User-Authorization','',$apID,$hbhID,$eteID,$avp);
}


# Multimedia-Auth-Request (MAR)  <<IMS>>
#
#  ::= < Diameter Header: 286, REQ, PXY >
#    < Session-Id >
#    { Vendor-Specific-Application-Id }
#    { Auth-Session-State }
#    { Origin-Host }
#    { Origin-Realm }
#    { Destination-Realm }
#    [ Destination-Host ]
#    { User-Name }
#   *[ Supported-Features ]
#    { Public-Identity }
#    { SIP-Auth-Data-Item }
#    { SIP-Number-Auth-Items } 
#    { Server-Name }
#   *[ AVP ]
#   *[ Proxy-Info ]
#   *[ Route-Record ]
#
sub DIAMultimediaAuthReq {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$authSesState,$host,$realm,$dstHost,$dstRealm,$user,
       $publicID,$sipAuthData,$sipNumAuth,$srvName,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Multimedia-Auth-Request';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'DestinationHost', $dstHost);
    DIAMAddAVP($avp,'DestinationRealm', $dstRealm,'','',$cmd);
    DIAMAddAVP($avp,'UserName', $user,'','',$cmd);
    DIAMAddAVP($avp,'PublicIdentity', $publicID,'','',$cmd);

    DIAMAddAVP($avp,'SIPAuthDataItem', $sipAuthData,'','grp',$cmd);
    DIAMAddAVP($avp,'SIPNumberAuthItems', $sipNumAuth,'','',$cmd);
    DIAMAddAVP($avp,'ServerName', $srvName,'','',$cmd);

    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('Multimedia-Auth','req',$apID,$hbhID,$eteID,$avp);
}

# Multimedia-Auth-Answer (MAA) <<IMS>>
#
#  ::= < Diameter Header: 286, PXY >
#     < Session-Id >
#     { Vendor-Specific-Application-Id }
#     [ Result-Code ]
#     [ Experimental-Result ]
#     { Auth-Session-State }
#     { Origin-Host }
#     { Origin-Realm }
#     [ User-Name ]
#    *[ Supported-Features ]
#     [ Public-Identity ]
#     [ SIP-Number-Auth-Items ]
#    *[SIP-Auth-Data-Item ]
#     [ Wildcarded-IMPU ]
#    *[ AVP ]
#    *[ Failed-AVP ]
#    *[ Proxy-Info ]
#    *[ Route-Record ]
#    
sub DIAMultimediaAuthAns {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$result,$extResult,$authSesState,$host,$realm,
       $user,$publicID,$sipAuthData,$sipNumAuth,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Multimedia-Auth-Answer';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'ResultCode', $result);
    DIAMAddAVP($avp,'ExperimentalResult',$extResult,'multi','grp');
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'UserName', $user);
    DIAMAddAVP($avp,'PublicIdentity', $publicID);

    DIAMAddAVP($avp,'SIPAuthDataItem', $sipAuthData,'','grp');
    DIAMAddAVP($avp,'SIPNumberAuthItems', $sipNumAuth);

    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('Multimedia-Auth','',$apID,$hbhID,$eteID,$avp);
}

# Server-Assignment-Request (SAR)  <<IMS>>
#
#  ::= < Diameter Header: 284, REQ, PXY >
#     < Session-Id >
#     { Vendor-Specific-Application-Id }
#     { Auth-Session-State }
#     { Origin-Host }
#     { Origin-Realm }
#     [ Destination-Host ]
#     { Destination-Realm }
#     [ User-Name ]
#    *[ Supported-Features ]
#    *[ Public-Identity ]
#     [ Wildcarded-PSI ]
#     [ Wildcarded-IMPU ]
#     { Server-Name }
#     { Server-Assignment-Type }
#     { User-Data-Already-Available }
#     [ SCSCF-Restoration-Info ]
#    *[ AVP ]
#    *[ Proxy-Info ]
#    *[ Route-Record ]
#
sub DIAServerAssignmentReq {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$authSesState,$host,$realm,$dstHost,$dstRealm,$user,
       $publicID,$srvName,$srvAssType,$usrDTAvail,$scscfRest,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Server-Assignment-Request';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'DestinationHost', $dstHost);
    DIAMAddAVP($avp,'DestinationRealm', $dstRealm,'','',$cmd);
    DIAMAddAVP($avp,'UserName', $user);
    DIAMAddAVP($avp,'PublicIdentity', $publicID,'multi');
    DIAMAddAVP($avp,'ServerName', $srvName,'','',$cmd);
    DIAMAddAVP($avp,'ServerAssignmentType', $srvAssType,'','',$cmd);
    DIAMAddAVP($avp,'UserDataAlreadyAvailable', $usrDTAvail,'','',$cmd);
    DIAMAddAVP($avp,'SCSCFRestorationInfo', $scscfRest,'','grp');

    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('Server-Assignment','req',$apID,$hbhID,$eteID,$avp);
}

# Server-Assignment-Answer (SAA)  <<IMS>>
#
#  ::= < Diameter Header: 284, PXY >
#     < Session-Id >
#     { Vendor-Specific-Application-Id }
#     [ Result-Code ]
#     [ Experimental-Result ]
#     { Auth-Session-State }
#     { Origin-Host }
#     { Origin-Realm }
#     [ User-Name ]
#    *[ Supported-Features ]
#     [ User-Data ]
#     [ Charging-Information ]
#     [ Associated-Identities ]
#     [ Loose-Route-Indication ]
#    *[ SCSCF-Restoration-Info ]
#     [ Associated-Registered-Identities ]
#     [ Server-Name ]
#    *[ AVP ]
#    *[ Failed-AVP ]
#    *[ Proxy-Info ]
#    *[ Route-Record ]
#
sub DIAServerAssignmentAns {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$result,$extResult,$authSesState,$host,$realm,
       $user,$userData,$chargingInfo,$accoID,$loosRoute,$scscfRest,$accRegID,$srvName,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Server-Assignment-Answer';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'ResultCode', $result);
    DIAMAddAVP($avp,'ExperimentalResult',$extResult,'multi','grp');
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'UserName', $user);
    DIAMAddAVP($avp,'UserData', $userData);
    DIAMAddAVP($avp,'ChargingInformation', $chargingInfo,'','grp');
    DIAMAddAVP($avp,'AssociatedIdentities', $accoID);
    DIAMAddAVP($avp,'LooseRouteIndication', $loosRoute);
    DIAMAddAVP($avp,'SCSCFRestorationInfo', $scscfRest,'multi','grp');
    DIAMAddAVP($avp,'AssociatedRegisteredIdentities', $accRegID);
    DIAMAddAVP($avp,'ServerName', $srvName);

    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('Server-Assignment','',$apID,$hbhID,$eteID,$avp);
}


# Location-Info-Request (LIR)  <<IMS>>
#
#  ::= < Diameter Header: 285, REQ, PXY >
#     < Session-Id >
#     { Vendor-Specific-Application-Id }
#     { Auth-Session-State }
#     { Origin-Host }
#     { Origin-Realm }
#     [ Destination-Host ]
#     { Destination-Realm }
#     [ Originating-Request ]
#    *[ Supported-Features ]
#     { Public-Identity }
#     [ User-Authorization-Type ]
#    *[ AVP ]
#    *[ Proxy-Info ]
#    *[ Route-Record ]
#
sub DIALocationInfoReq {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$authSesState,$host,$realm,$dstHost,$dstRealm,
       $orgRequest,$publicID,$usrAuthType,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Location-Info-Request';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'DestinationHost', $dstHost);
    DIAMAddAVP($avp,'DestinationRealm', $dstRealm,'','',$cmd);
    DIAMAddAVP($avp,'OriginatingRequest', $orgRequest,'','',$cmd);
    DIAMAddAVP($avp,'PublicIdentity', $publicID);
    DIAMAddAVP($avp,'UserAuthorizationType', $usrAuthType,'','',$cmd);

    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('Location-Info','req',$apID,$hbhID,$eteID,$avp);
}

# Location-Info-Answer (LIA)  <<IMS>>
#
#  ::= < Diameter Header: 285, PXY >
#     < Session-Id >
#     { Vendor-Specific-Application-Id }
#     [ Result-Code ]
#     [ Experimental-Result ]
#     { Auth-Session-State }
#     { Origin-Host }
#     { Origin-Realm }
#    *[ Supported-Features ]
#     [ Server-Name ]
#     [ Server-Capabilities ]
#     [ Wildcarded-PSI ]
#     [ Wildcarded-IMPU ]
#    *[ AVP ]
#    *[ Failed-AVP ]
#    *[ Proxy-Info ]
#    *[ Route-Record ]
#
sub DIALocationInfoAns {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$result,$extResult,$authSesState,$host,$realm,
       $srvName,$srvCapa,$wildIMPU,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Location-Info-Answer';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'ResultCode', $result);
    DIAMAddAVP($avp,'ExperimentalResult',$extResult,'multi','grp');
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'ServerName', $srvName);
    DIAMAddAVP($avp,'ServerCapabilities', $srvCapa,'','grp');
    DIAMAddAVP($avp,'WildcardedIMPU', $wildIMPU);

    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('Location-Info','',$apID,$hbhID,$eteID,$avp);
}


# Registration-Termination-Request (RTR)  <<IMS>>
#
#  ::= < Diameter Header: 304, REQ, PXY, 16777216 >
#     < Session-Id >
#     { Vendor-Specific-Application-Id }
#     { Auth-Session-State }
#     { Origin-Host }
#     { Origin-Realm }
#     { Destination-Host }
#     { Destination-Realm }
#     { User-Name }
#     [ Associated-Identities ]
#    *[ Supported-Features ]
#    *[ Public-Identity ]
#     { Deregistration-Reason }
#    *[ AVP ]
#    *[ Proxy-Info ]
#    *[ Route-Record ]
#    
sub DIARegTerminationReq {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$authSesState,$host,$realm,$dstHost,$dstRealm,
       $user,$accoID,$publicID,$deregReason,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Registration-Termination-Request';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'DestinationHost', $dstHost);
    DIAMAddAVP($avp,'DestinationRealm', $dstRealm,'','',$cmd);
    DIAMAddAVP($avp,'UserName', $user,'','',$cmd);
    DIAMAddAVP($avp,'AssociatedIdentities', $accoID);
    DIAMAddAVP($avp,'PublicIdentity', $publicID);
    DIAMAddAVP($avp,'DeregistrationReason', $deregReason,'','',$cmd);

    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('Registration-Termination','req',$apID,$hbhID,$eteID,$avp);
}

# Registration-Termination-Answer (RTA)  <<IMS>>
#
#  ::= < Diameter Header: 304, PXY, 16777216 >
#     < Session-Id >
#     { Vendor-Specific-Application-Id }
#     [ Result-Code ]
#     [ Experimental-Result ]
#     { Auth-Session-State }
#     { Origin-Host }
#     { Origin-Realm }
#     [ Associated-Identities ]
#    *[ Supported-Features ]
#    *[ AVP ]
#    *[ Failed-AVP ]
#    *[ Proxy-Info ]
#    *[ Route-Record ]
#
sub DIARegTerminationAns {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$result,$extResult,$authSesState,$host,$realm,
       $accoID,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Registration-Termination-Answer';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'ResultCode', $result);
    DIAMAddAVP($avp,'ExperimentalResult',$extResult,'multi','grp');
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'AssociatedIdentities', $accoID);

    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('Registration-Termination','',$apID,$hbhID,$eteID,$avp);
}


# Push-Profile-Request (PPR)  <<IMS>>
#
#  ::= < Diameter Header: 305, REQ, PXY, 16777216 >
#     < Session-Id >
#     { Vendor-Specific-Application-Id }
#     { Auth-Session-State }
#     { Origin-Host }
#     { Origin-Realm }
#     { Destination-Host }
#     { Destination-Realm }
#     { User-Name }
#    *[ Supported-Features ]
#     [ User-Data ]
#     [ Charging-Information ]
#     [ SIP-Auth-Data-Item ]
#    *[ AVP ]
#    *[ Proxy-Info ]
#    *[ Route-Record ]
#
sub DIAPushProfileReq {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$authSesState,$host,$realm,$dstHost,$dstRealm,
       $user,$userData,$chargingInfo,$sipAuthData,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Push-Profile-Request';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);
    DIAMAddAVP($avp,'DestinationHost', $dstHost,'','',$cmd);
    DIAMAddAVP($avp,'DestinationRealm', $dstRealm,'','',$cmd);
    DIAMAddAVP($avp,'UserName', $user,'','',$cmd);
    DIAMAddAVP($avp,'UserData', $userData);
    DIAMAddAVP($avp,'ChargingInformation', $chargingInfo,'','grp');
    DIAMAddAVP($avp,'SIPAuthDataItem', $sipAuthData,'','grp');

    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('Push-Profile','req',$apID,$hbhID,$eteID,$avp);
}


# Push-Profile-Answer (PPA)  <<IMS>>
#
#  ::= < Diameter Header: 305, PXY, 16777216 >
#     < Session-Id >
#     { Vendor-Specific-Application-Id }
#     [ Result-Code ]
#     [ Experimental-Result ]
#     { Auth-Session-State }
#     { Origin-Host }
#     { Origin-Realm }
#    *[ Supported-Features ]
#    *[ AVP ]
#    *[ Failed-AVP ]
#    *[ Proxy-Info ]
#    *[ Route-Record ]
#
sub DIAPushProfileAns {
    my($apID,$hbhID,$eteID, $session,$vndSpID,$result,$extResult,$authSesState,$host,$realm,$etcAVP)=@_;
    my($avp,$cmd);

    $avp=[];$cmd='Push-Profile-Answer';
    DIAMAddAVP($avp,'SessionID', $session,'','',$cmd);
    DIAMAddAVP($avp,'VendorSpecificApplicationID',$vndSpID,'multi','grp',$cmd);
    DIAMAddAVP($avp,'ResultCode', $result);
    DIAMAddAVP($avp,'ExperimentalResult',$extResult,'multi','grp');
    DIAMAddAVP($avp,'AuthSessionState', $authSesState,'','',$cmd);
    DIAMAddAVP($avp,'OriginHost', $host,'','',$cmd);
    DIAMAddAVP($avp,'OriginRealm',$realm,'','',$cmd);

    DIAMAddAVPs($avp,$etcAVP);
    
    return DIAMPacket('Push-Profile','',$apID,$hbhID,$eteID,$avp);
}

#
# Device-Watchdog
# $diam=DIAMPacket('Device-Watchdog','req',$apID,$hbhID,$eteID,
#                 [{'OriginHost'=>'hss.open-ism.host'},{'OriginRealm'=>'open-ism.host'}]);


1;

