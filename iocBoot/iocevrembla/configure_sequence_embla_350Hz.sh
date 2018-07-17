#!/bin/bash
# Bash script to configure the EVR sequencer

# All values in uSec

# event code 14 (14 Hz), 123 is the prescaler sync reset, 127 is the end of sequence
caput -a LabS-Embla{evr:1-SoftSeq:0}EvtCode-SP 27 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 127


# Defining time at which the event codes are sent, units are ticks of the event clock (~11.37 ns)
caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP 27 0 1 251579 503157 754736 1006314 1257893 1509471 1761050 2012628 2264207 2515786 2767364 3018943 3270521 3522100 3773678 4025257 4276836 4528414 4779993 5031571 5283150 5534728 5786307 6037885 6037886


caput LabS-Embla{evr:1-SoftSeq:0}Commit-Cmd 1

# caget LabS-Embla{evr:1}Link-Sts





# caput LabS-Embla{evr:1}Link:Clk-SP 88.0525
# caput LabS-Embla{evr:1}Ena-Sel 1
