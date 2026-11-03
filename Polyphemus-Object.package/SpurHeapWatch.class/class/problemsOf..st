checking
problemsOf: aRawHeap

	"What the readability ladder refuses in it, one line each."

	^ [ aRawHeap readability refusals associations collect: [ :each | each key printString , ': ' , each value asString ] ]
		  on: Error
		  do: [ :e | { 'the check failed: ' , e messageText asString } ]
