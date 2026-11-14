reading
framePointerOf: aContext

	"The frame a married context names in its sender slot, believed only if that frame's context
	field points back at aContext and its flags, where they read, say it is married: flags that
	do not read cost the frame its flags, not the context its frames."

	| fp |
	fp := (memory simulator fetchPointer: 0 ofObject: aContext address) - 1.
	(raw spaceHolding: fp) ifNil: [ ^ nil ].
	(self contextOf: fp) = aContext address ifFalse: [ ^ nil ].
	([ (self flagsOf: fp) isMarried ] on: NotInTheReading do: [ :refusal | true ]) ifFalse: [ ^ nil ].
	^ fp
