#!/bin/bash
# Bash script to configure the EVR sequencer

# All values in uSec

# event code 14 (14 Hz), 123 is the prescaler sync reset, 127 is the end of sequence
#caput -a LabS-Embla{evr:1-SoftSeq:0}EvtCode-SP 27 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 127
#caput -a LabS-Embla{evr:1-SoftSeq:0}EvtCode-SP 27 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 127


caput -a LabS-Embla{evr:1-SoftSeq:0}EvtCode-SP 10 14 16 15 14 15 15 15 15 127

##############
#caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP 7 0 1 1257886 2515770 3773655 5031539 5031540

#caput -a LabS-Embla{evr:1-SoftSeq:0}EvtCode-SP 10 14 15 15 15 14 15 15 16 17 127
#caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP 10 1 2 1257887 2515772 3144713 3773656 5031541
#caput LabS-Embla{evr:1-SoftSeq:0}Commit-Cmd 1
##############


# Defining time at which the event codes are sent, units are ticks of the event clock (~11.37 ns)
caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP 10 0 1 2 1257885 1257886 2515770 3773655 5031539 5031540

#caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP 8 0 3144713 1 1257887 2515772 3773656 5031541 



#caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP 6 0 4 1572360 3144716 4717071 4717072

#caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP 6 0 1 1572357 3144713 4717068 4717069

caput LabS-Embla{evr:1-SoftSeq:0}Commit-Cmd 1

# caget LabS-Embla{evr:1}Link-Sts

# caput LabS-Embla{evr:1}Link:Clk-SP 88.0525
# caput LabS-Embla{evr:1}Ena-Sel 1





