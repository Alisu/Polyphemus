tests
testAskingForANameTheFrameDoesNotHaveIsAnError

	"nil is a value a temporary can hold. A frame that cannot read a name has to say so
	rather than answer nil, or the debugger cannot tell the two apart."

	| frame |
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.

	self should: [ frame tempNamed: 'notAVariableOfThisMethod' ] raise: Error
