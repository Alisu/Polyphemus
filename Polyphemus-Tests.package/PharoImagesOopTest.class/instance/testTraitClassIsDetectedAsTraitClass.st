tests
testTraitClassIsDetectedAsTraitClass
	| traitOop |
	traitOop := self reifyOop: (memory fetchClassOf: (reifiedMemory reifiedClassTable classAtIndex: (reifiedMemory preFindClassNamed: self traitName))).
	self assert: traitOop isClassTraitOop
