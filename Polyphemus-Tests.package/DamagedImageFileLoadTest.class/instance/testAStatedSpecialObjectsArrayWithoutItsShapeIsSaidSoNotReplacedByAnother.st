tests
testAStatedSpecialObjectsArrayWithoutItsShapeIsSaidSoNotReplacedByAnother
	<readsAnUnsoundHeap>

	"#207: nil's special object zeroed, so the array the header states no longer starts with nil,
	false and true, which is how such an array is found. Another array of that shape was taken in
	its place and the ladder said the special objects read. It says the stated one has not."

	self withACopyDamagedBy: (self addressOf: #special at: 1) -> 0 do: [ :copy |
		| readability |
		readability := Polyphemus readabilityOfImageFile: copy fullName.
		self assert: (readability whyNot: #specialObjects) equals: #theStatedArrayDoesNotStartWithNilFalseAndTrue.
		self assert: ((readability whereNot: #specialObjects) beginsWith: 'the array stated at 16r').
		self should: [ readability require: #specialObjects ] raise: SpurCannotRead ]
