tests
testAnUneditedCopyIsTheSameFile

	| edit |
	edit := SpurImageEdit on: PharoImageAccessor pathToCandle64Bit.
	edit writeTo: written.

	self
		assert: (written binaryReadStreamDo: [ :each | each upToEnd ])
		equals: (PharoImageAccessor pathToCandle64Bit asFileReference binaryReadStreamDo: [ :each | each upToEnd ])
