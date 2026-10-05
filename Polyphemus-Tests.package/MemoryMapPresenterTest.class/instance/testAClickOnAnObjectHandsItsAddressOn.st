tests
testAClickOnAnObjectHandsItsAddressOn

	"Old space's top left pixel is nil's."

	presenter chooseAt: (presenter picture originOf: 2).

	self assert: chosen equals: memory nilObject
