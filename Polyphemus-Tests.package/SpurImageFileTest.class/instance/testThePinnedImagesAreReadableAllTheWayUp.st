tests
testThePinnedImagesAreReadableAllTheWayUp

	{ PharoImageAccessor pathToPharo10. PharoImageAccessor pathToCandle64Bit } do: [ :each |
		| readability |
		readability := (SpurRawHeap on: (self open: each)) readability.
		self assert: readability refusals asArray equals: #(  ).
		self assert: readability isFullyReadable ]
