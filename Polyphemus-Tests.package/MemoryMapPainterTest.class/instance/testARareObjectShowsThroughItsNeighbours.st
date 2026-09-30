tests
testARareObjectShowsThroughItsNeighbours

	"Pixel 0 holds 24 bytes of pointers and 8 of a forwarder: the forwarder shows."

	| painter |
	painter := self painterFor: #( #( 40 1 2 ) #( 8 1 1 ) ) bytesPerPixel: 32.

	self assert: (painter categoryOfPixel: 0) equals: #forwarder
