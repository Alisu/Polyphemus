accessing
imageName

	"Where this memory came from. Polyphemus takes a nil image name for an empty test
	fixture, so a dump must answer one."

	^ (raw space respondsTo: #file)
		  ifTrue: [ raw space file fullName ]
		  ifFalse: [ 'dumped memory' ]
