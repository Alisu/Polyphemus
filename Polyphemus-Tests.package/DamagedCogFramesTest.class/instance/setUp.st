running
setUp

	"The process with the most frames, found before anything is patched."

	| depth |
	super setUp.
	DamagedCoreTest hasAnElfCore ifFalse: [ ^ self skip: 'no ELF core here; make one with bin/take-dump.sh' ].
	memory := self class memory.
	depth := [ :each | ((memory activationsOfProcess: each) select: [ :activation | activation isStackFrame ]) size ].
	process := memory allReifiedProcesses detectMax: depth
