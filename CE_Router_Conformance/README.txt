Latest Releases
	Test Specification: 1.0.1(2016/8/5)
	Self Test Tool: 1.0.5(2018/12/13)
	Interoperability Test Scenario: 1.0.2(2016/1/13)

	If you are going to run CE Router Self Test from now, please download and use the newest version. However, in case the test specification and self-test/interop scenario are updated during your testing with the previous version, IPv6 Ready Logo program will accept your application with the test results based on the previous version of the test within four weeks from the update.

Test Suite
	The Test Suite correspondent to above specification is available.
	If you want to try it, prepare a FreeBSD(8.X version is recommended) install PC and install platform and Test scripts listed below:

	Platform
		Please follow the installation steps:
	update v6eval
		download v6eval-3.3.4
		Extract v6eval-3.3.4.tar.gz
		% tar zxvf v6eval-3.3.4.tar.gz
		% cd v6eval-3.3.4
		% su
		#make
		#make test
		#make install
	Install Perl module HMAC
		$ cd /usr/ports/security/p5-Digest-HMAC
		$ make install
	For CE Router conformance test tool
		$download CE Router Conformance Test Tool
		Change Log
		$ tar zxvf CE-Router_Self_Test_1_X_X.tgz
	For more detailed installation steps, read CE Router Conformance Installation Guide