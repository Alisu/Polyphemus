tests
testAHeapWithoutASpecialObjectsArrayAnswersNothing

	"A heap where no object begins with nil, false and true answers nil rather than the first
	array it comes across. Answering the wrong object here would be worse than answering none:
	everything read afterwards would be read through it."

	| base space |
	base := self baseAddress.
	space := self spaceFor: self aFewObjects.

	self assert: ((SpurHeapScanner on: space)
			 specialObjectsArrayFrom: base
			 upTo: base + space size) isNil
