tests
testAnAddressTheProcessNeverHadAnswersNothing

	| copy |
	copy := ProcessMemoryCopy of: process.
	self assert: (copy bytesAt: 16r50000 count: 8) isNil.
	self deny: (copy hasAddress: 16r50000)
