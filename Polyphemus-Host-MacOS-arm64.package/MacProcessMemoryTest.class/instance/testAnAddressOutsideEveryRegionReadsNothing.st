tests
testAnAddressOutsideEveryRegionReadsNothing

	"Page zero is never mapped: no bytes, as a dump answers, rather than an error."

	self assert: (MacProcessMemory onSelf bytesAt: 8 count: 8) isNil
