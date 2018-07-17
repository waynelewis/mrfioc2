import numpy as np
import sys

ticks = 6289424

RiseEdge = []

freq = sys.argv[1] #Desiered frequency

NumOfPulses = int(round(int(freq)/14))+1

def CreateTickList(NumOfPulses):
	RisEdgeTmp = np.linspace(1,ticks, NumOfPulses)

        for x in RisEdgeTmp:
                rounded =  int(round(x))
                RiseEdge.append(rounded)
        RiseEdge[-1] = RiseEdge[-2]+1
	return RiseEdge

def CreateOutput(array, NumOfPulses):
	CaputCmd = "caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP "+str(NumOfPulses+1)+" 0"
	
	TickString = ' '.join(str(x) for x in array)
	
	fullString = CaputCmd+" "+TickString 
	return fullString

def main():
	RiseEdge = CreateTickList(NumOfPulses)
	output = CreateOutput(RiseEdge, NumOfPulses)
	print output
	print "caput LabS-Embla{evr:1-SoftSeq:0}Commit-Cmd 1"

if __name__ == "__main__":
    main()
