tests
testEachObjectIsPaintedByItsFormat

	"A header and a slot each, eight bytes a pixel: two pixels an object."

	| painter |
	painter := self
		           painterFor: #( #( 40 1 1 ) #( 41 16 1 ) #( 42 24 1 ) #( 43 10 1 ) )
		           bytesPerPixel: 8.

	self
		assert: (self categoriesOf: painter upTo: 7)
		equals: #( #pointers #pointers #bytes #bytes #compiledCode #compiledCode #words #words )
