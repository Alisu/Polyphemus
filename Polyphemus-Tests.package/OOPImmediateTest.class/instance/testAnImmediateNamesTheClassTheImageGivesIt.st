tests
testAnImmediateNamesTheClassTheImageGivesIt

	"A stack line names its receiver's class, and a receiver of 3 read as an unreadable object
	(#42): an immediate's class is found by its tag, as the machine does."

	| reading |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToPharo10.
	self assert: (reading reifyOop: 3 << 3 + 1) oopClassName equals: 'SmallInteger'.
	self assert: (reading reifyOop: ($a asInteger << 3) + 2) oopClassName equals: 'Character'
