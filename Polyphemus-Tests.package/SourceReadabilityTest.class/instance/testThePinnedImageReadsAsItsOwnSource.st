tests
testThePinnedImageReadsAsItsOwnSource

	| memory |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToPharo10.

	self assert: memory sourceReadability refusals asArray equals: #(  ).
	self assert: (memory sourceReadability canRead: #source)
