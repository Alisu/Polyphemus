tests
testItReadsACoreDump

	"A dead VM's memory through the same front door. The deepest process is the one to show:
	most are one context waiting on a semaphore."

	| core memory deepest |
	core := (Smalltalk os environment at: 'POLYPHEMUS_CORE' ifAbsent: [ nil ])
		        ifNil: [ FileLocator imageDirectory / 'pharo.core' ]
		        ifNotNil: [ :path | path asFileReference ].
	core exists ifFalse: [ ^ self skip: 'no core dump here; make one with bin/take-dump.sh' ].

	memory := Polyphemus readCoreDump: core.
	deepest := Polyphemus deepestProcessIn: memory.

	self assert: memory allReifiedProcesses size > 1.
	self assert: (memory contextsOfProcess: deepest) size > 3
