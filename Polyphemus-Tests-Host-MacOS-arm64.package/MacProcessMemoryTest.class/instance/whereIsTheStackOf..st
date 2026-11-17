helpers
whereIsTheStackOf: someRegisters

	"For a failure: the thread's sp, pc and where its pc is."

	^ 'sp 16r' , (someRegisters at: #sp) printStringHex , ', pc 16r' , (someRegisters at: #pc) printStringHex , ' in '
	  , ((MacStuckThread functionAt: (someRegisters at: #pc)) ifNil: [ '?' ])
