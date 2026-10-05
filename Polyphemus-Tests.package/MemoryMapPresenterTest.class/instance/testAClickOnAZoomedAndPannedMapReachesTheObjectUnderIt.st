tests
testAClickOnAZoomedAndPannedMapReachesTheObjectUnderIt

	"Roassal hands a click its position in pixels, as RSAthensMorph makes the event; the map is
	zoomed and panned, so the object is the one under that pixel once the camera is undone."

	| canvas bitmap target pixel event |
	canvas := RSCanvas new.
	presenter buildIn: canvas.
	bitmap := canvas shapes first.
	canvas camera
		scale: 2;
		translateTo: 300 @ 40.
	target := presenter picture mapOrigin + (40 @ 3).
	pixel := canvas camera fromSpaceToPixel: target.
	self deny: (presenter picture objectAt: pixel) equals: (presenter picture objectAt: target).

	event := RSMouseClick new.
	event
		canvas: canvas;
		shape: bitmap;
		position: pixel.
	bitmap announce: event.

	self assert: chosen notNil.
	self assert: chosen equals: (presenter picture objectAt: target)
