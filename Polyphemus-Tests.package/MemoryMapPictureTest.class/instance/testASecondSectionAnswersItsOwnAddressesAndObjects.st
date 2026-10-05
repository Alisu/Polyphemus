tests
testASecondSectionAnswersItsOwnAddressesAndObjects

	"Two maps one above the other, as new space above old space: a point answers through the
	section it falls in."

	| two |
	two := MemoryMapPicture onSections: {
			       ('first' -> (self painterFor: #( #( 40 1 1 ) #( 41 16 1 ) ) bytesPerPixel: 8)).
			       ('second' -> (self painterFor: #( #( 42 24 1 ) #( 43 1 1 ) ) bytesPerPixel: 8)) }.

	self assert: two sectionLabels equals: #( 'first' 'second' ).
	self assert: (two originOf: 2) y > ((two originOf: 1) y + (two geometryOf: 1) height).
	self assert: (two addressAt: (two originOf: 2) + (1 @ 0)) equals: self baseAddress + 8.
	self assert: (two objectAt: (two originOf: 2) + (2 @ 0)) equals: self baseAddress + 16.
	self
		assert: (two form pixelValueAt: (two originOf: 2))
		equals: ((MemoryMapPicture colourOf: #compiledCode) pixelValueForDepth: 32).
	self assert: (two addressAt: (two originOf: 2) - (0 @ 5)) isNil
