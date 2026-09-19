accessing
at: aName

	"The word the VM kept in the variable aName."

	^ (memory unsignedAt: (self addressOf: aName) size: 8) ifNil: [
		  self refuse: #itsVariableWasNotDumped ]
