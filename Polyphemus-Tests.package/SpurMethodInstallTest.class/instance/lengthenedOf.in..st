helpers
lengthenedOf: aReifiedMethod in: aReifiedClass

	"That method, and the same with a statement that does nothing in front of its body. Nil
	unless both compile, the file holds what the first says, the literals match and the second
	is longer -- a pragma or temporaries refuse the statement, so those fail to compile."

	| source old new |
	source := [ aReifiedMethod getSourceFromFile ] on: Error do: [ :e | nil ].
	source ifNil: [ ^ nil ].
	old := (reading compileHostSource: source for: aReifiedClass) ifNil: [ ^ nil ].
	new := (reading
		        compileHostSource: (self statementDoingNothingPutInto: source)
		        for: aReifiedClass) ifNil: [ ^ nil ].
	(reading host: old first matchesOop: aReifiedMethod) ifFalse: [ ^ nil ].
	(old first literals = new first literals and: [
		 new first endPC - new first initialPC > (old first endPC - old first initialPC) ])
		ifFalse: [ ^ nil ].
	^ { aReifiedMethod. old first. new first }
