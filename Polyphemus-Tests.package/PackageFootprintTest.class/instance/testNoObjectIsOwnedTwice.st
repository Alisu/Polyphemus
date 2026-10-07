tests
testNoObjectIsOwnedTwice

	| lines |
	lines := self footprint lines.
	self assert: (lines inject: 0 into: [ :sum :each | sum + each count ]) equals: self footprint ownedObjectCount.
	self assert: (lines inject: 0 into: [ :sum :each | sum + each bytes ]) equals: self footprint ownedBytes
