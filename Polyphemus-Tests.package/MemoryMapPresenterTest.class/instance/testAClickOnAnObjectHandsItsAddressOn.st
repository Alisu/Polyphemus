tests
testAClickOnAnObjectHandsItsAddressOn

	"The top left pixel is nil's."

	presenter chooseAt: presenter picture mapOrigin.

	self assert: chosen equals: memory nilObject
