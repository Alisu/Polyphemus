tests
testAnOopIsNotEqualToAnObjectOfThisImage

	"Comparing an oop with an object of this image answers false and never raises."

	| oop |
	oop := reifiedMemory reifiedNilObject.

	self deny: oop = Halt.
	self deny: oop = 'a string of this image'.
	self deny: oop = nil.
	self deny: oop = 3.14.
	self assert: oop = oop.
	self assert: oop = oop address
