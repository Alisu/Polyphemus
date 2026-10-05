helpers
kindOf: aCore

	"#inItsFrame, #inAFramelessCallee, or nil for a core not caught in machine code."

	aCore exists ifFalse: [ ^ nil ].
	(VMVariables on: (ElfCoreDump on: aCore)) wasRunningMachineCode = true ifFalse: [ ^ nil ].
	^ [
	  (SpurDumpedMemory on: (ElfCoreDump on: aCore)) reifiedMemory vmLayout framesOfActiveProcess.
	  #inItsFrame ]
		  on: SpurCannotRead
		  do: [ :e |
			  (e messageText includesSubstring: 'itsInstructionPointerIsOutsideItsNewestFrame')
				  ifTrue: [ #inAFramelessCallee ]
				  ifFalse: [ nil ] ]
