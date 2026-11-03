accessing
anInstanceOf: aClassName suchThat: aBlock

	^ (self memory instancesOfClassTag: (self memory oopClassNamed: aClassName) oopHash)
		  detect: aBlock
		  ifNone: [ self skip: 'no such ' , aClassName , ' in this image' ]
