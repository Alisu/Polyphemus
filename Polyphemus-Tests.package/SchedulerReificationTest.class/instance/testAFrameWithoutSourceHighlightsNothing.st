tests
testAFrameWithoutSourceHighlightsNothing

	"Where a frame is needs its source compiled and checked against the file's code. With no
	source there is nothing to check: an empty interval, never a guessed line."

	| frame |
	frame := (reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess) first.

	self assert: (frame pcRangeContextIsActive: true) isEmpty.
	self assert: frame faithfulCompiledCode isNil
