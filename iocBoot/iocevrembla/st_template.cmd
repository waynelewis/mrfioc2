#!./bin/linux-x86_64/mrf

# Please don't modify this file, make a copy of it for your use

# Before running this, load the kernel modules by running the script "load_modules.sh" found in this directory
# After  running this IOC, make a copy of the "configure_sequence.sh", modify it with the pv name of your system and run it

# Load the dbd
dbLoadDatabase("dbd/mrf.dbd")
mrf_registerRecordDeviceDriver(pdbbase)

# Give the EVR in this machine a name such as EVR1, using its PCI address
mrmEvrSetupPCI("EVRX", "X:0.0")

# Load the EVR db using the previous name, changing the SYS macro to the name of your system, and the D macro to something like evr:1
dbLoadRecords("db/evr-pcie-300dc.db","EVR=EVRX,SYS=SYS,D=evr:X,FEVT=88.0525")

# Allow for up to 100us of jitter in the simulated 1 Hz when using "Sys clock"
var(evrMrmTimeNSOverflowThreshold, 100000)

iocInit()

# Get timestamp from system clock
dbpf SYS{evr:X}TimeSrc-Sel 2 # system clock (2)

# Setup the sequence for event code 14 generation
dbpf SYS{evr:X-SoftSeq:0}RunMode-Sel 0 # normal mode (0), the sequencer re-arms after it has finished
dbpf SYS{evr:X-SoftSeq:0}TrigSrc:2-Sel 2 # prescaler 0 (2), set the sequencer to trigger on prescaler 0
dbpf SYS{evr:X-SoftSeq:0}TsResolution-Sel 2 # us (2), set the sequencer timestamps to us
dbpf SYS{evr:X-SoftSeq:0}Load-Cmd 1 # load the sequencer
dbpf SYS{evr:X-SoftSeq:0}Enable-Cmd 1 # enamble the sequencer
# You need to run the script to configure the sequence manually after starting the IOC, since it needs to write arrays to waveforms

# Define 14Hz event and set the delay generator (pulser) and output
dbpf SYS{evr:X-PS:0}Div-SP 6289464 # ticks of event clock, set the prescaler to trigger on 14Hz by dividing down the event clock (88.0525 Mhz) by 6289464
dbpf SYS{evr:X-DlyGen:0}Width-SP 1000 # time in us, set the delay generator (pulser) 0 width to 1 ms
dbpf SYS{evr:X-DlyGen:0}Evt:Trig0-SP 14 # event number, set the delay DlyGen:00 to trigger on event 14
dbpf SYS{evr:X-Out:RBXX}Src-SP 0 # delay generator 0 (0), connect the output RBXX to DlyGen:0

