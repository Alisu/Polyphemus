tests
testItListsItsOwnReadableRegions

	| bytes reader |
	bytes := self sixteenBytes.
	reader := MacProcessMemory onSelf.
	self assert: reader loadableSegments notEmpty.
	self assert: (reader loadableSegments allSatisfy: [ :each | each sizeInMemory > 0 ]).
	self assert: (reader hasAddress: bytes asInteger).
	bytes free
