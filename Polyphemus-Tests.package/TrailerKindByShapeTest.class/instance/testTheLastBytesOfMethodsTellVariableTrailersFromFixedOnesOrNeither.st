tests
testTheLastBytesOfMethodsTellVariableTrailersFromFixedOnesOrNeither

	"The rule alone, on last bytes as the six images measured have them: all of a known kind is
	variable, about one in five is fixed, and in between it does not say."

	| aKnownKind anUnknownKind |
	aKnownKind := 255.
	anUnknownKind := 200.
	self assert: (OOPVariableMethodTrailer kinds at: aKnownKind >> 2 + 1) ~~ #Undefined.
	self assert: (OOPVariableMethodTrailer kinds at: anUnknownKind >> 2 + 1) identicalTo: #Undefined.

	self
		assert: (OOPVariableMethodTrailer trailerClassOfMethodsEnding: (Array new: 200 withAll: aKnownKind))
		equals: OOPVariableMethodTrailer.
	self
		assert: (OOPVariableMethodTrailer trailerClassOfMethodsEnding: (Array new: 44 withAll: aKnownKind) , (Array new: 156 withAll: anUnknownKind))
		equals: OOPFixedMethodTrailer.
	self
		assert: (OOPVariableMethodTrailer trailerClassOfMethodsEnding: (Array new: 140 withAll: aKnownKind) , (Array new: 60 withAll: anUnknownKind))
		isNil.
	self assert: (OOPVariableMethodTrailer trailerClassOfMethodsEnding: (Array new: 10 withAll: aKnownKind)) isNil
