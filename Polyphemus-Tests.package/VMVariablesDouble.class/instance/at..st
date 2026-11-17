accessing
at: aName

	"As VMVariables: the word kept in that variable, refused when the memory does not hold it."

	^ (memory unsignedAt: (self addressOf: aName) size: 8) ifNil: [
		  (SpurCannotRead new level: #vm reason: #itsVariableWasNotDumped) signal ]
