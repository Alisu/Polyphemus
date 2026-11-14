tests
testAClassWhoseLayoutIsATaggedWordHasNoNamesAndItsInstancesStillRead

	| point instance |
	point := reifiedMemory oopClassNamed: 'Point'.
	instance := point instancesOop first.

	self assert: (point reifiedSlotAt: 4) isImmediateOop.
	self assert: point oopSlotNames asArray equals: #(  ).
	self assert: instance oopNumberOfSlots equals: 2.
	self assert: instance allReifiedSlots size equals: 2.
	self assert: (instance printString includesSubstring: 'Point').
	self assert: (reifiedMemory oopClassNamed: 'Delay') oopSlotNames size equals: 5
