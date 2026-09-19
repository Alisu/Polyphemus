accessing
wasRunningMachineCode

	"Whether a thread was in Cog's code zone: then the newest frames are only in its
	registers, and the variables the VM saves on leaving for C are stale. nil when the
	memory keeps no registers, as a live process read through /proc does not."

	| low high |
	(memory respondsTo: #threadRegisters) ifFalse: [ ^ nil ].
	low := self at: 'codeBase'.
	high := self at: 'mzFreeStart'.
	^ memory threadRegisters anySatisfy: [ :each | (each at: #rip) between: low and: high - 1 ]
