mapping
objectAt: aPoint

	"The address of the object showing at that point of the picture, or nil."

	| index point |
	index := (self sectionAt: aPoint) ifNil: [ ^ nil ].
	(self addressAt: aPoint) ifNil: [ ^ nil ].
	point := aPoint - (self originOf: index).
	^ (self painterOf: index) objectAtPixel: point y * (self geometryOf: index) width + point x
