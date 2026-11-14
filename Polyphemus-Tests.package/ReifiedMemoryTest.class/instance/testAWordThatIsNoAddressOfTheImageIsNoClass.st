tests
testAWordThatIsNoAddressOfTheImageIsNoClass

	"A word no space of the image holds does not read as a class, and asking is no error."

	self deny: (reifiedMemory classIsReadableAt: 16r7FFF00000000).
	self assert: (reifiedMemory classIsReadableAt: (reifiedMemory oopClassNamed: 'PCSmallInteger') address)
