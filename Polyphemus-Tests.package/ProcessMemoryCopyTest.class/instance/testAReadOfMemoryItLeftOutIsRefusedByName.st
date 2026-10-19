tests
testAReadOfMemoryItLeftOutIsRefusedByName

	"The process had memory there, which the copy did not keep: refused, not read as missing,
	so a reading that needs more than the copy holds says so instead of guessing."

	| copy |
	copy := ProcessMemoryCopy of: process.
	self
		should: [ copy bytesAt: 16r30000 count: 8 ]
		raise: SpurCannotRead
		withExceptionDo: [ :e | self assert: e reason equals: #notCopiedWhileHeld ]
