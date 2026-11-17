reading
is: anOop named: aClassName

	^ (objectMemory isNonImmediate: anOop) and: [
		  (census nameOfIndex: (objectMemory classIndexOf: anOop)) = aClassName ]
