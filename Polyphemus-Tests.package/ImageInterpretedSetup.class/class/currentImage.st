accessing
currentImage
	"The anonymous resource: a Pharo 10 image interpreted a few steps. Never compile here: it
	asks for initials and errors every test."

	currentImage ifNotNil: [ ^ currentImage ].

	currentImage := Pharo10ImageResource newSubclass.
	currentImage numberOfSteps: self numberOfSteps.

	^ currentImage
