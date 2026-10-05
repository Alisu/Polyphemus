accessing
registersOfTheThreadInMachineCode

	"The registers of the thread that was in Cog's code zone (wasRunningMachineCode): there
	rbp is Cog's frame pointer and rsp its stack pointer (#17). nil when none was."

	| low high |
	(memory respondsTo: #threadRegisters) ifFalse: [ ^ nil ].
	low := self at: 'codeBase'.
	high := self at: 'mzFreeStart'.
	^ memory threadRegisters
		  detect: [ :each | (each at: #rip ifAbsent: [ nil ]) ifNil: [ false ] ifNotNil: [ :rip | rip between: low and: high - 1 ] ]
		  ifNone: [ nil ]
