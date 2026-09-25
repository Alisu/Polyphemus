tests
testAFullGarbageCollectionBetweenStepsIsSurvived

	"A step reads the image again into the copy it read before, keeping its classes. A full
	collection there compacts the heap and can move them: the context read afterwards must
	still be the one the image is in."

	self withAnAgentIn: self launchSpinningTarget do: [ :channel :reader |
		| held top |
		held := HeldProcess on: channel reader: reader identityHash: (self runawayHashIn: reader).
		held topContext.
		channel ask: 'Smalltalk garbageCollect. nil'.
		held stepOver.
		top := held topContext.
		self assert: top selector asString equals: held selector.
		self assert: top pc equals: held pc ]
