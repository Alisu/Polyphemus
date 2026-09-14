tests
testAnOopIsNotEqualToAnObjectOfThisImage

	"Reified objects travel into this image's own tooling, which compares whatever it is
	handed with whatever it likes: the compiler asks whether a message node's receiver is
	Halt, an inspector compares against nil, a collection looks for a string. Comparing has
	to answer false for all of it and raise for none of it.

	It used to send #address to the argument. The doesNotUnderstand surfaced two layers
	away as semantic analysis failing, which read on screen as a method having no
	temporaries at all."

	| oop |
	oop := reifiedMemory reifiedNilObject.

	self deny: oop = Halt.
	self deny: oop = 'a string of this image'.
	self deny: oop = nil.
	self deny: oop = 3.14.
	self assert: oop = oop.
	self assert: oop = oop address
