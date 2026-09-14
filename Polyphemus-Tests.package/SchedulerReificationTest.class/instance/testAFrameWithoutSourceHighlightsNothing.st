tests
testAFrameWithoutSourceHighlightsNothing

	"Where a frame is can only be worked out by compiling its method's source and checking
	the result against the code in the file. This image carries no source, so there is
	nothing to compile and nothing to check, and an empty interval is the answer: the
	debugger highlights nothing rather than guessing at a line."

	| frame |
	frame := (reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess) first.

	self assert: (frame pcRangeContextIsActive: true) isEmpty.
	self assert: frame faithfulCompiledCode isNil
