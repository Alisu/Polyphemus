finding a heap
walkTheHeap

	"The walk over every object from the heap's start. Told to expect them, it notes on the way
	the first method whose header is no integer, and the first object whose class index is past
	the class table (#207)."

	| limit |
	limit := classIndexesInTheTable == true ifTrue: [ self scanner classIndexLimitFrom: heapStart ].
	(integerMethodHeaders == true or: [ limit notNil ]) ifFalse: [
		^ self scanner walkFrom: heapStart upTo: mappingLimit atMost: nil liveDo: nil ].
	^ self scanner
		  walkFrom: heapStart
		  upTo: mappingLimit
		  atMost: nil
		  liveDo: [ :address :header |
			  (integerMethodHeaders == true and: [
				   methodWithoutAHeader isNil and: [ self scanner isAMethodWhoseHeaderIsNoIntegerAt: address header: header ] ])
				  ifTrue: [ methodWithoutAHeader := address ].
			  (limit notNil and: [ objectPastTheClassTable isNil and: [ (self scanner classIndexIn: header) >= limit ] ])
				  ifTrue: [ objectPastTheClassTable := address ] ]
