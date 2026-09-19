testing
signalMachineCode

	^ (SpurCannotRead new
		   level: #frame
		   reason: #itIsAMachineCodeFrameAndWeHaveNoJITMapYet) signal
