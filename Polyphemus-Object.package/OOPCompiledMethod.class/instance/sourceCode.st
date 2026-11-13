debugger
sourceCode

	"From its trailer, else the source a DoIt keeps in its properties, else the sources or
	changes file. Nil when it carries none, or the file gives none."

	| trailer |
	trailer := self trailer.
	trailer sourceCode ifNotNil: [ :code | ^ code ].
	self doItSource ifNotNil: [ :code | ^ code ].
	trailer hasSourcePointer ifFalse: [ ^ nil ].

	^ self getSourceFromFile ifEmpty: [ nil ]
