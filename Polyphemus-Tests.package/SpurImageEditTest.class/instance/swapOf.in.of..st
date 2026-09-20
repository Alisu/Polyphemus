helpers
swapOf: aReifiedMethod in: aReifiedClass of: aReading

	"That method as it is and with its first comparison widened, when both compile here, the
	file holds what the first one says, and the two are the same length and literals."

	| source old new |
	source := [ aReifiedMethod getSourceFromFile ] on: Error do: [ :e | nil ].
	(source isNil or: [ (source includesSubstring: ' < ') not ]) ifTrue: [ ^ nil ].
	old := (aReading compileHostSource: source for: aReifiedClass) ifNil: [ ^ nil ].
	new := (aReading
		        compileHostSource: (source copyReplaceAll: ' < ' with: ' <= ')
		        for: aReifiedClass) ifNil: [ ^ nil ].
	(aReading host: old first matchesOop: aReifiedMethod) ifFalse: [ ^ nil ].
	(old first literals = new first literals and: [
		 old first endPC - old first initialPC = (new first endPC - new first initialPC) ])
		ifFalse: [ ^ nil ].
	^ { aReifiedMethod. old first. new first }
