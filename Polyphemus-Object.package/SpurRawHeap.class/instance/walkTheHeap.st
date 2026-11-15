finding a heap
walkTheHeap

	"The walk over every object from the heap's start. Told to expect integers, it notes on the
	way the first method whose header is none (#207)."

	^ self scanner
		  walkFrom: heapStart
		  upTo: mappingLimit
		  atMost: nil
		  liveDo: (integerMethodHeaders == true ifTrue: [
				   [ :address :header |
				   (methodWithoutAHeader isNil and: [
					    self scanner isAMethodWhoseHeaderIsNoIntegerAt: address header: header ]) ifTrue: [
					   methodWithoutAHeader := address ] ] ])
