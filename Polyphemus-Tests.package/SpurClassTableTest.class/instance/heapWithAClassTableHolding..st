building a heap
heapWithAClassTableHolding: aSpec

	"A heap with the five objects Spur puts first, a class table of one page, one entry in
	that page pointing at whatever the caller wants to put there -- and then six hundred
	ordinary objects, because a heap is recognised by walking a long way through it and
	seven objects is not a long way."

	| roots page |
	roots := Array new: 4096 withAll: self baseAddress "nil: an unused page".
	roots at: 1 put: self pageAddress.
	page := Array new: 1024 withAll: self baseAddress.
	page at: 1 put: self entryAddress.
	^ {
		  #( 3075 0 0 ).
		  #( 3077 0 0 ).
		  #( 3079 0 0 ).
		  { 19. 9. 64. (Array new: 64 withAll: 0) }.
		  { 16. 2. 4096. roots }.
		  { 16. 2. 1024. page }.
		  aSpec } , ((1 to: 600) collect: [ :each | #( 17 1 1 ) ])
