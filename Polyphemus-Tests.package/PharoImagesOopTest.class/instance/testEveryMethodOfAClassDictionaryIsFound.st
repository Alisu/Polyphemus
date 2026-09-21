tests
testEveryMethodOfAClassDictionaryIsFound

	"#28: the methods are in the dictionary's array from its first slot, so counting from the
	third hid whichever hashed there. Integer keeps two of its 172 in those two slots."

	| integer methods |
	integer := reifiedMemory oopClassNamed: 'Integer'.
	methods := (integer reifiedSlotAt: 2) reifiedSlotAt: 2.

	self
		assert: integer reifiedMethods size
		equals: ((1 to: methods oopNumberOfSlots) count: [ :each |
				 (methods reifiedSlotAt: each) isNilOop not ])
