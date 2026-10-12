tests
testTheSnapshottingFrameNamesItsTemporaries

	"On the edition's own image the host lays the method out as the image did (#6): the frame of
	the snapshot names its arguments and says which statement it was in."

	| frame names |
	frame := self frameRunning: 'SessionManager>>snapshot:andQuit:' in: self resource target.
	self assert: frame notNil.
	names := (frame at: 'temporaries') collect: [ :each | each at: 'name' ].
	self assert: (names includesAll: #( 'save' 'quit' )).
	self assert: (frame at: 'statement') notEmpty
