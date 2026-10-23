accessing
parseErrorIn: aSource

	"The first error in that source as Pharo parses it, which knows where it is; nil if it parses."

	| node |
	node := (Smalltalk at: #OCParser ifAbsent: [ Smalltalk at: #RBParser ]) parseFaultyMethod: aSource.
	^ node allChildren detect: [ :each | each isParseError ] ifNone: [ nil ]
