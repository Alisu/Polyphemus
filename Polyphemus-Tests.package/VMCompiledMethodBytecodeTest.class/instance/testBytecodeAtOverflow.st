tests
testBytecodeAtOverflow
	self should: [ compiledMethodObject bytecodeAt: 6 ] raise: NotInTheReading 
	