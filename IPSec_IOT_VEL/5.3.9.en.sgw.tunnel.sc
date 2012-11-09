# scenario
scenario interop {
    setup_cleanup_REF2;
    setup_cleanup_REF3;
    setup_cleanup_TEST-TAR-SGW;
    setup_DUMPER;

    test_REF3;

    cleanup_DUMPER;
}

# syncevent
syncevent start_setup setup_cleanup_REF2, setup_cleanup_REF3, setup_cleanup_TEST-TAR-SGW, setup_DUMPER;

syncevent finish_router_setup setup_cleanup_REF2, setup_cleanup_REF3, setup_cleanup_TEST-TAR-SGW, test_REF3;

syncevent finish_setup setup_cleanup_REF2, setup_cleanup_REF3, setup_cleanup_TEST-TAR-SGW, cleanup_DUMPER, test_REF3;

syncevent finish_test setup_cleanup_REF2, setup_cleanup_REF3, setup_cleanup_TEST-TAR-SGW, cleanup_DUMPER, test_REF3;

# waitevent
waitevent wait_target_setup1 test_REF3;
waitevent wait_target_setup2 test_REF3;
waitevent wait_test_start setup_cleanup_REF2;


# test command
command test_REF3 REF3 {
    sync finish_router_setup;

    sync finish_setup;

    print "";
    print "BASENAME> Bring up YOUR DEVICE";
    print "BASENAME> wait time for autoconfiguration and DAD";
    print "";
    print "BASENAME> Please add address LOGO_IF1_PREFIX1_GA_2 to your device.";
    print "BASENAME> Press Enter key for continue.";

    wait wait_target_setup1;

    print "";
    print "BASENAME> Please configure SAD and SPD in your device";
    print "BASENAME> as described in test scenario 5.3.9.";
    PRINT_FILE_5.3.9.TGT_HOST1.ipsec.conf
    print "BASENAME> Press Enter key for continue.";

    wait wait_target_setup2;

    print "";
    print "BASENAME> REF-HOST transmits ICMPv6 Echo Request to your device.";

    delay 2;
    REF3_CMD_CLEAR_NCE_IF1;
    REF3_CMD_PRINT_NCE_IF1;
    execute "/bin/sh -c REF3_CMD_PING6_FROM_SPEC_SRC_ADDR REF3_IF1_PREFIX3_GA_2 -c 1 LOGO_IF1_PREFIX1_GA_2 | tee /tmp/5.3.9.REF.LOGO_NAME.result";
    delay 3;
    execute "/bin/sh -c REF3_CMD_PING6_FROM_SPEC_SRC_ADDR REF3_IF1_PREFIX3_GA_2 -c 1 LOGO_IF1_PREFIX1_GA_2 | tee -a /tmp/5.3.9.REF.LOGO_NAME.result";
    delay 2;
    execute "/bin/sh -c REF3_CMD_PING6_FROM_SPEC_SRC_ADDR REF3_IF1_PREFIX3_GA_2 -c 3 LOGO_IF1_PREFIX1_GA_2 | tee -a /tmp/5.3.9.REF.LOGO_NAME.result";
    delay 1;

    sync finish_test;
}

# setup command
## TEST-TAR-SGW_TYPE(TEST-TAR-SGW_NAME)
command setup_cleanup_TEST-TAR-SGW TEST-TAR-SGW {
    sync start_setup;

    execute "TEST-TAR-SGW_CMD_SYSCTL_NOT_ACCEPT_RA";
    execute "TEST-TAR-SGW_CMD_SYSCTL_FORWARDING";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF1_UP";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF2_UP";

    delay 3;
    
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF1_PREFIX2_GA_ADD";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF2_PREFIX3_GA_ADD";
    
    delay 2;
    
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF1_PREFIX2_GA_E_ADD";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF2_PREFIX3_GA_E_ADD";

    delay 2;
    
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_1";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_2";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_3";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_4";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_5";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_6";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_7";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_8";
    delay 2;
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_9";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_A";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_B";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_C";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_D";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_E";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_F";
    execute "TEST-TAR-SGW_CMD_RTADVD_CONF_5_3_TAR_G";
    delay 2;
    execute "TEST-TAR-SGW_CMD_RTADVD_IFS_1_2";

    sync finish_router_setup;

    delay 2;
    execute "TEST-TAR-SGW_CMD_ADD_ROUTE_5_3_TAR REF2_IF2_PREFIX2_GA";
    delay 2;

    COPY_FILE_5.3.9.TGT_HOST1.ipsec.conf
    delay 2;
    execute "TEST-TAR-SGW_CMD_SETKEY";
    delay 2;
    
    sync finish_setup;

    sync finish_test;
    execute "TEST-TAR-SGW_CMD_STOP_RTADVD";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF1_DOWN";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF1_LLA_DELETE";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF1_PREFIX2_GA_DELETE";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF1_PREFIX2_GA_E_DELETE";
    delay 2;
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF2_DOWN";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF2_LLA_DELETE";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF2_PREFIX3_GA_DELETE";
    execute "TEST-TAR-SGW_CMD_IFCONFIG_IF2_PREFIX3_GA_E_DELETE";
    delay 2;
    execute "TEST-TAR-SGW_CMD_SYSCTL_NOT_ACCEPT_RA";
    execute "TEST-TAR-SGW_CMD_SYSCTL_NOT_FORWARDING";
    execute "TEST-TAR-SGW_CMD_FLUSH_ROUTE_PREFIX1_IF1";
    execute "TEST-TAR-SGW_CMD_FLUSH_ROUTE_PREFIX2_IF1";
    execute "TEST-TAR-SGW_CMD_FLUSH_ROUTE_PREFIX3_IF2";
}

command setup_DUMPER DUMPER {
    delay 5;
    sync start_setup;
    execute "/bin/sh -c /usr/sbin/tcpdump -i DUMPER_IF1 -c 10000 -s 0 -w /tmp/5.3.9.TEST-TAR-SGW_NAME.Link0.dump&";
    execute "/bin/sh -c /usr/sbin/tcpdump -i DUMPER_IF2 -c 10000 -s 0 -w /tmp/5.3.9.TEST-TAR-SGW_NAME.Link1.dump&";
    execute "/bin/sh -c /usr/sbin/tcpdump -i DUMPER_IF3 -c 10000 -s 0 -w /tmp/5.3.9.TEST-TAR-SGW_NAME.Link2.dump&";
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
    print "5.3.9 (End-Node vs SGW Tunnel Mode)";
    print "";
    PRINT_FILE_5.3.en.sgw.topology
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
    execute "REF2_CMD_ADD_ROUTE_5_3_REF_EN_SGW TEST-TAR-SGW_IF1_PREFIX2_GA";
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
    
    delay 16;
    
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
