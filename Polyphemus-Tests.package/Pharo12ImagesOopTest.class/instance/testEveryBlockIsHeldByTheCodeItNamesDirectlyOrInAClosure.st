tests
testEveryBlockIsHeldByTheCodeItNamesDirectlyOrInAClosure

	"#118: a block is refused where the code it names as its own does not hold it. Measured on
	the images of Pharo 10 to 14: every block is held, as a literal or, from Pharo 11, in a
	closure that is one (2,367 of 36,264 here). None of this image's is refused."

	| blocks inAClosure |
	blocks := (reifiedMemory oopClassNamed: 'CompiledBlock') instancesOop.
	inAClosure := blocks count: [ :each |
		              (each lastLiteral allLiterals anySatisfy: [ :literal | (literal isKindOf: OOPAbstractEntity) and: [ literal address = each address ] ]) not ].
	self assert: inAClosure > 2000.
	blocks do: [ :each | self assert: (reifiedMemory stacks homeMethodOf: each) isCompiledMethodOop ]
