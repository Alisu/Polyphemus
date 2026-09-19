tests
testItReadsACoreDump

	"The memory of a virtual machine that died, through the same door, answering the same
	questions.

	The process with the most to show is what a newcomer should be shown first. Most are a
	single context waiting on a semaphore; the one that was running has none at all."

	| core memory deepest |
	core := (Smalltalk os environment at: 'POLYPHEMUS_CORE' ifAbsent: [ nil ])
		        ifNil: [ FileLocator imageDirectory / 'pharo.core' ]
		        ifNotNil: [ :path | path asFileReference ].
	core exists ifFalse: [ ^ self skip: 'no core dump here; make one with bin/take-dump.sh' ].

	memory := Polyphemus readCoreDump: core.
	deepest := Polyphemus deepestProcessIn: memory.

	self assert: memory allReifiedProcesses size > 1.
	self assert: (memory contextsOfProcess: deepest) size > 3
