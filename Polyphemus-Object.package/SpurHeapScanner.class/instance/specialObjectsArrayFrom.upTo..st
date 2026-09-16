finding a heap
specialObjectsArrayFrom: anAddress upTo: aLimit

	"The special objects array of the heap that begins at anAddress, or nil.

	The heap does not hold this one anywhere findable: the VM keeps it in a variable of its
	own, and a snapshot writes it into the image header, which a core dump has no copy of.
	So it is recognised by contents -- its first three slots are nil, false and true, and
	those three addresses are known before the search starts.

	The walk finds it on the way past, so asking for it costs a walk and no more. Where one
	has already been done, take it from `SpurHeapWalk>>specialObjectsArray` instead of
	paying for another."

	^ (self walkFrom: anAddress upTo: aLimit) specialObjectsArray
