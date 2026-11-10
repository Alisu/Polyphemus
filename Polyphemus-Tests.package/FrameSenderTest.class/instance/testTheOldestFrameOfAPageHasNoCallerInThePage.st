tests
testTheOldestFrameOfAPageHasNoCallerInThePage

	"#118: the oldest frame answered no #oopCaller at all, and #sender took the error for the
	answer. It answers nil, its sender then being the page's caller."

	self assert: OOPBaseFrame new oopCaller isNil
