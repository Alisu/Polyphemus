tests
testAFrameWithTemporariesNamesThemOrSaysWhy

	"On the Pharo 10 image a Pharo 12 or later host cannot name them (#6): the values are still
	given, by number, and the frame says why the names are missing."

	| frame temporaries |
	frame := self frameRunning: 'SessionManager>>snapshot:andQuit:' in: self resource pharo10.
	self assert: frame notNil.
	temporaries := frame at: 'temporaries'.
	self assert: temporaries notEmpty.
	(temporaries anySatisfy: [ :each | (each at: 'name') isNil ]) ifTrue: [
		self assert: (frame at: 'note') notEmpty ]
