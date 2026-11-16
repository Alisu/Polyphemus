finding a heap
statedArrayWithoutItsShape

	"The stated special objects array when it is in this mapping and does not start with nil,
	false and true; nil otherwise. No other array is then taken for it (#207)."

	| stated |
	self findHeap.
	stated := self statedSpecialObjectsWord.
	^ ((stated isInteger and: [ stated between: mappingStart and: mappingLimit - 1 ]) and: [
		   (self scanner looksLikeTheSpecialObjectsArrayAt: stated from: heapStart) not ])
		  ifTrue: [ stated ]
		  ifFalse: [ nil ]
