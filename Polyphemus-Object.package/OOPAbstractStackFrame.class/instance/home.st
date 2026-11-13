context protocol
home

	"The method activation this one belongs to, through the outer contexts (#184); without one,
	the nearest sender running a method."

	self isBlockContext ifFalse: [ ^ self ].
	self outerContext ifNotNil: [ :outer | ^ outer home ].
	^ self findContextSuchThat: [ :each | each isBlockContext not ]