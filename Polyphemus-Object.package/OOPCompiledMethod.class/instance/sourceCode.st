debugger
sourceCode

	"From its trailer, else the source a DoIt keeps in its properties, else the sources or
	changes file."

	| trailer |
	trailer := self trailer.
	trailer sourceCode ifNotNil: [ :code | ^ code ].
	self doItSource ifNotNil: [ :code | ^ code ].
	trailer hasSourcePointer ifFalse: [ ^ self codeForNoSource ].

	^ self getSourceFromFile ifEmpty: [ self codeForNoSource ]
