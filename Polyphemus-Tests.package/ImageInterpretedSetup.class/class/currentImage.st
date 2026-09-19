accessing
currentImage
	"The anonymous resource: a Pharo 10 image interpreted a few steps. Never compile here: it
	asks for initials and errors every test."

	"If the platform does not support wget, it'll loop endlessly.
	This is not great.
	We therefore exclude windows for now"
	PlatformResolver forCurrentPlatform class platformName = 'Win32'
		ifTrue: [ ^ self ].
	currentImage ifNotNil: [ ^ currentImage ].

	currentImage := Pharo10ImageResource newSubclass.
	currentImage numberOfSteps: self numberOfSteps.

	^ currentImage
