helpers
swapOf: aReifiedMethod in: aReifiedClass of: aReading

	"That method as it is and with its first ' < ' widened, when both compile here, the file
	holds what the first one says, and the two differ in code only (a ' < ' in a comment
	changes nothing: Pharo 12's image has one first)."

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
	(self bytecodesOf: old first) = (self bytecodesOf: new first) ifTrue: [ ^ nil ].
	^ { aReifiedMethod. old first. new first }
