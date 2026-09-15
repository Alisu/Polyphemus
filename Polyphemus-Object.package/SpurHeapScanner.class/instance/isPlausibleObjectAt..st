walking
isPlausibleObjectAt: anAddress

	"Could an object begin here? Cheapest checks first, and none of them look at the slots:
	this decides where objects are, not whether they are intact."

	| header size |
	header := self headerAt: anAddress.
	header ifNil: [ ^ false ].

	(self classIndexIn: header) = 0 ifTrue: [ ^ false ].
	(self classIndexIn: header) > largestClassIndex ifTrue: [ ^ false ].
	(#( 6 7 8 ) includes: (self formatIn: header)) ifTrue: [ ^ false ].

	size := self bytesOfObjectAt: anAddress.
	size ifNil: [ ^ false ].
	^ space hasAddress: anAddress + size - 1
