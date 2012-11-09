#
# Copyright (C) IPv6 Promotion Council,
# NIPPON TELEGRAPH AND TELEPHONE CORPORATION (NTT),
# Yokogwa Electoric Corporation, YASKAWA INFORMATION SYSTEMS Corporation
# and NTT Advanced Technology Corporation(NTT-AT) All rights reserved.
# 
# Technology Corporation.
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
########################################################################

        README of Conformance Test for Mobile Router


===============
0. Contents
===============
1. Demand condition
2. Setting of environment
3. Execution of test
4. Execution of test for IPv6 Ready Logo
5. Confirmation of result
6. Enhancing utility
 6.1. Analysis support
 6.2. Result backup
 6.3. Index of result backup
 6.4. Automatic re-execution


===============
1. Demand condition
===============
There is the following restriction conditions when the test is executed.

    1) The target should have the link-local address from fe80::/64 and
       mac address in all links.

    2) The target has to detect the movement from router advertisements.

    3) The support of IKEv1 begins in ver 4.0.
        IKEv1 - preshared key and aggressive mode
        The target has to establish necessary IPsecSA early as an
        initiator.

    *) The machine of a higher performance is requested as a tester so
       that the tester may respond early.


===============
2. Setting of environment
===============
It is necessary to set the test environment by using config.txt before
the test is executed.

A set value is described for the item in config.txt. An explanation and
a set value of each item have been described in config.txt. The default
value of each item that there is no setting in config.txt has been
described to config_orig.txt.

The value actually set can be confirmed in "Log" column after the tester
is executed. The value displayed in red is a value that comes off from
the specification of RFC.

The following two types relate to the selection of the tested range. The
value along within the tested range is described.

    # Test Item
    TEST_STATE_*

    # Optional
    TEST_FUNC_*

        Example)
        The range of a normal basic function is tested by the following
        setting.

        TEST_STATE_NORMAL YES
        TEST_FUNC_BASIC   YES

The following three types relate to implementation the target. The value
along implementation the target is described.

    # Implementation
    FUNC_DETAIL_*

        Example)
        Acknowledge(A) bit of the Binding Update that the target sends
        to Coresspondent Node is A.

        FUNC_DETAIL_MN_BU_TO_CN_A NO

    # Retransmission
    FUNC_DETAIL*

        Example)
        The target sends HA BU again.

        FUNC_DETAIL_BU_TO_HA_RETRANSMISSION YES

    # IPsec
    IPSEC_MANUAL_*

        Example)
        IPsec SA of the target is described. Or,
        IPsec SA of the target is matched to the value of config.txt.

        IPSEC_MANUAL_SA1_MN_HA0_PROTO   MH
        IPSEC_MANUAL_SA1_MN_HA0_SPI     2001
        IPSEC_MANUAL_SA1_MN_HA0_ESP     DES3CBC
        IPSEC_MANUAL_SA1_MN_HA0_ESP_KEY V6LC-000--12345678901234
        IPSEC_MANUAL_SA1_MN_HA0_AH      HMACSHA1
        IPSEC_MANUAL_SA1_MN_HA0_AH_KEY  V6LC-000--1234567890

The following types relate to the movement of the tester.

    # Others
    ENV_*

        Example)
        The method of the tester's initializing the target is described.

        ENV_INITIALIZE      BOOT

Some set values influence other set values.

    Example)
    The value of IPSEC_MANUAL_* becomes invalid because it sets the
    following value. It enters the state without IPsec.

    TEST_FUNC_IPSEC             NO

The hint of continuous execution of test item.

    Case 1) ENV_INITIALIZE to BOOT, and ENV_ENABLE_MOBILE to YES
        NUT has the reboot process by TN in each of test.
        NUT has the MR function process by TN in each of test.

    Case 2) ENV_INITIALIZE to BOOT, and ENV_ENABLE_MOBILE to NO
        NUT has the reboot process by TN in each of test.
        NUT has the MR function process in the reboot process.

    Case 3) ENV_INITIALIZE to NONE, and ENV_ENABLE_MOBILE to NO
        NUT don't reboot in each of test.
        NUT don't refresh MR function in each of test.
        In this case, TN tries to delete the entry on Binding Update
        List in each of test. But, the pre-test might influence the next
        test.

    Case 4) ENV_INITIALIZE to NONE, and ENV_ENABLE_MOBILE to YES
        NUT don't reboot in each of test.
        NUT has the MR function process by TN in each of test.
        In this case, working of the MR function process should be made
        operation that refreshes MR daemon.
        e.g.)
            $ <MR-daemon> <diseble>
            $ <MR-daemon> <enable>


===============
3. Execution of test
===============
The test is executed by the following commands.

    % make test

The test is executed within the range of the number specified by the
following commands.

    Example)
    The test is executed within the range from the test number 1 to 10.

    % make test "AROPT= -s 1 -e 10"

It is necessary to delete the result from the folder again to execute
the test. The test result is deleted by the following commands.

    % make clean


===============
4. Execution of test for IPv6 Ready Logo
===============
The test is executed by the following commands.
    - Basic function and selected advanced function(s) without
      "Fine-Grain Selectors" function.

        % make ipv6ready_p2

    - Basic function and selected advanced function(s) with
      "Fine-Grain Selectors" function.

        % make ipv6ready_p2_fine_grain

