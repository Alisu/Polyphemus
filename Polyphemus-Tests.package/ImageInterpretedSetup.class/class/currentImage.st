accessing
currentImage
	"The resource for this test class: a Pharo 10 image interpreted a few steps.
	It is anonymous, so SUnit is never told we use a resource; we just tell it how
	many steps to interpret and it reproduces that state in its own setUp.

	Do not compile anything here: compiling asks for the author's initials, which
	Pharo's test execution environment reports as an error in every test."

	"If the platform does not support wget, it'll loop endlessly.
	This is not great.
	We therefore exclude windows for now"
	PlatformResolver forCurrentPlatform class platformName = 'Win32'
		ifTrue: [ ^ self ].
	currentImage ifNotNil: [ ^ currentImage ].

	currentImage := Pharo10ImageResource newSubclass.
	currentImage numberOfSteps: self numberOfSteps.

	^ currentImage
