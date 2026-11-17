naming
nameOfClass: aClassOop

	"Its first slot holding a symbol; a metaclass has none, and is named after its sole
	instance, the class whose instances' class index is the metaclass's identity hash."

	| slots |
	(aClassOop isNil or: [ objectMemory isImmediate: aClassOop ]) ifTrue: [ ^ '?' ].
	slots := objectMemory numSlotsOf: aClassOop.
	0 to: slots - 1 do: [ :i |
		| each |
		each := objectMemory fetchPointer: i ofObject: aClassOop.
		((objectMemory isNonImmediate: each) and: [
			 (objectMemory classIndexOf: each) = self symbolClassIndex ]) ifTrue: [
			^ self stringOf: each ] ].
	0 to: slots - 1 do: [ :i |
		| each |
		each := objectMemory fetchPointer: i ofObject: aClassOop.
		((objectMemory isNonImmediate: each) and: [
			 (objectMemory classIndexOf: each) = (objectMemory rawHashBitsOf: aClassOop) ]) ifTrue: [
			^ (self nameOfClass: each) , ' class' ] ].
	^ '?'
