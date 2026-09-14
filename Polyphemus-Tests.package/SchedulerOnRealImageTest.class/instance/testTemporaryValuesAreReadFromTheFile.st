tests
testTemporaryValuesAreReadFromTheFile

	"The image was written by an evaluation of snapshot: true andQuit: true, and that is
	what its arguments still hold. The values are objects of that image, not of ours."

	| frame |
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.

	self assert: (frame tempNamed: 'save') oopClassName equals: 'True'.
	self assert: (frame tempNamed: 'quit') oopClassName equals: 'True'.
	self assert: (frame tempNamed: 'wait') oopClassName equals: 'Semaphore'
