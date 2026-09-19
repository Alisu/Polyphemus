accessing
wasRunningMachineCode

	"Whether a thread was in Cog's code zone: then the newest frames are only in its
	registers, and the variables the VM saves on leaving for C are stale. nil when that
	cannot be told: no registers kept, or a thread that gives none."

	| threads low high |
	(memory respondsTo: #threadRegisters) ifFalse: [ ^ nil ].
	threads := memory threadRegisters.
	(threads isEmpty or: [ threads anySatisfy: [ :each | (each includesKey: #rip) not ] ])
		ifTrue: [ ^ nil ].
	low := self at: 'codeBase'.
	high := self at: 'mzFreeStart'.
	^ threads anySatisfy: [ :each | (each at: #rip) between: low and: high - 1 ]
