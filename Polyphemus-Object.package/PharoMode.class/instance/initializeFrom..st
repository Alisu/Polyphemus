initialization
initializeFrom: aReifiedMemory

	"Where a class keeps its name and a metaclass its class, found on Array in the image read:
	its name slot holds #Array, its metaclass's thisClass holds it. Guessed from a class's size,
	it broke when Pharo 12 added class variables and kept the name where it was."

	| sim array metaclass |
	sim := aReifiedMemory simulator.
	array := sim classAtIndex: sim arrayClassIndexPun.
	metaclass := sim fetchClassOf: array.
	classesNamesIndex := (1 to: (sim numSlotsOf: array)) detect: [ :each |
		                     self is: (sim fetchPointer: each - 1 ofObject: array) named: 'Array' in: sim ].
	metaclassNameIndex := (1 to: (sim numSlotsOf: metaclass)) detect: [ :each |
		                      (sim fetchPointer: each - 1 ofObject: metaclass) = array ]
