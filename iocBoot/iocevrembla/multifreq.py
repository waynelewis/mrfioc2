import numpy as np
import sys
from collections import OrderedDict
import os
import time

ticks = 6289424

RiseEdge = []
freq = []
delay = []

f = open("freq.cfg","r")


for x in f:
	if x[0] != '#':
		freq.append(int(x.split(",")[0]))
		delay.append(x.split(",")[1][:-1])

print freq
print delay

NumOfPulses1 = int(round(int(freq[0])/14))+1
NumOfPulses2 = int(round(int(freq[1])/14))+1
NumOfPulses3 = int(round(int(freq[2])/14))+1
NumOfPulses4 = int(round(int(freq[3])/14))+1

def CreateTickList(NumOfPulsesX):
	RiseEdge = []
	RisEdgeTmp = np.linspace(0,ticks, NumOfPulsesX)

        for x in RisEdgeTmp:
                rounded =  int(round(x))
                RiseEdge.append(rounded)
	RiseEdge[-1] = RiseEdge[-2]+1
	return RiseEdge[:-1]

def CreateOutput(array, ports, NumOfPulsesX):
#	caput -a LabS-Embla{evr:1-SoftSeq:0}EvtCode-SP 27 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 127
	CaputCmdSeq = "caput -a LabS-Embla{evr:1-SoftSeq:0}EvtCode-SP "+str(NumOfPulsesX+1)
	EvtString = ' '.join(str(x) for x in ports)
	fullEvtString = CaputCmdSeq+" "+EvtString+" 127"


	CaputCmdTime = "caput -a LabS-Embla{evr:1-SoftSeq:0}Timestamp-SP "+str(NumOfPulsesX+1)
	
	TickString = ' '.join(str(x) for x in array)

	fullString = CaputCmdTime+" "+TickString

	CaputCmdCommit = "caput LabS-Embla{evr:1-SoftSeq:0}Commit-Cmd 1"



	return fullString, fullEvtString

def ShiftLists(array1, array2, array3, array4):
	Arr0Unique = 0
	Arr1Unique = 1
	Arr2Unique = 2
	Arr3Unique = 3

	d = {'array1': len(array1), 'array2': len(array2), 'array3': len(array3), 'array4': len(array4)}
	orderedByLength = OrderedDict(sorted(d.items(), key=lambda t: t[1]))

	arrays = orderedByLength.keys()
	print arrays	

	Arr0 = vars()[arrays[0]]
	Arr1 = vars()[arrays[1]]
	Arr2 = vars()[arrays[2]]
	Arr3 = vars()[arrays[3]]
	
	if len(Arr1) ==	len(Arr0) and len(Arr2) ==len(Arr1) and len(Arr3) ==len(Arr2):
		allsame = True
	else:

		if len(Arr1) > len(Arr0):
                       Arr1 = [item+1 for item in Arr1]
	
		if len(Arr2) == len(Arr1) and len(Arr1) > len(Arr0):
			Arr2 = [item+1 for item in Arr2]
		if len(Arr2) > len(Arr1) and len(Arr1) > len(Arr0):
			Arr2 = [item+2 for item in Arr2]
		if len(Arr2) > len(Arr1) and len(Arr1) == len(Arr0):
			Arr2 = [item+1 for item in Arr2]

		if len(Arr3) == len(Arr2) and len(Arr2) > len(Arr1) and len(Arr1) > len(Arr0):
			Arr3 = [item+2 for item in Arr3]
		if len(Arr3) > len(Arr2) and len(Arr2) == len(Arr1) and len(Arr1) > len(Arr0):
			Arr3 = [item+2 for item in Arr3]
		if len(Arr3) > len(Arr2) and len(Arr2) == len(Arr1) and len(Arr1) == len(Arr0):
                        Arr3 = [item+1 for item in Arr3]
		if len(Arr3) > len(Arr2) and len(Arr2) > len(Arr1) and len(Arr1) == len(Arr0):
                        Arr3 = [item+2 for item in Arr3]
		if len(Arr3) == len(Arr2) and len(Arr2) > len(Arr1) and len(Arr1) == len(Arr0):
                        Arr3 = [item+1 for item in Arr3]
		if len(Arr3) == len(Arr2) and len(Arr2) == len(Arr1) and len(Arr1) > len(Arr0):
                       	Arr3 = [item+1 for item in Arr3]
		if len(Arr3) > len(Arr2) and len(Arr2) > len(Arr1) and len(Arr1) > len(Arr0):
			Arr3 = [item+3 for item in Arr3]
	
	d2 = {arrays[0]: Arr0, arrays[1]: Arr1, arrays[2]: Arr2, arrays[3]: Arr3}

	shiftedArrays= OrderedDict(sorted(d2.items(),key=lambda t:t[0]))

	return shiftedArrays.values()[0], shiftedArrays.values()[1], shiftedArrays.values()[2], shiftedArrays.values()[3]

