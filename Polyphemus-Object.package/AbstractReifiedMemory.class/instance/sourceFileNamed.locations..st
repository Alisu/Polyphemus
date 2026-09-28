sources
sourceFileNamed: aPath locations: someLocations

	"A source file of this host's kind: SourceFile on:potentialLocations: up to Pharo 13,
	lookupFileNamed:potentialLocations: from Pharo 14."

	^ (SourceFile respondsTo: #lookupFileNamed:potentialLocations:)
		  ifTrue: [ SourceFile lookupFileNamed: aPath potentialLocations: someLocations ]
		  ifFalse: [ SourceFile on: aPath potentialLocations: someLocations ]