The following parameters and values must be set in config.txt for IPv6
Ready Logo. In outside a stipulated range, an error message will be
displayed.

    TEST_STATE_NORMAL                   YES
    TEST_STATE_ABNORMAL                 YES

    TEST_FUNC_BASIC                     YES
    TEST_FUNC_IPSEC                     YES
    TEST_FUNC_IKE                       NO

    FUNC_DETAIL_BU_TO_HA_ALTCOA         YES

    IPSEC_MANUAL_SA1_MN_HA0_PROTO       MH   # for Basic Function
    IPSEC_MANUAL_SA2_HA0_MN_PROTO       MH   # for Basic Function
    IPSEC_MANUAL_SA1_MN_HA1_PROTO       MH   # for Basic Function
    IPSEC_MANUAL_SA2_HA1_MN_PROTO       MH   # for Basic Function

    IPSEC_MANUAL_SA7_MN_HA0_PROTO       NONE
    IPSEC_MANUAL_SA8_HA0_MN_PROTO       NONE
    IPSEC_MANUAL_SA7_MN_HA1_PROTO       NONE
    IPSEC_MANUAL_SA8_HA1_MN_PROTO       NONE

    IPSEC_MANUAL_SA9_MN_HA0_PROTO       NONE
    IPSEC_MANUAL_SA10_HA0_MN_PROTO      NONE
    IPSEC_MANUAL_SA9_MN_HA1_PROTO       NONE
    IPSEC_MANUAL_SA10_HA1_MN_PROTO      NONE

    ENV_INITIALIZE                      BOOT

Logo target is NEMO extended home network and HoA(from HNP)
    FUNC_DETAIL_HOA_ADDRESS             HOME

MR must implement at least one of Implicit mode or Explicit mode.
It is necessary to test either one specs along the subcategory of Logo.

    Test-1. "FUNC_DETAIL_MR_REGISTRATION_MODE IMPLICIT" or 
            "FUNC_DETAIL_MR_REGISTRATION_MODE EXPLICIT"

If MR implements both mode Implicit mode and Explicit mode.
It is necessary to test in two setting.
The following parameters and values must be set in each test.

    Test-1. "FUNC_DETAIL_MR_REGISTRATION_MODE IMPLICIT"
    Test-2. "FUNC_DETAIL_MR_REGISTRATION_MODE EXPLICIT"

The following parameters and values must be set with Advanced Function
"Real Home Link".

    TEST_FUNC_REAL_HOME_LINK            YES

The following parameters and values must be set with Advanced Function
"Dynamic Home Agent Address Discovery".

    TEST_FUNC_DHAAD                     YES

The following parameters and values must be set with Advanced Function
"Mobile Prefix Discovery (MPS/MPA w/ IPsec)".

    TEST_FUNC_MPD                       YES
    IPSEC_MANUAL_SA5_MN_HA0_PROTO       ICMP # for Basic Function
    IPSEC_MANUAL_SA6_HA0_MN_PROTO       ICMP # for Basic Function
    IPSEC_MANUAL_SA5_MN_HA1_PROTO       ICMP # for Basic Function
    IPSEC_MANUAL_SA6_HA1_MN_PROTO       ICMP # for Basic Function

The following parameters and values must be set with Advanced Function
"Fine-Grain Selectors".

    IPSEC_MANUAL_SA1_MN_HA0_PROTO       BU   # for Basic Function
    IPSEC_MANUAL_SA2_HA0_MN_PROTO       BA   # for Basic Function
    IPSEC_MANUAL_SA1_MN_HA1_PROTO       BU   # for Basic Function
    IPSEC_MANUAL_SA2_HA1_MN_PROTO       BA   # for Basic Function

    IPSEC_MANUAL_SA5_MN_HA0_PROTO       MPS  # for Basic Function
    IPSEC_MANUAL_SA6_HA0_MN_PROTO       MPA  # for Basic Function
    IPSEC_MANUAL_SA5_MN_HA1_PROTO       MPS  # for Basic Function
    IPSEC_MANUAL_SA6_HA1_MN_PROTO       MPA  # for Basic Function


===============
5. Confirmation of result
===============
The result is displayed in "Result" column. 

    PASS               : PASS was done to the test.
    FAIL               : Abnormality was detected with the test point
                         that did focus.
    Initialization Fail: Abnormality was detected before the test point
                         that did focus.
    WARN               : The point that had to be noted was detected.
                         It may be judged as failure by the Logo judge.
    SKIP               : The test was skipped. It is a test item not
                         satisfied test condition (config.txt).
    TBD                : Before test is executed.
    SIGNAL             : The signal interrupted.

A detailed packet log can be confirmed to the test item that has been
executed in "Log" column. Moreover, the comment can be confirmed about
the result.

    Reference) the necessary time
    NUT is KAME project
    1) "make test"
        - config: reboot, ipsec, and all finction.
        - total 146, run 87, skip 59.
        - 4.5 hours


===============
6. Enhancing utility
===============
===============
6.1. Analysis support
===============
It might be bright that it is time when it displays "PASS", and
abnormality occur. It is because the packet not assumed with the tester
cannot be inspected. It is necessary to confirm "Log". Moreover, the
following commands will help the confirmation.

    % analyzer.pl

    "analysis.html" is made. In "analysis.html", the packet of
    overlooking and the comment on the result in "Comments" column is
    having a look displayed.


===============
6.2. Result backup
===============
The test result is backed up by the following commands.

    % result_bkup.sh <target name>

    The test result is copied in "RESULT/<target name>_<time stamp>".


===============
6.3. Index of result backup
===============
The index that brings the result of the backup together is made.

    % result_index.sh <target name>

    The following HTML files are made.

        RESULT/<target name>_report.html
        RESULT/<target name>_analysis.html


===============
6.4. Automatic re-execution
===============
The test is restarted to the range of specification even if it
interrupts because of the error.

    % powerplay.sh <target name> <start no> <end no>

    The result until interrupting is preserved by result_bkup.sh. It
    restarts from the interrupting test number and it executes it to the
    range of specification.


# End of file
