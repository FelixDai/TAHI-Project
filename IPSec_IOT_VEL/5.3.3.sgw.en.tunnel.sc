# scenario
scenario interop {
    setup_cleanup_REF2;
    setup_cleanup_REF3;
    setup_cleanup_TEST-TAR-EN;
    setup_DUMPER;

    test_REF3;

    cleanup_DUMPER;
}

# syncevent
syncevent start_setup test_REF3, setup_cleanup_REF2, setup_cleanup_REF3, setup_cleanup_TEST-TAR-EN, setup_DUMPER;

syncevent finish_start_tcpdump test_REF3, setup_DUMPER;

syncevent finish_router_setup setup_cleanup_REF2, setup_cleanup_REF3, setup_cleanup_TEST-TAR-EN, test_REF3;

syncevent finish_setup setup_cleanup_REF2, setup_cleanup_REF3, setup_cleanup_TEST-TAR-EN, cleanup_DUMPER, test_REF3;

syncevent finish_test setup_cleanup_REF2, setup_cleanup_REF3, setup_cleanup_TEST-TAR-EN, cleanup_DUMPER, test_REF3;

# waitevent
waitevent wait_target_network_setup test_REF3;
waitevent wait_target_ipsec_setup test_REF3;
waitevent wait_test_start setup_cleanup_REF2;


# test command
command test_REF3 REF3 {
    sync start_setup;
    
    sync finish_start_tcpdump;
    
    print "";
    print "BASENAME> Configure YOUR DEVICE's IPv6 address as follows:";
    print "BASENAME> Link1: LOGO_IF1_PREFIX2_GA and LOGO_IF1_PREFIX2_GA_E";
    print "BASENAME> Link2: LOGO_IF2_PREFIX3_GA and LOGO_IF2_PREFIX3_GA_E";
    
    print "";
    print "BASENAME> Configure YOUR DEVICE's RA as follows:";
    print "BASENAME> Link1: PREFIX2::/64";
    print "BASENAME> Link2: PREFIX3::/64";
    
    print "";
    print "BASENAME> Add route into YOUR DEVICE as follows:";
    print "BASENAME> route add -inet6 PREFIX1:: -prefixlen 64 REF2_IF2_PREFIX2_GA";
    print "BASENAME> Press Enter key for continue.";
    
    wait wait_target_network_setup;
    
    print "";
    print "BASENAME> Configure YOUR DEVICE as follows:";
    print "BASENAME> Please configure SAD and SPD in your device";
    print "BASENAME> as described in test scenario 5.3.3.";
    PRINT_FILE_5.3.3.TGT_SGW1.ipsec.conf
    print "BASENAME> Press Enter key for continue.";

    wait wait_target_ipsec_setup;
    
    sync finish_router_setup;

    sync finish_setup;

    print "";
    print "BASENAME> REF-HOST transmits ICMPv6 Echo Request to TGT-HOST1.";

    delay 2;
    REF3_CMD_CLEAR_NCE_IF1;
    REF3_CMD_PRINT_NCE_IF1;
    execute "/bin/sh -c REF3_CMD_PING6_FROM_SPEC_SRC_ADDR REF3_IF1_PREFIX3_GA_2 -c 1 TEST-TAR-EN_IF1_PREFIX1_GA_2 | tee /tmp/5.3.3.REF.TEST-TAR-EN_NAME.result";
    delay 3;
    execute "/bin/sh -c REF3_CMD_PING6_FROM_SPEC_SRC_ADDR REF3_IF1_PREFIX3_GA_2 -c 1 TEST-TAR-EN_IF1_PREFIX1_GA_2 | tee -a /tmp/5.3.3.REF.TEST-TAR-EN_NAME.result";
    delay 2;
    execute "/bin/sh -c REF3_CMD_PING6_FROM_SPEC_SRC_ADDR REF3_IF1_PREFIX3_GA_2 -c 3 TEST-TAR-EN_IF1_PREFIX1_GA_2 | tee -a /tmp/5.3.3.REF.TEST-TAR-EN_NAME.result";
    delay 1;

    sync finish_test;
}

