updating
showSourceOf: aContext

	| source |
	aContext ifNil: [ ^ sourceText text: '' ].
	source := reifiedMemory sourceOfContext: aContext.
	sourceText text: (source ifNil: [
			 '"no source in this image, showing bytecodes"

' , (reifiedMemory disassemblyOfContext: aContext) ])
