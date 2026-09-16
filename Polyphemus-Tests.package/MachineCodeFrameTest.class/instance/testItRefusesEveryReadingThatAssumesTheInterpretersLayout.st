tests
testItRefusesEveryReadingThatAssumesTheInterpretersLayout

	"Cog lays a frame out differently: the receiver is elsewhere, FoxCallerContext does not
	exist, and the instruction pointer is a code zone address. Every one of these reads an
	offset from the frame pointer, so every one of them must refuse rather than answer.

	This is the half of the JIT work that is worth having first. Reading such a frame
	properly needs Cog's own map; refusing to read it wrongly needs one comparison, and
	without it a stack would come out full of confident nonsense."

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
