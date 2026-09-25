accessing
objectOfClassIndex: anIndex hash: aHash

	"Where the object of that class with that identity hash is, found by walking old space and
	new space without reifying anything; nil when there is none."

	| memory |
	memory := self memory.
	memory allOldSpaceObjectsDo: [ :oop |
		((memory classIndexOf: oop) = anIndex and: [ (memory rawHashBitsOf: oop) = aHash ])
			ifTrue: [ ^ oop ] ].
	raw youngObjectsDo: [ :oop |
		((memory classIndexOf: oop) = anIndex and: [ (memory rawHashBitsOf: oop) = aHash ])
			ifTrue: [ ^ oop ] ].
	^ nil
