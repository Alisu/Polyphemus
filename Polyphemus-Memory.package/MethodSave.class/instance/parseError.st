saving
parseError

	"The first error in the source as Pharo parses it, which knows where it is; nil if it parses."

	| node |
	node := (Smalltalk at: #OCParser ifAbsent: [ Smalltalk at: #RBParser ]) parseFaultyMethod: source.
	^ node allChildren detect: [ :each | each isParseError ] ifNone: [ nil ]
