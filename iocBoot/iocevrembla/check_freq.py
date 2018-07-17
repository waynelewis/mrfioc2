#!/usr/bin/env python
import commands
import os
import time

start = time.time()
counter = []

while True:
	end = time.time()
	lapsed_time = (end-start)
	if lapsed_time <= 60.02:
		counter.append(commands.getoutput('caget LabS-Embla{evr:1}EvtECnt-I'))

	else:
		first = counter[0].split('LabS-Embla{evr:1}EvtECnt-I')
		last = counter[-1].split('LabS-Embla{evr:1}EvtECnt-I')

		print('Approx. EVR output frequency: '+(str((float(last[1])-float(first[1]))/60)+' Hz'))
		
		break
