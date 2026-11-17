checking
whereNot: aLevel

	"Where in the memory that rung fails, for the rungs that know; nil otherwise."

	(aLevel = #specialObjects and: [ (self reasonFor: #specialObjects) = #theStatedArrayDoesNotStartWithNilFalseAndTrue ])
		ifTrue: [ ^ 'the array stated at ' , (heap statedArrayWithoutItsShape printStringRadix: 16) ].
	(aLevel = #freeSpace and: [ (self reasonFor: #freeSpace) = #theHeapHoldsZeroedMemoryNoListKnows ]) ifTrue: [
		^ 'from ' , (heap heapWalk firstZeroedHeader printStringRadix: 16) , ' on' ].
	aLevel = #objects ifFalse: [ ^ nil ].
	(self reasonFor: #objects) = #aMethodsHeaderIsNoInteger ifTrue: [
		^ 'the method at ' , (heap methodWithoutAHeader printStringRadix: 16) , ' in the file' ].
	(self reasonFor: #objects) = #aClassIndexIsPastTheClassTable ifTrue: [
		^ 'the object at ' , (heap objectPastTheClassTable printStringRadix: 16) , ' in the file' ].
	^ nil
