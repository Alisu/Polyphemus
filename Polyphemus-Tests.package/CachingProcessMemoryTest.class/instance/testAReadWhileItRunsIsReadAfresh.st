tests
testAReadWhileItRunsIsReadAfresh

	"Running, it may change any byte: nothing read then is kept, as on Linux (#26)."

	process bytesAt: 16r100010 count: 4.
	process bytesAt: 16r100010 count: 4.
	self assert: process asked equals: 2
