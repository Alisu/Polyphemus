tests
testItsArgumentsAreReadFromTheFile

	"The image was written by snapshot: true andQuit: aBoolean: its first two temporaries, the
	arguments, still hold that true and that boolean (the pinned Pharo 14 image was saved
	without quitting, the others while quitting)."

	| frame |
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.

	self assert: (frame tempAt: 1) oopClassName equals: 'True'.
	self assert: (#( 'True' 'False' ) includes: (frame tempAt: 2) oopClassName)
