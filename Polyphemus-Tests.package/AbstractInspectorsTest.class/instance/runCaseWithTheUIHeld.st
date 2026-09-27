running
runCaseWithTheUIHeld

	"For tests that open windows and change them from this process: Morphic's UI process would
	draw them meanwhile, and Pharo 12's Roassal loses its damage to that (#56)."

	^ HeldMorphicUI during: [ super runCase ]
