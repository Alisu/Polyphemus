tests
testARunningVMReadsItsOwnVariables

	"This very VM, read through /proc: what it says of itself agrees with what it reports."

	| own |
	(Smalltalk os isUnix and: [ '/proc/self/maps' asFileReference exists ]) ifFalse: [
		^ self skip: 'this reads /proc, which only Linux has' ].
	own := VMVariables on: LinuxProcessMemory onSelf.

	self assert: (own at: 'numStackPages') equals: (Smalltalk vm parameterAt: 42).
	self
		assert: (own boundsOf: 'eden') value - (own boundsOf: 'eden') key
		equals: (Smalltalk vm parameterAt: 44)