# setup command
## TEST-TAR-EN(TEST-TAR-EN_NAME) runs as host
command setup_cleanup_TEST-TAR-EN TEST-TAR-EN {
    sync start_setup;

    sync finish_router_setup;

    execute "TEST-TAR-EN_CMD_SYSCTL_ACCEPT_RA";
    execute "TEST-TAR-EN_CMD_SYSCTL_NOT_FORWARDING";
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_UP";
    execute "TEST-TAR-EN_CMD_RTSOL_IF1";

    delay 2;
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_PREFIX1_GA_2_ADD";
    delay 2;

    COPY_FILE_5.3.3.TGT_SGW1.ipsec.conf
    delay 2;
    execute "TEST-TAR-EN_CMD_SETKEY";
    delay 2;
    
    sync finish_setup;

    sync finish_test;

    execute "TEST-TAR-EN_CMD_SYSCTL_NOT_ACCEPT_RA";
    execute "TEST-TAR-EN_CMD_SYSCTL_NOT_FORWARDING";
    delay 2;
    TEST-TAR-EN_CMD_CLEAR_NCE_IF1;
    TEST-TAR-EN_CMD_PRINT_NCE_IF1;
    delay 2;
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_DOWN";
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_LLA_DELETE";
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_PREFIX1_GA_DELETE";
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_PREFIX1_GA_2_DELETE";
}

command setup_DUMPER DUMPER {
    delay 5;
    sync start_setup;
    execute "/bin/sh -c /usr/sbin/tcpdump -i DUMPER_IF1 -c 10000 -s 0 -w /tmp/5.3.3.TEST-TAR-EN_NAME.Link0.dump&";
    execute "/bin/sh -c /usr/sbin/tcpdump -i DUMPER_IF2 -c 10000 -s 0 -w /tmp/5.3.3.TEST-TAR-EN_NAME.Link1.dump&";
    execute "/bin/sh -c /usr/sbin/tcpdump -i DUMPER_IF3 -c 10000 -s 0 -w /tmp/5.3.3.TEST-TAR-EN_NAME.Link2.dump&";
    sync finish_start_tcpdump;
}

command cleanup_DUMPER DUMPER {
    delay 10;
    sync finish_setup;
    sync finish_test;
    delay 8;
    execute "killall tcpdump";
}

