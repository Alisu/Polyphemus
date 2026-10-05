tests
testACoreCaughtInAFramelessCalleeIsRefusedNotMisread

	"rip in a callee that has no frame of its own yet (frameless, or in its prologue): rbp still
	describes the caller, and reading from it would show the caller as newest. Refused, saying
	why."

	| core memory |
	core := (self machineCodeCoreWhere: #inAFramelessCallee) ifNil: [
		        ^ self skip: 'no gdb here, or no core caught in a frameless callee' ].
	memory := (SpurDumpedMemory on: (ElfCoreDump on: core)) reifiedMemory.

	self
		should: [ memory vmLayout framesOfActiveProcess ]
		raise: SpurCannotRead
		withExceptionDo: [ :e |
			self assert: (e messageText includesSubstring: 'itsInstructionPointerIsOutsideItsNewestFrame') ]
