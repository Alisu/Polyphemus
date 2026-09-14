tests
testNoHighlightEverFallsOutsideTheSourceItPointsAt

	"The interval indexes the text the debugger is showing. One that runs past the end of
	that text, or starts before it, is not a near miss: it is a highlight over somebody
	else's code, and the reader has no way of telling."

	| withRange |
	withRange := 0.
	self allFrames do: [ :frame |
		| range source |
		range := frame pcRangeContextIsActive: false.
		range isEmpty ifFalse: [
			source := reifiedMemory sourceOfContext: frame.
			withRange := withRange + 1.
			self assert: range first >= 1.
			self assert: range last <= source size.
			self assert: range first <= range last ] ].

	self assert: withRange > 40
