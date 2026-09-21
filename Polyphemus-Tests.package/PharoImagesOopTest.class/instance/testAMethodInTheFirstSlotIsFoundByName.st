tests
testAMethodInTheFirstSlotIsFoundByName

	"#28: what the count hid, a lookup by name could not answer either."

	| integer methods first |
	integer := reifiedMemory oopClassNamed: 'Integer'.
	methods := (integer reifiedSlotAt: 2) reifiedSlotAt: 2.
	self deny: (methods reifiedSlotAt: 1) isNilOop.
	first := ((integer reifiedSlotAt: 2) reifiedSlotAt: 3) asString.

	self assert: (integer methodNamed: first) isCompiledMethodOop
