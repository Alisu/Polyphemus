tests
testAFrameIsNotTheNilObjectAndSaysSo

	"#118: a stack is walked sender by sender up to the nil object. A frame did not understand the
	question, and the error, caught, stood for its answer on every frame of every stack."

	self deny: FrameWithACallerThatDoesNotRead new isNilOop
