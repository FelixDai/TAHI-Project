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

        README of Conformance Test for Home Agent


===============
0. Contents
===============
1. Demand condition
2. Setting of environment
3. Execution of test
4. Execution of test for IPv6 Ready Logo
5. Confirmation of result
6. Enhancing utility
 6.1. Result backup
 6.2. Index of result backup
 6.3. Automatic re-execution


===============
1. Demand condition
===============
There is the following restriction conditions when the test is executed.

    1) The target should have the link local address from fe80::/64 and
       mac address in all links.

    2) The support of IKEv1 begins in ver 4.0.
        IKEv1 - preshared key and aggressive mode
        The target has to establish necessary IPsecSA early as an
        responder.

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

The hint of continuous execution of test item

    Case 1) NEED_REBOOT to 1, and NEED_ENABLE to 1
      NUT is rebooted by a remote file at each test.
      HA daemon is enabled with a remote file at each test.
    
    Case 2) NEED_REBOOT to 1, and NEED_ENABLE to 0
      NUT is rebooted by a remote file at each test. 
      HA daemon is enabled by rebooting.
    
    Case 3) NEED_REBOOT to 0, and NEED_ENABLE to 0
      NUT is not rebooted at each test. NUT has been booted before the
      test is started. Also, HA daemon is not enabled at each test. HA
      daemon has been started before the test is started.
      
      * Next test might fail because of state of previous test.
    
    Case 4) NEED_REBOOT to 0, and NEED_ENABLE to 1
      NUT is not rebooted at each test. NUT has been booted before the
      test is started. On the other hand HA daemon is enabled with a
      remote file at each test.
      
      * In this case, working of a remote file should be made operation
        that refreshes HA daemon.
        e.g.)
          $ <HA-daemon> <diseble>
          $ <HA-daemon> <enable>


===============
3. Execution of test
===============
The test is executed by the following commands.

    % make test

The test is executed within the range of the number specified by the
following commands. 

    % make test "AROPT= -s 1 -e 10"

    The test is executed within the range from the test number 1 to 10.

It is necessary to delete the result from the folder again to execute
the test. The test result is deleted by the following commands.

    % make clean


===============
4. Execution of test for IPv6 Ready Logo
===============
The test is executed by the following commands.

  Basic Function (and Advanced Function except "Fine-Grain Selectors").
    % make ipv6ready_p2

  Advanced Function "Fine-Grain Selectors".
    % make ipv6ready_p2_fine_grain


About setteing config.txt
  The following parameters and values must be set.

    ROTATE_HOA                  0

    HAVE_IPSEC                  1
    HAVE_IKE                    0

    UNIQ_TRANS_SA               1
    GRAN_TRANS_SA_TYPE          0 # for Basic Function
    UNIQ_TUNNEL_SA              1
    GRAN_TUNNEL_SA_TYPE         0 # for Basic Function

    USE_SA1_SA2                 1
    USE_SA7_SA8                 0

  The following one or more parameters and values must be set.

    HAVE_HOME_LINK              1
    HAVE_FOREIGN_LINK           1

  The following parameters and values must be set with Advanced Function
  "Real Home Link".

    HAVE_REAL_HOME              1

  The following parameters and values must be set with Advanced Function
  "Dynamic Home Agent Address Discovery".

    HAVE_DHAAD                  1

  The following parameters and values must be set with Advanced Function
  "Mobile Prefix Discovery (MPS/MPA w/ IPsec)".

    HAVE_MPD                    1
    USE_SA5_SA6                 1

  The following parameters and values must be set with Advanced Function
  "Return Routability (HoTI/HoT w/ IPsec)".

    HAVE_RR                     1
    USE_SA3_SA4                 1

  The following parameters and values must be set with Advanced Function
  "Fine-Grain Selectors".

    GRAN_TRANS_SA_TYPE          1
    GRAN_TUNNEL_SA_TYPE         1


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
    SKIP               : The test was skipped. It is a test item not
                         satisfied test condition (config.txt).
    TBD                : Before test is executed.
    SIGNAL             : The signal interrupted.

A detailed packet log can be confirmed to the test item that has been
executed in "Log" column. Moreover, the comment can be confirmed about
the result.


 Reference of the necessary time)
   NUT is USAGI project umip-0.3
   1) "make test"
      - config: reboot, home and foreign links, ipsec, and all finction.
      - total 222, run 208, skip 14.
      - 9 hours
   2) "make test"
      - config: no reboot, home and foreign links, ipsec, and all finction.
      - total 222, run 208, skip 14.
      - 3.5 hours
   3) "make test"
      - config: no reboot, home link, ipsec, and all finction.
      - total 222, run 156, skip 66.
      - 2.2 hours


===============
6. Enhancing utility
===============
===============
6.1. Result backup
===============
The test result is backed up by the following commands.

    % result_bkup.sh <target name>

    The test result is copied in "RESULT/<target name>_<time stamp>".


===============
6.2. Index of result backup
===============
The index that brings the result of the backup together is made.

    % result_index.sh <target name>

    The following HTML files are made.

        RESULT/<target name>_report.html
        RESULT/<target name>_analysis.html


===============
6.3. Automatic re-execution
===============
The test is restarted to the range of specification even
if it interrupts because of the error. 

    % powerplay.sh <target name> <start no> <end no>

    The result until interrupting is preserved by result_bkup.sh. It
    restarts from the interrupting test number and it executes it to the
    range of specification.


# End of file
