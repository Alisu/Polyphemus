accessing
stringAt: aName

	"The C string the VM kept in the character array aName, up to its first NUL."

	^ self textIn: ((memory bytesAt: (self addressOf: aName) count: 4096) ifNil: [
			   ^ self refuse: #itsVariableWasNotDumped ])
