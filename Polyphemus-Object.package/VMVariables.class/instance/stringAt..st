accessing
stringAt: aName

	"The C string the VM kept in the character array aName, up to its first NUL."

	| bytes |
	bytes := (memory bytesAt: (self addressOf: aName) count: 4096) ifNil: [
		         ^ self refuse: #itsVariableWasNotDumped ].
	^ (bytes asByteArray copyUpTo: 0) utf8Decoded
