reading
framePointerOf: aContext

	"The frame a married context names in its sender slot, believed only if that frame is
	married and its context field points back at aContext."

	| fp |
	fp := (memory simulator fetchPointer: 0 ofObject: aContext address) - 1.
	(raw spaceHolding: fp) ifNil: [ ^ nil ].
	(self contextOf: fp) = aContext address ifFalse: [ ^ nil ].
	(self flagsOf: fp) isMarried ifFalse: [ ^ nil ].
	^ fp
