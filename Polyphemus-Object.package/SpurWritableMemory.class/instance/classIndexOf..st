objects
classIndexOf: anOop

	^ (self wordAt: anOop) bitAnd: 16r3FFFFF
