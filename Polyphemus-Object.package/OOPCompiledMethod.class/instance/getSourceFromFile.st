debugger
getSourceFromFile

	"Read at the file and position the trailer names, whatever this host's pointers encode."

	| sourceFiles trailer |
	sourceFiles := memory retrieveSourceFiles.
	trailer := self trailer.
	(trailer sourceFileIndex between: 1 and: 2) ifFalse: [ ^ '' ].
	^ (sourceFiles sourceCodeAt: (sourceFiles
			    sourcePointerFromFileIndex: trailer sourceFileIndex
			    andPosition: trailer sourceFilePosition)) ifNil: [ '' ]
