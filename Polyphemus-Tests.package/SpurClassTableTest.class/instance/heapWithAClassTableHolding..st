building a heap
heapWithAClassTableHolding: aSpec

	"A heap of nil, false, true, free lists and a one-page class table whose offset 3 holds
	aSpec, then 600 filler objects: a heap is recognised by a long walk."

	| roots page |
	roots := Array new: 4096 withAll: self baseAddress "nil: an unused page".
	roots at: 1 put: self pageAddress.
	page := Array new: 1024 withAll: self baseAddress.
	page at: 4 put: self entryAddress.
	^ {
		  #( 3075 0 0 ).
		  #( 3077 0 0 ).
		  #( 3079 0 0 ).
		  { 19. 9. 64. (Array new: 64 withAll: 0) }.
		  { 16. 2. 4096. roots }.
		  { 16. 2. 1024. page }.
		  aSpec } , ((1 to: 600) collect: [ :each | #( 17 1 1 ) ])
