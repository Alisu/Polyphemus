testing
isStackFrame

	"Only a frame on a stack page is. A context is an object in the heap, which is what
	every activation becomes once it is divorced from its frame."

	^ false