## REF2_TYPE(REF2_NAME) as router
command setup_cleanup_REF2 REF2 {
    print "This test uses active node as described below.";
    print "";
    print "5.3.3 (End-Node vs SGW Tunnel Mode)";
    print "";
    PRINT_FILE_5.3.sgw.en.topology
    print "Press Enter key to start test.";
    wait wait_test_start;
    #

    sync start_setup;

    execute "REF2_CMD_SYSCTL_NOT_ACCEPT_RA";
    execute "REF2_CMD_SYSCTL_FORWARDING";
    execute "REF2_CMD_IFCONFIG_IF1_UP";
    execute "REF2_CMD_IFCONFIG_IF2_UP";

    delay 2;
    execute "REF2_CMD_IFCONFIG_IF1_PREFIX1_GA_ADD";
    execute "REF2_CMD_IFCONFIG_IF2_PREFIX2_GA_ADD";
    delay 2;
    execute "REF2_CMD_IFCONFIG_IF1_PREFIX1_GA_F_ADD";
    execute "REF2_CMD_IFCONFIG_IF2_PREFIX2_GA_F_ADD";

    delay 2;
    execute "REF2_CMD_RTADVD_CONF_5_1_1";
    execute "REF2_CMD_RTADVD_CONF_5_1_2";
    execute "REF2_CMD_RTADVD_CONF_5_1_3";
    execute "REF2_CMD_RTADVD_CONF_5_1_4";
    execute "REF2_CMD_RTADVD_CONF_5_1_5";
    execute "REF2_CMD_RTADVD_CONF_5_1_6";
    execute "REF2_CMD_RTADVD_CONF_5_1_7";
    execute "REF2_CMD_RTADVD_CONF_5_1_8";
    delay 2;
    execute "REF2_CMD_RTADVD_CONF_5_1_9";
    execute "REF2_CMD_RTADVD_CONF_5_1_A";
    execute "REF2_CMD_RTADVD_CONF_5_1_B";
    execute "REF2_CMD_RTADVD_CONF_5_1_C";
    execute "REF2_CMD_RTADVD_CONF_5_1_D";
    execute "REF2_CMD_RTADVD_CONF_5_1_E";
    execute "REF2_CMD_RTADVD_CONF_5_1_F";
    execute "REF2_CMD_RTADVD_CONF_5_1_G";
    delay 2;
    execute "REF2_CMD_RTADVD_IFS_1_2";

    sync finish_router_setup;

    delay 2;
    execute "REF2_CMD_ADD_ROUTE_5_3_REF_SGW_EN LOGO_IF1_PREFIX2_GA";
    delay 8;

    sync finish_setup;

    sync finish_test;
    execute "REF2_CMD_STOP_RTADVD";
    execute "REF2_CMD_IFCONFIG_IF1_DOWN";
    execute "REF2_CMD_IFCONFIG_IF1_LLA_DELETE";
    execute "REF2_CMD_IFCONFIG_IF1_PREFIX1_GA_DELETE";
    execute "REF2_CMD_IFCONFIG_IF1_PREFIX1_GA_F_DELETE";
    delay 2;
    execute "REF2_CMD_IFCONFIG_IF2_DOWN";
    execute "REF2_CMD_IFCONFIG_IF2_LLA_DELETE";
    execute "REF2_CMD_IFCONFIG_IF2_PREFIX2_GA_DELETE";
    execute "REF2_CMD_IFCONFIG_IF2_PREFIX2_GA_F_DELETE";
    delay 2;
    execute "REF2_CMD_SYSCTL_NOT_ACCEPT_RA";
    execute "REF2_CMD_SYSCTL_NOT_FORWARDING";
    execute "REF2_CMD_FLUSH_ROUTE_PREFIX1_IF1";
    execute "REF2_CMD_FLUSH_ROUTE_PREFIX2_IF2";
    execute "REF2_CMD_FLUSH_ROUTE_PREFIX3_IF2";
    REF2_CMD_CLEAR_NCE_IF1;
    REF2_CMD_PRINT_NCE_IF1;
}

## REF3(REF3_NAME) runs as host
command setup_cleanup_REF3 REF3 {
    sync start_setup;

    sync finish_router_setup;

    execute "REF3_CMD_SYSCTL_ACCEPT_RA";
    execute "REF3_CMD_SYSCTL_NOT_FORWARDING";
    execute "REF3_CMD_IFCONFIG_IF1_UP";
    execute "REF3_CMD_RTSOL_IF1";

    delay 2;
    execute "REF3_CMD_IFCONFIG_IF1_PREFIX3_GA_2_ADD";
    delay 8;

    sync finish_setup;

    sync finish_test;

    execute "REF3_CMD_SYSCTL_NOT_ACCEPT_RA";
    execute "REF3_CMD_SYSCTL_NOT_FORWARDING";
    delay 2;
    REF3_CMD_CLEAR_NCE_IF1;
    REF3_CMD_PRINT_NCE_IF1;
    delay 2;
    execute "REF3_CMD_IFCONFIG_IF1_DOWN";
    execute "REF3_CMD_IFCONFIG_IF1_LLA_DELETE";
    execute "REF3_CMD_IFCONFIG_IF1_PREFIX3_GA_DELETE";
    execute "REF3_CMD_IFCONFIG_IF1_PREFIX3_GA_2_DELETE";
}
