tests
testAForwarderIsPaintedAsSuch

	| painter |
	painter := self painterFor: #( #( 8 1 1 ) ) bytesPerPixel: 8.

	self assert: (painter categoryOfPixel: 0) equals: #forwarder
