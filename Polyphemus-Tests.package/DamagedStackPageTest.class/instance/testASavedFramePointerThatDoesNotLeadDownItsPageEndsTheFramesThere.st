tests
testASavedFramePointerThatDoesNotLeadDownItsPageEndsTheFramesThere

	"#198: the newest frame saving its own address as its caller's never returned; an address off
	the stack pages emptied every page; zero made it the page's oldest frame, which it is not."

	| top |
	top := self frames first framePointer.
	{ top. top - 64. 16r1000. 0 } do: [ :each |
		self while: top holds: each do: [
			| frames |
			self
				should: [ frames := self frames ]
				notTakeMoreThan: 20 seconds.
			self assert: frames size = 1 description: 'saving ' , (each printStringRadix: 16).
			self assert: (reifiedMemory descriptionOfContext: frames first) equals: 'SessionManager>>newSession'.
			self deny: frames first isBaseFrame.
			self should: [ frames first sender ] raise: SpurCannotRead.
			self assert: reifiedMemory stacks livePages size equals: 1 ] ]
