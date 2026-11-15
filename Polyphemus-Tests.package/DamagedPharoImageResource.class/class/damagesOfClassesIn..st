building
damagesOfClassesIn: aCleanReading

	"In four classes no other damage is on, and one global: Color's superclass a tagged word,
	Bag's zeroed, Rectangle's class pool pointing at Rectangle, the selector of
	Fraction>>numerator and the value of the global Undeclared zeroed (#205)."

	| color rectangle numerator undeclared |
	color := aCleanReading oopClassNamed: 'Color'.
	rectangle := aCleanReading oopClassNamed: 'Rectangle'.
	numerator := (aCleanReading oopClassNamed: 'Fraction') methodNamed: 'numerator' ifAbsent: [ self error: 'no Fraction>>numerator' ].
	undeclared := aCleanReading globalNamed: #Undeclared.
	^ {
		  ((DamagedCandleImage slot: 1 of: color) -> self taggedWord).
		  ((DamagedCandleImage slot: 1 of: (aCleanReading oopClassNamed: 'Bag')) -> 0).
		  ((DamagedCandleImage slot: (self indexOfSlotNamed: 'classPool' in: rectangle) of: rectangle)
		   -> [ :distance | rectangle address - distance ]).
		  ((DamagedCandleImage slot: numerator numberOfLiterals of: numerator) -> 0).
		  ((DamagedCandleImage slot: 2 of: undeclared) -> 0) }
