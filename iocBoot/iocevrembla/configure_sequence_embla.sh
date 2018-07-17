#!/bin/bash
# Bash script to configure the EVR sequencer

# All values in uSec

# event code 14 (14 Hz), 123 is the prescaler sync reset, 127 is the end of sequence
caput -a LabS-Embla{evr:1-SoftSeq:0}EvtCode-SP 2 14 127

# Defining time at which the event codes are sent
caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP 2 0 1

caput -n LabS-Embla{evr:1-SoftSeq:0}Commit-Cmd 1

# caget LabS-Embla{evr:1}Link-Sts





# caput LabS-Embla{evr:1}Link:Clk-SP 88.0525
# caput LabS-Embla{evr:1}Ena-Sel 1
