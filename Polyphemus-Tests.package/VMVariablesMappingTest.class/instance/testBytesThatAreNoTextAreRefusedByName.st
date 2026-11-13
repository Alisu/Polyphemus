tests
testBytesThatAreNoTextAreRefusedByName

	"#118: a character array holding anything but text raised the decoder's own error, which only
	a catch-all took for the VM not saying."

	self assert: (VMVariables new textIn: #[ 97 98 0 99 ]) equals: 'ab'.
	self
		should: [ VMVariables new textIn: #[ 255 254 0 ] ]
		raise: SpurCannotRead
		withExceptionDo: [ :refusal | self assert: refusal level equals: #vm ]
