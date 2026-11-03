tests
testWhatTheWatchAnswersItHoldsStrongly

	"#141: the heaps answered were a weak collection, and so was whatever was collected from them:
	the notes made of them went nil at the next collection (Windows, CI 41592533591)."

	| kept watch notes |
	watch := SpurHeapWatch during: [ kept := self heapOn: (ByteArrayAddressSpace on: (ByteArray new: 4096) at: 16r100000) ].
	notes := watch heaps collect: [ :each | each printString , ' noted' ].
	Smalltalk garbageCollect.
	self assert: notes size equals: 1.
	self assert: (notes allSatisfy: [ :each | each notNil ]).
	self assert: kept notNil
