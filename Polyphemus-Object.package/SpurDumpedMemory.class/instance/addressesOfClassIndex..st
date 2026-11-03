reading
addressesOfClassIndex: anIndex

	"Where every object of that class is, by the scanner's walks over old space and new space:
	nothing reified (#129), and not through the simulator (#152)."

	| scanner found |
	scanner := raw scanner.
	found := scanner addressesOfClassIndex: anIndex from: raw heapStart upTo: raw mappingLimit.
	raw youngObjectsDo: [ :oop |
		(scanner classIndexIn: (scanner headerAt: oop)) = anIndex ifTrue: [ found add: oop ] ].
	^ found
