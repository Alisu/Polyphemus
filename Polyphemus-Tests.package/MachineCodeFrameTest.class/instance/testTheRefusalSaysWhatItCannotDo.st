tests
testTheRefusalSaysWhatItCannotDo

	"Named, so that a reader is told the frame is jitted rather than merely that something
	went wrong -- and so that the day the JIT map is read, there is one reason to search for."

	| raised |
	raised := [ FrameRunningMachineCode new oopReceiver. nil ]
		          on: SpurCannotRead
		          do: [ :error | error ].

	self assert: raised isNotNil.
	self assert: raised level equals: #frame.
	self
		assert: raised reason
		equals: #itIsAMachineCodeFrameAndWeHaveNoJITMapYet
