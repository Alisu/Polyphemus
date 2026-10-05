tests
testNewSpaceIsASectionOfItsOwnAboveOldSpace

	"All of new space, at old space's scale, so their sizes compare."

	| picture |
	picture := presenter picture.

	self assert: picture sectionLabels equals: #( 'new space' 'old space' ).
	self assert: (picture geometryOf: 1) start equals: memory newSpaceStart.
	self assert: (picture geometryOf: 1) end equals: memory newSpaceLimit.
	self assert: (picture geometryOf: 1) bytesPerPixel equals: (picture geometryOf: 2) bytesPerPixel.
	self assert: (picture geometryOf: 2) start equals: memory nilObject
