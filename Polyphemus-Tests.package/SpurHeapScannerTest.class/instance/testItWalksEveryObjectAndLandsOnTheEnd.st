tests
testItWalksEveryObjectAndLandsOnTheEnd

	"A heap describes itself: each header says where the next object begins. Walking one has to
	find every object and finish exactly at the end -- landing anywhere else means a step was
	the wrong size, and every step after it was reading rubbish."

	| space walk |
	space := self spaceFor: self aFewObjects.
	walk := (SpurHeapScanner on: space)
		        walkFrom: self baseAddress
		        upTo: self baseAddress + space size.

	self assert: walk objectCount equals: self aFewObjects size.
	self assert: walk stoppedAt equals: self baseAddress + space size.
	self assert: walk reachedTheLimit
