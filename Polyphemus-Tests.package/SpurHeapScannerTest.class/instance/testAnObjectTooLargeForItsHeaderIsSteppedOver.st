tests
testAnObjectTooLargeForItsHeaderIsSteppedOver

	"A slot count of 255 means the real one is in the word before, and that word's own count
	byte is saturated too. So a walk arriving at it must recognise it as an overflow word and
	start the object eight bytes later -- treating it as a header instead puts every later step
	out of place."

	| space scanner big |
	space := self spaceFor: self aFewObjects.
	scanner := SpurHeapScanner on: space.

	"the seventh object asks for 300 slots"
	big := self baseAddress.
	1 to: 6 do: [ :each | big := scanner objectAfter: big ].

	self assert: (scanner slotsAt: big) equals: 300.
	self assert: (scanner bytesOfObjectAt: big) equals: 8 + (300 * 8).
	self assert: (scanner objectAfter: big) equals: big + 8 + (300 * 8)
