*Polyphemus-Memory
behavior

	"Which class the code pane should read the source against.

	Pharo asks the receiver for its class, which for a frame read out of a snapshot is
	the reified object's class in THIS image, OOPRegularObject, and then nothing in the
	source resolves. The class that owns the method lives in the snapshot, so ask the
	method for it."

	self context class == OOPContext ifTrue: [
		^ [ self context method methodClass ]
			  on: Error
			  do: [ :e | self context receiver class ] ].
	^ self context receiver class
