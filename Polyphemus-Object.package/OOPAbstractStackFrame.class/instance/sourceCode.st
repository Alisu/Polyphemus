context protocol
sourceCode

	^ (memory sourceOfContext: self) ifNil: [ memory disassemblyOfContext: self ]
