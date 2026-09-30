mapping
objectAt: aPoint

	"The address of the object showing at that point of the picture, or nil."

	| point |
	(self addressAt: aPoint) ifNil: [ ^ nil ].
	point := aPoint - self mapOrigin.
	^ painter objectAtPixel: point y * self geometry width + point x
