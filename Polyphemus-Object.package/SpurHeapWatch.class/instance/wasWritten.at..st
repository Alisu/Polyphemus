checking
wasWritten: aRawHeap at: someAddresses

	"Whether one of them lies in its heap, old space or new; true when that cannot be told."

	^ [ someAddresses anySatisfy: [ :each | (aRawHeap holdsHeapAddress: each) or: [ aRawHeap isInNewSpace: each ] ] ]
		  on: Error
		  do: [ :error | true ]
