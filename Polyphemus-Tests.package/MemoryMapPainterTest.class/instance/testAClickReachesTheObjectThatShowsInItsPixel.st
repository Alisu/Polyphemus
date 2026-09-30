tests
testAClickReachesTheObjectThatShowsInItsPixel

	"The forwarder (bytes 24 to 39) shows through pixels 0 and 1, so they answer it; pixel 2 is
	all the next object's."

	| painter |
	painter := self painterFor: #( #( 40 1 2 ) #( 8 1 1 ) #( 41 1 5 ) ) bytesPerPixel: 32.

	self assert: (painter objectAtPixel: 0) equals: self baseAddress + 24.
	self assert: (painter objectAtPixel: 1) equals: self baseAddress + 24.
	self assert: (painter objectAtPixel: 2) equals: self baseAddress + 40.
	self assert: (painter objectAtPixel: 9) isNil
