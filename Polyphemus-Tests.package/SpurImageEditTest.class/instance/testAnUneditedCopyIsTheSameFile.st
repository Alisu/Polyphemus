tests
testAnUneditedCopyIsTheSameFile

	| memory |
	memory := SpurWritableImageFile on: PharoImageAccessor pathToCandle64Bit.
	memory writeTo: written.

	self
		assert: (written binaryReadStreamDo: [ :each | each upToEnd ])
		equals: (PharoImageAccessor pathToCandle64Bit asFileReference binaryReadStreamDo: [ :each | each upToEnd ])
