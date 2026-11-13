tests
testAMethodSaysWhetherItIsAPrimitiveAndWhetherItIsQuick

	"#184: isPrimitive and isQuick read the bit below the header's primitive flag; quick is
	Pharo's, a primitive from 256 to 519: yourself, not +."

	| classes plus yourself printString |
	classes := reifiedMemory findClassesNamed: #( 'SmallInteger' 'Object' ) asOrderedCollection.
	plus := (classes at: 'SmallInteger') methodNamed: '+'.
	yourself := (classes at: 'Object') methodNamed: 'yourself'.
	printString := (classes at: 'Object') methodNamed: 'printString'.

	self assert: plus isPrimitive.
	self deny: plus isQuick.
	self assert: yourself isPrimitive.
	self assert: yourself isQuick.
	self deny: printString isPrimitive.
	self deny: printString isQuick