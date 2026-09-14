tests
testActivePageFrameCountMatchesTheInterpreter

	"Guard against fixture drift: compare our frame walk with the interpreter's own
	rather than asserting a magic number. The walk starts at the interpreter's frame
	pointer, not at the page's headFP: while a page is active its headFP is stale,
	the VM only writes it back when it leaves the page."

	| interp fp count |
	interp := reifiedMemory interpreter.
	fp := interp framePointer.
	count := 0.
	[ fp isNil or: [ fp = 0 ] ] whileFalse: [
		count := count + 1.
		fp := interp frameCallerFP: fp ].

	self assert: stackPages mostRecentlyUsedPage frames size equals: count
