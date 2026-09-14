tests
testActivePageFrameCountMatchesTheInterpreter

	"Guard against fixture drift: compare our frame walk with the interpreter's own,
	following #frameCallerFP: from the head frame, rather than a magic number."

	| interp fp vmCount |
	interp := reifiedMemory interpreter.
	fp := interp stackPages mostRecentlyUsedPage headFP.
	vmCount := 0.
	[ fp isNil or: [ fp = 0 ] ] whileFalse: [
		vmCount := vmCount + 1.
		fp := interp frameCallerFP: fp ].

	self assert: stackPages mostRecentlyUsedPage frames size equals: vmCount
