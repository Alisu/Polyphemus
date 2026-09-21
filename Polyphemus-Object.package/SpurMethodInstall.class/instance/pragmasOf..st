literals
pragmasOf: aReifiedMethod

	"How the image's own compilation of that method prints its pragmas, to compare against
	what is being installed."

	| source compiled |
	source := aReifiedMethod getSourceFromFile.
	compiled := reading
		            compileHostSource: source
		            for: aReifiedMethod oopMethodClass.
	compiled ifNil: [ ^ 'unknown' ].
	^ compiled first pragmas asArray printString
