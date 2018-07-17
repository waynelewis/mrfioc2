#-*- mode: epics -*-
# This file should be used with EPICS base 3.15.4 and mrfioc2 (han branch)
# With current EEE 1.8.2, the proper command is 
#
# iocsh -3.14.12.5 dgri_intr_demo.cmd
#
#
require mrfioc2,2.7.13
require pev,0.1.2

epicsEnvSet(        "IOC", "LabS-Utgard-VIP")
epicsEnvSet(        "SYS", "LabS-Utgard-VIP:TS")
epicsEnvSet(      "PREVT",            "1") #Reset Prescalers 
epicsEnvSet(      "TSEVT",            "2") #Start timestamp sequence (reset-enable-determineTS-sendTS)
epicsEnvSet(        "TSE",            "3") #EVG sends TS Enable pulse
epicsEnvSet(        "TST",            "4") #EVG sends TS Test pulse to ADC
epicsEnvSet(        "EVG",        "EVG-1")
epicsEnvSet(    "EVG_BUS",         "0x10")
epicsEnvSet(    "EVG_DEV",         "0x0d")
epicsEnvSet(   "EVG_FUNC",          "0x0")
#epicsEnvSet("EVG_VMESLOT",            "4")
epicsEnvSet("EVG_VMESLOT",            "3")

#mrmEvgSetupPCI($(EVG), $(EVG_BUS), $(EVG_DEV), $(EVG_FUNC))
mrmEvgSetupVME($(EVG), $(EVG_VMESLOT), 0x100000, 1, 0x01)


# ESS ICS Definition
epicsEnvSet("HWEVT"    "14")
epicsEnvSet("EVTFREQ"  "14")

# Julich choppers
epicsEnvSet("JCEVT",   "42")
epicsEnvSet("JCFREQ",  "42")

# Fake Timestamp
epicsEnvSet("EVRTSE"   "-2")

# Don't change HBEVT 
epicsEnvSet("HBEVT"   "122")
# One can change, but don't change it.
epicsEnvSet("HBFREQ"    "1")
epicsEnvSet("FUNC" "Reset PS")

# --------------------------------------------------------
# Set Heart Beat Event (Evtcode, Fre, TrigSrc7) (122, 1, 1)
# Set 14 Hz      Event (Evtcode, Fre, TrigSrc0) (14, 14, 1)
# Set 42 Hz      Event (Evtcode, Fre, TrigSrc1) (42, 42, 1)
# 
#dbLoadRecords("evg-cpci.db",    "DEVICE=$(EVG), SYS=$(SYS),                                 TrigEvt7-EvtCode-SP=$(HBEVT), Mxc2-Frequency-SP=$(HBFREQ), Mxc2-TrigSrc7-SP=1, TrigEvt0-EvtCode-SP=$(HWEVT), Mxc0-Frequency-SP=$(EVTFREQ), Mxc0-TrigSrc0-SP=1, SoftEvt-Enable-Sel=1")
#dbLoadRecords("evg-vme-230.db", "DEVICE=$(EVG), SYS=$(SYS), EvtClk-FracSyncFreq-SP=88.0525, TrigEvt7-EvtCode-SP=$(HBEVT), Mxc2-Frequency-SP=$(HBFREQ), Mxc2-TrigSrc7-SP=1, TrigEvt0-EvtCode-SP=$(HWEVT), Mxc0-Frequency-SP=$(EVTFREQ), Mxc0-TrigSrc0-SP=1, SoftEvt-Enable-Sel=1")
# dbLoadRecords("evg-vme-230.db", "DEVICE=$(EVG), SYS=$(SYS), EvtClk-FracSyncFreq-SP=88.0525, TrigEvt7-EvtCode-SP=$(HBEVT), Mxc2-Frequency-SP=$(HBFREQ), Mxc2-TrigSrc7-SP=1, TrigEvt0-EvtCode-SP=$(HWEVT), Mxc0-Frequency-SP=$(EVTFREQ), Mxc0-TrigSrc0-SP=1, TrigEvt1-EvtCode-SP=$(JCEVT), Mxc1-Frequency-SP=$(JCFREQ), Mxc1-TrigSrc1-SP=1, SoftEvt-Enable-Sel=1")
#dbLoadRecords("evg-vme-230.db", "DEVICE=$(EVG), SYS=$(SYS), EvtClk-FracSyncFreq-SP=124.916, TrigEvt7-EvtCode-SP=$(HBEVT), Mxc2-Frequency-SP=$(HBFREQ), Mxc2-TrigSrc7-SP=1, TrigEvt0-EvtCode-SP=$(HWEVT), Mxc0-Frequency-SP=$(EVTFREQ), Mxc0-TrigSrc0-SP=1, TrigEvt1-EvtCode-SP=$(JCEVT), Mxc1-Frequency-SP=$(JCFREQ), Mxc1-TrigSrc1-SP=1, SoftEvt-Enable-Sel=1")
 dbLoadRecords("evg-vme-230.db", "DEVICE=$(EVG), SYS=$(SYS), EvtClk-FracSynFreq-SP=88.0519, TrigEvt7-EvtCode-SP=$(HBEVT), Mxc2-Frequency-SP=$(HBFREQ), Mxc2-TrigSrc7-SP=1, TrigEvt0-EvtCode-SP=$(HWEVT), Mxc0-Frequency-SP=$(EVTFREQ), Mxc0-TrigSrc0-SP=1, TrigEvt1-EvtCode-SP=$(JCEVT), Mxc1-Frequency-SP=$(JCFREQ), Mxc1-TrigSrc1-SP=1, SoftEvt-Enable-Sel=1")


### Timestamp Test Sequence #####

# Define the EVG sequence
dbLoadRecords("evgSoftSeq.template", "DEVICE=$(EVG), SYS=$(SYS), SEQNUM=1, NELM=4")

iocInit

# Fake timestamp source for testing without real hardware timestamp source (e.g., GPS recevier)
mrmEvgSoftTime($(EVG))

sleep(10)

# Mandatory if Fake timestamp source for testing without real hardware timestamp source (e.g., GPS recevier)
#
dbpf $(SYS)-$(EVG):SyncTimestamp-Cmd 1

system("/bin/sh ./evg_seq.sh $(SYS)-$(EVG)")
