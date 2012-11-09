# scenario
scenario interop {
    setup_cleanup_REF2;
    setup_cleanup_TEST-TAR-EN;
    setup_DUMPER;

    test_TEST-TAR-EN;

    cleanup_DUMPER;
}

# syncevent
syncevent start_setup setup_cleanup_REF2, setup_cleanup_TEST-TAR-EN, setup_DUMPER;

syncevent finish_router_setup setup_cleanup_TEST-TAR-EN, setup_cleanup_REF2;

syncevent finish_setup setup_cleanup_REF2, setup_cleanup_TEST-TAR-EN, cleanup_DUMPER, test_TEST-TAR-EN;

syncevent finish_test setup_cleanup_REF2, setup_cleanup_TEST-TAR-EN, cleanup_DUMPER, test_TEST-TAR-EN;

# waitevent
waitevent wait_target_setup test_TEST-TAR-EN;
waitevent wait_test_start setup_cleanup_REF2;


# test command
command test_TEST-TAR-EN TEST-TAR-EN {

    sync finish_setup;

    print "";
    print "BASENAME> Bring up YOUR DEVICE";
    print "BASENAME> wait time for autoconfiguration and DAD";
    print "";
    print "BASENAME> Please add address LOGO_IF1_PREFIX1_GA_2 to your device.";
    print "";
    print "BASENAME> Please configure SAD and SPD in your device";
    print "BASENAME> as described in test scenario 5.4.5.";
    PRINT_FILE_5.4.5.TGT_HOST1.ipsec.conf
    print "BASENAME> Press Enter key for continue.";

    wait wait_target_setup;

    print "";
    print "BASENAME> TEST-TAR-EN transmits ICMPv6 Echo Request to your device.";

    delay 2;
    TEST-TAR-EN_CMD_CLEAR_NCE_IF1;
    TEST-TAR-EN_CMD_PRINT_NCE_IF1;
    execute "/bin/sh -c TEST-TAR-EN_CMD_PING6_FROM_SPEC_SRC_ADDR TEST-TAR-EN_IF1_PREFIX2_GA_2 -c 1 LOGO_IF1_PREFIX1_GA_2 | tee /tmp/5.4.5.TEST-TAR-EN_NAME.LOGO_NAME.result";
    delay 3;
    execute "/bin/sh -c TEST-TAR-EN_CMD_PING6_FROM_SPEC_SRC_ADDR TEST-TAR-EN_IF1_PREFIX2_GA_2 -c 4 LOGO_IF1_PREFIX1_GA_2 | tee -a /tmp/5.4.5.TEST-TAR-EN_NAME.LOGO_NAME.result";
    delay 1;
    execute "/bin/sh -c TEST-TAR-EN_CMD_UNAME_A | tee -a /tmp/5.4.5.TEST-TAR-EN_NAME.LOGO_NAME.result";
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
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_PREFIX2_GA_2_ADD";
    delay 2;

    COPY_FILE_5.4.5.TGT_HOST1.ipsec.conf
    execute "TEST-TAR-EN_CMD_SETKEY";

    sync finish_setup;

    sync finish_test;

    execute "TEST-TAR-EN_CMD_SYSCTL_NOT_ACCEPT_RA";
    execute "TEST-TAR-EN_CMD_SYSCTL_NOT_FORWARDING";
    TEST-TAR-EN_CMD_CLEAR_NCE_IF1;
    TEST-TAR-EN_CMD_PRINT_NCE_IF1;
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_DOWN";
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_LLA_DELETE";
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_PREFIX2_GA_DELETE";
    execute "TEST-TAR-EN_CMD_IFCONFIG_IF1_PREFIX2_GA_2_DELETE";
}

command setup_DUMPER DUMPER {
    delay 5;
    sync start_setup;
    execute "/bin/sh -c /usr/sbin/tcpdump -i DUMPER_IF1 -c 10000 -s 0 -w /tmp/5.4.5.TEST-TAR-EN_NAME.Link0.dump&";
    execute "/bin/sh -c /usr/sbin/tcpdump -i DUMPER_IF2 -c 10000 -s 0 -w /tmp/5.4.5.TEST-TAR-EN_NAME.Link1.dump&";
}

command cleanup_DUMPER DUMPER {
    delay 10;
    sync finish_setup;
    sync finish_test;
    delay 5;
    execute "killall tcpdump";
}

## REF2_TYPE(REF2_NAME)
command setup_cleanup_REF2 REF2 {
    print "This test uses active node as described below.";
    print "";
    print "5.4.5 (End-Node vs End-Node Tunnel Mode)";
    print "";
    PRINT_FILE_5.4.en.en.topology
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
    execute "REF2_CMD_RTADVD_CONF_5_1_9";
    execute "REF2_CMD_RTADVD_CONF_5_1_A";
    execute "REF2_CMD_RTADVD_CONF_5_1_B";
    execute "REF2_CMD_RTADVD_CONF_5_1_C";
    execute "REF2_CMD_RTADVD_CONF_5_1_D";
    execute "REF2_CMD_RTADVD_CONF_5_1_E";
    execute "REF2_CMD_RTADVD_CONF_5_1_F";
    execute "REF2_CMD_RTADVD_CONF_5_1_G";

    execute "REF2_CMD_RTADVD_IFS_1_2";

    sync finish_router_setup;

    sync finish_setup;

    sync finish_test;
    execute "REF2_CMD_STOP_RTADVD";
    execute "REF2_CMD_IFCONFIG_IF1_DOWN";
    execute "REF2_CMD_IFCONFIG_IF1_LLA_DELETE";
    execute "REF2_CMD_IFCONFIG_IF1_PREFIX1_GA_DELETE";
    execute "REF2_CMD_IFCONFIG_IF1_PREFIX1_GA_F_DELETE";
    execute "REF2_CMD_IFCONFIG_IF2_DOWN";
    execute "REF2_CMD_IFCONFIG_IF2_LLA_DELETE";
    execute "REF2_CMD_IFCONFIG_IF2_PREFIX2_GA_DELETE";
    execute "REF2_CMD_IFCONFIG_IF2_PREFIX2_GA_F_DELETE";

    execute "REF2_CMD_SYSCTL_NOT_ACCEPT_RA";
    execute "REF2_CMD_SYSCTL_NOT_FORWARDING";
    execute "REF2_CMD_FLUSH_ROUTE_PREFIX1_IF1";
    execute "REF2_CMD_FLUSH_ROUTE_PREFIX2_IF2";
    REF2_CMD_CLEAR_NCE_IF1;
    REF2_CMD_PRINT_NCE_IF1;
}
