tests
testSourceIsUnavailableInTheCandleImage

	"The bootstrap image ships no .sources file. A method whose source cannot be found
	answers nil rather than raising: stage one reads whatever an image happens to
	carry."

	| stack |
	stack := reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess.

	self assert: (reifiedMemory sourceOfContext: stack first) isNil
