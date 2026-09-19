tests
testItRefusesEveryReadingThatAssumesTheInterpretersLayout

	"Every reader that uses the interpreter's frame offsets refuses a JIT frame."

	| frame |
	frame := FrameRunningMachineCode new.

	self assert: frame isMachineCodeFrame.
	self deny: frame isReadable.

	#( #oopReceiver #oopMethod #oopContext #oopPageCaller #instructionPointer #stackp )
		do: [ :each |
			self
				should: [ frame perform: each ]
				raise: SpurCannotRead
				description: each printString , ' should refuse, not answer' ]
