tests
testFreeSpaceIsPaintedFree

	| painter |
	painter := self painterFor: #( #( 40 1 1 ) #( 0 1 1 ) #( 41 1 1 ) ) bytesPerPixel: 8.

	self assert: (self categoriesOf: painter upTo: 5) equals: #( #pointers #pointers #free #free #pointers #pointers )