def ShiftLists2(array1, array2, array3, array4):
	#array1 = [item+1 for item in Arr1]
	array2 = [item+1 for item in array2]
	array3 = [item+2 for item in array3]
	array4 = [item+3 for item in array4]
	return array1, array2, array3, array4

def CreateSequence(array1, array2, array3, array4):
	port1 = []
	port2 = []
	port3 = []
	port4 = []

	for x in range(0,len(array1)):
		port1.append(14)

	for x in range(0,len(array2)):
                port2.append(15)

	for x in range(0,len(array3)):
                port3.append(16)
	
	for x in range(0,len(array4)):
                port4.append(17)

	



	sequence = array1+array2+array3+array4
	ports = port1+port2+port3+port4
	
	print "********"
	print ports
	dictionary = dict(zip(sequence, ports))
	print dictionary
	print "********"
#	d3 = OrderedDict(sorted(dictionary.items(),key=lambda t:t[0]))
	d3 = OrderedDict(sorted(dictionary.items()))
	seqTime = d3.keys()
	seqEvt = d3.values()

		
	#seqFrq = 
	
	print seqTime
	print seqEvt
	
	#seqArray = (sequence, ports)	

	#print seqArray


	#sequence = sorted(sequence)
	
	#print "****"
	#print sequence
	return seqTime, seqEvt, len(seqTime)

def main():
	RiseEdge1 = CreateTickList(NumOfPulses1)
	RiseEdge2 = CreateTickList(NumOfPulses2)
	RiseEdge3 = CreateTickList(NumOfPulses3)
	RiseEdge4 = CreateTickList(NumOfPulses4)

	RiseEdge1, RiseEdge2, RiseEdge3, RiseEdge4 = ShiftLists2(RiseEdge1, RiseEdge2, RiseEdge3, RiseEdge4)
	
	#print "rise edge4 "+str(RiseEdge4)
	#output1 = CreateOutput(RiseEdge1, NumOfPulses1)
	#output2 = CreateOutput(RiseEdge2, NumOfPulses2)
	#output3 = CreateOutput(RiseEdge3, NumOfPulses3)
	#output4 = CreateOutput(RiseEdge4, NumOfPulses4)
	
	#print output1
	#print output2
	#print output3
	#print output4

	print RiseEdge1

	sequence, ports, NumOfPulses = CreateSequence(RiseEdge1, RiseEdge2, RiseEdge3, RiseEdge4)
	output, events = CreateOutput(sequence, ports, NumOfPulses)
	#print events
	#print output
	os.system("/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/"+events)
	time.sleep(3)
	os.system("/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/"+output)	
	time.sleep(3)
	os.system("/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/caput LabS-Embla{evr:1-SoftSeq:0}Commit-Cmd 1")
	time.sleep(3)	
	os.system("/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/caput LabS-Embla{evr:1-DlyGen:0}Delay-SP "+delay[0])
	os.system("/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/caput LabS-Embla{evr:1-DlyGen:1}Delay-SP "+delay[1])
	os.system("/opt/epics/bases/base-3.15.4/bin/centos7-x86_64/caput LabS-Embla{evr:1-DlyGen:2}Delay-SP "+delay[2])

		

if __name__ == "__main__":
    main()
