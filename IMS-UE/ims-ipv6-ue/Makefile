#!/usr/bin/gmake

#CopyrightIMS

TITLE	= "Conformance Test for IMS IPv6 User Equipment Node"


# scenario type
ifeq ($(patsubst %a,sim,$(MAKECMDGOALS)),sim)
	MAKECMDGOALS := $(patsubst %a,%,$(MAKECMDGOALS))
	TYPE = AKA
endif
ifeq ($(patsubst %d,sim,$(MAKECMDGOALS)),sim)
	MAKECMDGOALS := $(patsubst %d,%,$(MAKECMDGOALS))
	TYPE = DIP
endif

init6:
	-perl ctsetup.pl ct=local cfg=config.txt
	rm -f ctsetup_pl_log_Link0.pcap ctsetup.pl.log

.PHONY: clean

clean:
	rm -f *.dump *.pcap *.log *.html  log/*.*


ini inia inid: SCENARIO = UE-INI-B-1
ini inia inid: run

rg1 rg1a rg1d: SCENARIO = UE-RG-B-1
rg1 rg1a rg1d: run

rg2 rg2a rg2d: SCENARIO = UE-RG-B-2
rg2 rg2a rg2d: run

rg3 rg3a rg3d: SCENARIO = UE-RG-B-3
rg3 rg3a rg3d: run

rg4 rg4a rg4d: SCENARIO = UE-RG-B-4
rg4 rg4a rg4d: run

rg5 rg5a rg5d: SCENARIO = UE-RG-B-5
rg5 rg5a rg5d: run

rg6 rg6a rg6d: SCENARIO = UE-RG-B-6
rg6 rg6a rg6d: run

rg7 rg7a rg7d: SCENARIO = UE-RG-B-7
rg7 rg7a rg7d: run

rg8 rg8a rg8d: SCENARIO = UE-RG-B-8
rg8 rg8a rg8d: run

rg9 rg9a rg9d: SCENARIO = UE-RG-B-9
rg9 rg9a rg9d: run

rg10 rg10a rg10d: SCENARIO = UE-RG-B-10
rg10 rg10a rg10d: run

rg11 rg11a rg11d: SCENARIO = UE-RG-B-11
rg11 rg11a rg11d: run

rg12 rg12a rg12d: SCENARIO = UE-RG-B-12
rg12 rg12a rg12d: run

rg13 rg13a rg13d: SCENARIO = UE-RG-B-13
rg13 rg13a rg13d: run

rg14 rg14a rg14d: SCENARIO = UE-RG-B-14
rg14 rg14a rg14d: run

rg15 rg15a rg15d: SCENARIO = UE-RG-B-15
rg15 rg15a rg15d: run

rg16 rg16a: SCENARIO = UE-RG-B-16
rg16 rg16a: run

rg17 rg17a: SCENARIO = UE-RG-B-17
rg17 rg17a: run

rg18 rg18a rg18d: SCENARIO = UE-RG-B-18
rg18 rg18a rg18d: run

rg19 rg19a rg19d: SCENARIO = UE-RG-B-19
rg19 rg19a rg19d: run

rg20 rg20a rg20d: SCENARIO = UE-RG-B-20
rg20 rg20a rg20d: run

rg21 rg21a: SCENARIO = UE-RG-B-21
rg21 rg21a: run

rg22 rg22a rg22d: SCENARIO = UE-RG-B-22
rg22 rg22a rg22d: run

rg23 rg23a: SCENARIO = UE-RG-B-23
rg23 rg23a: run

rg24 rg24a: SCENARIO = UE-RG-B-24
rg24 rg24a: run

rr1 rr1a rr1d: SCENARIO = UE-RR-B-1
rr1 rr1a rr1d: run

rr2 rr2a rr2d: SCENARIO = UE-RR-B-2
rr2 rr2a rr2d: run

rr3 rr3a rr3d: SCENARIO = UE-RR-B-3
rr3 rr3a rr3d: run

rr4 rr4a rr4d: SCENARIO = UE-RR-B-4
rr4 rr4a rr4d: run

rr5 rr5a rr5d: SCENARIO = UE-RR-B-5
rr5 rr5a rr5d: run

rr6 rr6a rr6d: SCENARIO = UE-RR-B-6
rr6 rr6a rr6d: run

rr7 rr7a rr7d: SCENARIO = UE-RR-B-7
rr7 rr7a rr7d: run

rr8 rr8a rr8d: SCENARIO = UE-RR-B-8
rr8 rr8a rr8d: run

rr9 rr9a rr9d: SCENARIO = UE-RR-B-9
rr9 rr9a rr9d: run

rr10 rr10a rr10d: SCENARIO = UE-RR-B-10
rr10 rr10a rr10d: run

rr11 rr11a rr11d: SCENARIO = UE-RR-B-11
rr11 rr11a rr11d: run

rr12 rr12a rr12d: SCENARIO = UE-RR-B-12
rr12 rr12a rr12d: run

rr13 rr13a rr13d: SCENARIO = UE-RR-B-13
rr13 rr13a rr13d: run

rr14 rr14a rr14d: SCENARIO = UE-RR-B-14
rr14 rr14a rr14d: run

rr15 rr15a rr15d: SCENARIO = UE-RR-B-15
rr15 rr15a rr15d: run

rr16 rr16a rr16d: SCENARIO = UE-RR-B-16
rr16 rr16a rr16d: run

rr17 rr17a rr17d: SCENARIO = UE-RR-B-17
rr17 rr17a rr17d: run

rr18 rr18a rr18d: SCENARIO = UE-RR-B-18
rr18 rr18a rr18d: run

rr19 rr19a rr19d: SCENARIO = UE-RR-B-19
rr19 rr19a rr19d: run

rr20 rr20a rr20d: SCENARIO = UE-RR-B-20
rr20 rr20a rr20d: run

rr21 rr21a rr21d: SCENARIO = UE-RR-B-21
rr21 rr21a rr21d: run

rr22 rr22a rr22d: SCENARIO = UE-RR-B-22
rr22 rr22a rr22d: run

rr23 rr23a rr23d: SCENARIO = UE-RR-B-23
rr23 rr23a rr23d: run

rr24 rr24a rr24d: SCENARIO = UE-RR-B-24
rr24 rr24a rr24d: run

rr25 rr25a rr25d: SCENARIO = UE-RR-B-25
rr25 rr25a rr25d: run

rr26 rr26a rr26d: SCENARIO = UE-RR-B-26
rr26 rr26a rr26d: run

rr27 rr27a rr27d: SCENARIO = UE-RR-B-27
rr27 rr27a rr27d: run

rr28 rr28a rr28d: SCENARIO = UE-RR-B-27
rr28 rr28a rr28d: run

sc1 sc1a: SCENARIO = UE-SC-B-1
sc1 sc1a: run

sc2 sc2a: SCENARIO = UE-SC-B-2
sc2 sc2a: run

sd1 sd1a sd1d: SCENARIO = UE-SD-B-1
sd1 sd1a sd1d: run

sd2 sd2a sd2d: SCENARIO = UE-SD-B-2
sd2 sd2a sd2d: run

se1 se1a se1d: SCENARIO = UE-SE-B-1
se1 se1a se1d: run

se2 se2a se2d: SCENARIO = UE-SE-B-2
se2 se2a se2d: run

se3 se3a se3d: SCENARIO = UE-SE-B-3
se3 se3a se3d: run

se4 se4a se4d: SCENARIO = UE-SE-B-4
se4 se4a se4d: run

se5 se5a se5d: SCENARIO = UE-SE-B-5
se5 se5a se5d: run

se6 se6a se6d: SCENARIO = UE-SE-B-6
se6 se6a se6d: run

se7 se7a: SCENARIO = UE-SE-B-7
se7 se7a: run

se8 se8a: SCENARIO = UE-SE-B-8
se8 se8a: run

se9 se9a se9d: SCENARIO = UE-SE-B-9
se9 se9a se9d: run

se10 se10a se10d: SCENARIO = UE-SE-B-10
se10 se10a se10d: run

sr1 sr1a sr1d: SCENARIO = UE-SR-B-1
sr1 sr1a sr1d: run

sr2 sr2a sr2d: SCENARIO = UE-SR-B-2
sr2 sr2a sr2d: run

sr3 sr3a sr3d: SCENARIO = UE-SR-B-3
sr3 sr3a sr3d: run

sr4 sr4a sr4d: SCENARIO = UE-SR-B-4
sr4 sr4a sr4d: run

sr5 sr5a sr5d: SCENARIO = UE-SR-B-5
sr5 sr5a sr5d: run

sr6 sr6a sr6d: SCENARIO = UE-SR-B-6
sr6 sr6a sr6d: run

sr7 sr7a sr7d: SCENARIO = UE-SR-B-7
sr7 sr7a sr7d: run

sr8 sr8a sr8d: SCENARIO = UE-SR-B-8
sr8 sr8a sr8d: run

sr9 sr9a sr9d: SCENARIO = UE-SR-B-9
sr9 sr9a sr9d: run

sr10 sr10a sr10d: SCENARIO = UE-SR-B-10
sr10 sr10a sr10d: run

sr11 sr11a sr11d: SCENARIO = UE-SR-B-11
sr11 sr11a sr11d: run

sr12 sr12a sr12d: SCENARIO = UE-SR-B-12
sr12 sr12a sr12d: run

sr13 sr13a sr13d: SCENARIO = UE-SR-B-13
sr13 sr13a sr13d: run

op1 op1a op1d: SCENARIO = UE-OP-B-1
op1 op1a op1d: run

op2 op2a op2d: SCENARIO = UE-OP-B-2
op2 op2a op2d: run

tm1 tm1a tm1d: SCENARIO = UE-TM-B-1
tm1 tm1a tm1d: run

tm2 tm2a tm2d: SCENARIO = UE-TM-B-2
tm2 tm2a tm2d: run

tm3 tm3a tm3d: SCENARIO = UE-TM-B-3
tm3 tm3a tm3d: run

tm4 tm4a tm4d: SCENARIO = UE-TM-B-4
tm4 tm4a tm4d: run

tm5 tm5a tm5d: SCENARIO = UE-TM-B-5
tm5 tm5a tm5d: run

run:
ifeq "$(TYPE)" "AKA"
	-perl $(SCENARIO).seq -log=log/$(SCENARIO)-AKA.html cfg=config.txt auth=aka
	rm -f $(SCENARIO).log $(SCENARIO)_log_Link0.pcap
endif
ifeq "$(TYPE)" "DIP"
	-perl $(SCENARIO).seq -log=log/$(SCENARIO)-DIP.html cfg=config.txt auth=sipdigest
	rm -f $(SCENARIO).log $(SCENARIO)_log_Link0.pcap
endif

result:
	-perl result.pl


