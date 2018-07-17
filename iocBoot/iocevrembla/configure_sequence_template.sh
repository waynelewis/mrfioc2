#!/bin/bash

# Bash script to configure the EVR sequencer

# All values in us

# event code 14 (14 Hz), 127 is the end of sequence
caput -a SYS{evr:X-SoftSeq:0}EvtCode-SP 2 14 127

# Defining time at which the event codes are sent in us
caput -a SYS{evr:X-SoftSeq:0}Timestamp-SP 2 0 1

# Commit the sequence to HW
caput SYS{evr:X-SoftSeq:0}Commit-Cmd 1
