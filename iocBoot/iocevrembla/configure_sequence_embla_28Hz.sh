#!/bin/bash
# Bash script to configure the EVR sequencer

# All values in uSec

# event code 14 (14 Hz), 123 is the prescaler sync reset, 127 is the end of sequence
caput -a LabS-Embla{evr:1-SoftSeq:0}EvtCode-SP 4 14 15 15 127

# Defining time at which the event codes are sent
caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP 4 0 1 3144712 3144713 #6289424/2 because slightly higher freq in evrst # 3144732 3144733

caput -n LabS-Embla{evr:1-SoftSeq:0}Commit-Cmd 1

# caget LabS-Embla{evr:1}Link-Sts





# caput LabS-Embla{evr:1}Link:Clk-SP 88.0525
# caput LabS-Embla{evr:1}Ena-Sel 1
