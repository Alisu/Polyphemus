building a heap
heapWithAPageOfTheWrongSize

	"A class table whose one page is not 1024 entries. A class index cannot be resolved
	against it at all."

	| roots |
	roots := Array new: 4096 withAll: self baseAddress.
	roots at: 1 put: self pageAddress.
	^ {
		  #( 3075 0 0 ).
		  #( 3077 0 0 ).
		  #( 3079 0 0 ).
		  { 19. 9. 64. (Array new: 64 withAll: 0) }.
		  { 16. 2. 4096. roots }.
		  { 16. 2. 64. (Array new: 64 withAll: self baseAddress) } }
			, ((1 to: 600) collect: [ :each | #( 17 1 1 ) ])
