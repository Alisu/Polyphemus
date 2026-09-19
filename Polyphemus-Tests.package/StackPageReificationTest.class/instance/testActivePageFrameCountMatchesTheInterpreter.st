tests
testActivePageFrameCountMatchesTheInterpreter

	"Compare our frame walk with the interpreter's own rather than a fixed number. It starts at
	the interpreter's frame pointer: an active page's headFP is stale until the VM leaves it."

	| interp fp count |
	interp := reifiedMemory interpreter.
	fp := interp framePointer.
	count := 0.
	[ fp isNil or: [ fp = 0 ] ] whileFalse: [
		count := count + 1.
		fp := interp frameCallerFP: fp ].

	self assert: stackPages mostRecentlyUsedPage frames size equals: count
