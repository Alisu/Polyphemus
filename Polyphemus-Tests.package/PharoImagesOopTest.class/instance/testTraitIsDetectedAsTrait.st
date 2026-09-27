tests
testTraitIsDetectedAsTrait
	| traitOop |
	traitOop := self reifyOop: (reifiedMemory reifiedClassTable classAtIndex: (reifiedMemory preFindClassNamed: self traitName)).
	self assert: traitOop isTraitOop
