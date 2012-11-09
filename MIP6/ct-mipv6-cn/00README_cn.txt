
        README of Conformance Test for Corresnpondent Node

===============
0. Contents
===============
1. Demand condition
2. Setting of environment
3. Execution of test
4. Execution of test for IPv6 Ready Logo
5. Confirmation of result
6. Special note

===============
1. Demand condition
===============
There is the following restriction conditions when the test
is executed. 

    1) The target node should have the link local address
       from fe80::/64 and mac address in all links.

    *) The machine of a higher performance is requested
       as a tester so that the tester may respond early.


===============
2. Setting of environment
===============
It is necessary to set the test environment by using
config.txt before the test is executed.

A set value is described for the item in config.txt.
An explanation and a set value of each item have been
described in config.txt. The default value of each item
that there is no setting in config.txt has been described
to config_orig.txt.

The value actually set can be confirmed in "Log" column
after the tester is executed. The value displayed in red
is a value that comes off from the specification of RFC.


===============
3. Execution of test
===============
The test is executed by the following commands. 

    % make test

The test is executed within the range of the number
specified by the following commands. 

    % make test "AROPT= -s 1 -e 10"

    The test is executed within the range from the test
    number 1 to 10.

It is necessary to delete the result from the folder again
to execute the test. The test result is deleted by the
following commands. 

    % make clean


===============
4. Execution of test for IPv6 Ready Logo
===============
About setteing config.txt
  The following parameters and values must be set.


  The following one or more parameters and values must be set.

  EXEC_NORMAL		ON
  EXEC_ABNORMAL		ON

  The following one or more parameters and values must be set
  to initialize CN test by test.

  INITIALIZE		BOOT

  The following one or more parameters and values must be set.

  RR_TIMEOUT		3
  TIMEOUT		2
  WAIT_RATELIMIT	1

  EALGO_DES		OFF
  AALGO_MD5		OFF

  When the test is executed, the regulations of other detailed
  settings may be shown by the error message.

The test is executed by the following commands.

    % make ipv6ready_p2


===============
5. Confirmation of result
===============
The result is displayed in "Result" column. 

    PASS               : PASS was done to the test.
    FAIL               : Abnormality was detected with the
                         test point that did focus.
    Initialization Fail: Abnormality was detected before
                         the test point that did focus.
    WARN               : The point that had to be noted
                         was detected.
    SKIP               : The test was skipped. It is a
                         test item not satisfied test
                         condition (config.txt).
    TBD                : Before test is executed.
    SIGNAL             : The signal interrupted.

A detailed packet log can be confirmed to the test item
that has been executed in "Log" column. Moreover, the
comment can be confirmed about the result.


===============
6. Special note
===============

When NUT supporting Binding Refresh Request executes tests
with non-BOOT setting as INITIALIZE parameter, The node may
have transmitted Binding Refresh Request without a direct
relation to current running test. The packets may causes
some WARNs as result of test.

	Example)
	INITIALIZE		NO-BOOT

Because Tester executes tests with different users test by test
and NUT may continue to maintain cache for those users during 
whole tests.

The Tester judges Binding Refresh Requests of this case to be WARN.
If test result shows WARN and it is clear that the packet causes
WARN is Binding Reresh Request by investigating logs, the test
could be judged as PASS.

Please set "BOOT" as INITIALIZE parameter or turn a Binding Refresh 
Request function of NUT into OFF to evade this judgement.
However please turn a Binding Refresh Request function of NUT into
ON for CN-3-2-3 and CN3-2-4, comforming Binding Refresh Request 
function. 

	-BOOT
		Any BRRs might NOT be sent without 
		CN-3-2-3, CN-3-2-4.
	-non-BOOT
		Some BRRs might be sent and judged as WARN.
		
	[Test]
	INITIALIZE	BOOT/NOBOOT

	[Test for IPv6 Ready Logo]
	INITIALIZE	BOOT(required)

# End of file
