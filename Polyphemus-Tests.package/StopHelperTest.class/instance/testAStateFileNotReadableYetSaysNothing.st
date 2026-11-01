tests
testAStateFileNotReadableYetSaysNothing

	"#137: polled while the helper makes it, the file may fail to open and exist a moment later,
	which Pharo raises as another error than a missing file."

	| file |
	file := directory / 'state'.
	file writeStreamDo: [ :stream | stream nextPutAll: 'stopped' ].
	LibC system: 'chmod 000 ' , file fullName.
	file isReadable ifTrue: [ ^ self skip: 'run as root: every file reads' ].
	self assert: (StopHelper linesIn: file) isEmpty.
	self assert: (StopHelper linesIn: directory / 'none') isEmpty
