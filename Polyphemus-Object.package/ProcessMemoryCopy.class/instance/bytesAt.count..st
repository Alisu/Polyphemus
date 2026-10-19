reading
bytesAt: anAddress count: aCount

	"All of them, from the piece holding them, or nothing where the process had nothing.
	Refused by name where it had memory this copy left out."

	(self pieceHolding: anAddress) ifNotNil: [ :piece | ^ piece bytesAt: anAddress count: aCount ].
	(listed anySatisfy: [ :each | each holdsAddress: anAddress ]) ifTrue: [
		^ (SpurCannotRead new level: #bytes reason: #notCopiedWhileHeld) signal ].
	^ nil
