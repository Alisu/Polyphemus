helpers
statementDoingNothingPutInto: aSource

	"A statement that changes nothing and names no literal of its own, where the source's
	statements begin: a few bytecodes longer, the literal frame as it was."

	^ self statementPutInto: aSource source: '1 + 1. '
