context protocol
closureOrNil

	"The closure a block activation is running, read where its layout keeps it; nil for a
	method activation, and where the layout cannot read it."

	^ [ self layout closureOf: framePointer ] on: Error do: [ :e | nil ]
