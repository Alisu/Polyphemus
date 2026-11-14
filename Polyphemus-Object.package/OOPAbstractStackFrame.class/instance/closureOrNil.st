context protocol
closureOrNil

	"The closure a block activation is running, read where its layout keeps it; nil for a
	method activation. Refused by name where its flags or that word do not read."

	^ self layout closureOf: framePointer
