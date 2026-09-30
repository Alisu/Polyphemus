tests
testTheCanvasShowsThePictureAsOneShape

	"One bitmap, its top left at the canvas' origin, so a canvas point is a picture point."

	| canvas |
	canvas := RSCanvas new.
	presenter buildIn: canvas.

	self assert: canvas shapes size equals: 1.
	self assert: (canvas shapes first isKindOf: RSBitmap).
	self assert: canvas shapes first encompassingRectangle origin equals: 0 @ 0
