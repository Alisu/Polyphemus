tests
testEachFrameOfThePageHoldsTheStackTheVMCountsForIt

	"#176: a frame's stack ends where the VM ends it, above its callee's receiver (frameCallerSP:),
	the top frame's at the stack pointer; stackp is that count, its arguments included."

	| interpreter frames |
	interpreter := reifiedMemory interpreter.
	frames := stackPages mostRecentlyUsedPage frames.
	frames doWithIndex: [ :frame :index |
		| sp count |
		sp := index = 1
			      ifTrue: [ interpreter stackPointer ]
			      ifFalse: [ interpreter frameCallerSP: (frames at: index - 1) framePointer ].
		count := interpreter stackPointerIndexForFrame: frame framePointer WithSP: sp.
		self
			assert: (frame layout flagsOf: frame framePointer) numArgs + frame stackWords size
			equals: count.
		self assert: frame stackp equals: count ]