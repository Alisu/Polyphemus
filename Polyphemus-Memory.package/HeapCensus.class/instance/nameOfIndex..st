naming
nameOfIndex: aClassIndex

	"The VM's own indexes (below 32) are puns, not classes."

	aClassIndex < 32 ifTrue: [ ^ '(VM ' , aClassIndex printString , ')' ].
	^ names at: aClassIndex ifAbsentPut: [ self nameOfClass: (objectMemory classAtIndex: aClassIndex) ]
