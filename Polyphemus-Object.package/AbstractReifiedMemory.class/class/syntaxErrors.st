compiling
syntaxErrors

	"What a source that does not compile signals: an Error, and up to Pharo 12 a
	SyntaxErrorNotification, which is no Error (#29). Pharo 13 has no such class."

	^ Error , (Smalltalk globals at: #SyntaxErrorNotification ifAbsent: [ Error ])
