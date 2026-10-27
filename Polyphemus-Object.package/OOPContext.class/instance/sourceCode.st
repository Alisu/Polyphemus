context protocol
sourceCode
	^ (memory sourceOfContext: self) ifNil: [ memory stacks disassemblyOfContext: self ]
