tests
testNoneOfItsFramesRunsMachineCodeAndItReadsNothingToSaySo

	"#118: it compared the frame's method field with a start of memory its simulator does not
	answer. The error, caught, was the answer, each time."

	self deny: ((OOPStackInterpreterLayout on: UnaskedDouble new) isMachineCodeFrame: 16r1000)
