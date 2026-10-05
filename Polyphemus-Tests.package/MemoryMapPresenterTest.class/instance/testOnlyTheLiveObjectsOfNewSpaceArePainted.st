tests
testOnlyTheLiveObjectsOfNewSpaceArePainted

	"Past eden's allocation pointer there are no objects: that part of new space shows nothing."

	| picture map beyond |
	picture := presenter picture.
	map := picture geometryOf: 1.
	beyond := (map pixelIndexOf: memory freeStart) + 1.
	beyond < map pixelCount ifFalse: [ ^ self skip: 'eden is full in this image' ].

	self assert: ((picture painterOf: 1) categoryOfPixel: beyond) equals: #nothing
