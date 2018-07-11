#!../../bin/linux-x86_64/mrf

epicsEnvSet("SYS" "LabS-Utgard-VIP")
epicsEnvSet("CHICID" "Chop-CHIC-01")

dbLoadDatabase("../../dbd/mrf.dbd")
mrf_registerRecordDeviceDriver(pdbbase)

mrmEvrSetupPCI("EVR1", "5:0.0")

dbLoadRecords("../../db/evr-pcie-300dc.db","EVR=EVR1,SYS=LabS-Utgard-VIP,D=evr:1,FEVT=124.916")
#dbLoadRecords("../../db/evr-pcie-300dc.db","EVR=EVR1,SYS=LabS-Utgard-VIP,D=evr:1,FEVT=88.0525")
#dbLoadRecords("../../db/evr-pcie-300dc.db","EVR=EVR1,SYS=LabS-Utgard-VIP,D=evr:1,FEVT=88.0519")


# Load chopper timestamping database
epicsEnvSet("DEVICE"          "evr:1")
#dbLoadRecords("/opt/epics/modules/esschic/2.0.0/db/esschicTimestampBuffer.template", "PREFIX=$(SYS), CHICID=$(CHICID), REV_TIME_LINK=$(SYS){$(DEVICE)}EvtACnt-I.TIME, BEAMPULSE_TIME_LINK=$(SYS){$(DEVICE)}EvtECnt-I.TIME, TSARR_N=50")
dbLoadRecords("/opt/epics/modules/esschic/2.1.0/db/esschicTimestampBuffer.template", "PREFIX=$(SYS), CHICID=$(CHICID), TDC_TIME_LINK=$(SYS){$(DEVICE)}EvtACnt-I.TIME, BEAMPULSE_TIME_LINK=$(SYS){$(DEVICE)}EvtECnt-I.TIME, TSARR_N=50")

var(evrMrmTimeNSOverflowThreshold, 100000)

iocInit()

#Fix the delay compensation bug
#dbpf $(SYS){$(DEVICE)-DC}Tgt-SP 70
dbpf LabS-Utgard-VIP{evr:1-DC}Tgt-SP 70


# Get timestamp from system clock
#dbpf LabS-Utgard-VIP{evr:1}TimeSrc-Sel 2
dbpf LabS-Utgard-VIP{evr:1}TimeSrc-Sel 1
dbpf LabS-Utgard-VIP{evr:1}Link:Clk-SP 124.916
#dbpf LabS-Utgard-VIP{evr:1}Link:Clk-SP 88.0525
#dbpf LabS-Utgard-VIP{evr:1}Link:Clk-SP 88.0519

#Setup of sequence for event code 14 generation
dbpf LabS-Utgard-VIP{evr:1-SoftSeq:0}RunMode-Sel 0
dbpf LabS-Utgard-VIP{evr:1-SoftSeq:0}TrigSrc:2-Sel 2
dbpf LabS-Utgard-VIP{evr:1-SoftSeq:0}TsResolution-Sel 2
dbpf LabS-Utgard-VIP{evr:1-SoftSeq:0}Load-Cmd 1
dbpf LabS-Utgard-VIP{evr:1-SoftSeq:0}Enable-Cmd 1

#Define 14Hz event by dividing event clock and triggering the sequencer (WORKING)
dbpf LabS-Utgard-VIP{evr:1-PS:0}Div-SP 6289424 #Changed from  6289464 by NH  # 12578856 # 6289464
dbpf LabS-Utgard-VIP{evr:1-DlyGen:0}Width-SP 2860 #2.86ms
dbpf LabS-Utgard-VIP{evr:1-DlyGen:0}Delay-SP 0 #0ms
dbpf LabS-Utgard-VIP{evr:1-DlyGen:0}Evt:Trig0-SP 14
dbpf LabS-Utgard-VIP{evr:1-Out:RB02}Src-SP 0 #Connect to DlyGen-0
dbpf LabS-Utgard-VIP{evr:1-Out:RB03}Src-SP 0 #Connect to DlyGen-0

#Define 14Hz event with a delay of 10ms (WORKING)
dbpf LabS-Utgard-VIP{evr:1-DlyGen:1}Evt:Trig0-SP 14
dbpf LabS-Utgard-VIP{evr:1-DlyGen:1}Width-SP 2860 #1ms
dbpf LabS-Utgard-VIP{evr:1-DlyGen:1}Delay-SP 0 #0ms
dbpf LabS-Utgard-VIP{evr:1-Out:RB04}Src-SP 1 #Connect to DlyGen-1

# Set up of UnivIO 0 as Input. Generate Code 10 locally on rising edge.
dbpf LabS-Utgard-VIP{evr:1-Out:RB00}Src-SP 61
dbpf LabS-Utgard-VIP{evr:1-In:0}Trig:Ext-Sel "Edge"
dbpf LabS-Utgard-VIP{evr:1-In:0}Code:Ext-SP 10

# Set up of UnivIO 1 as Input. Generate Code 11 locally on rising edge.
dbpf LabS-Utgard-VIP{evr:1-Out:RB01}Src-SP 61
dbpf LabS-Utgard-VIP{evr:1-In:1}Trig:Ext-Sel "Edge"
dbpf LabS-Utgard-VIP{evr:1-In:1}Code:Ext-SP 11

# Flanks to esschicTimestampBuffer.template
dbpf LabS-Utgard-VIP{evr:1}EvtACnt-I.FLNK $(SYS):$(CHICID):TDC
dbpf LabS-Utgard-VIP{evr:1}EvtECnt-I.FLNK $(SYS):$(CHICID):Ref

