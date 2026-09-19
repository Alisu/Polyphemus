finding the heap
statedHeapStart

	"Where the space says old space starts, as an image file's header does. Believed only if
	nil, false and true are there by their shape and the walk from them runs."

	| start |
	(space respondsTo: #oldBaseAddress) ifFalse: [ ^ nil ].
	start := space oldBaseAddress.
	^ ((self scanner looksLikeNilFalseAndTrueAt: start) and: [
		   self scanner looksLikeAHeapFrom: start upTo: mappingLimit ])
		  ifTrue: [ start ]
		  ifFalse: [ nil ]
