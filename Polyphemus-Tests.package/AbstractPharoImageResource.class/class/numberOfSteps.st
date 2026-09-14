configuring
numberOfSteps

	"How far to interpret the image after loading it; 0 means use it as loaded."

	^ numberOfSteps ifNil: [ 0 ]
