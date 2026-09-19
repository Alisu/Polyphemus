building a heap
heapWithFreeLists: aCollectionOfAssociations

	"nil, false, true, then a free lists object of Spur's shape: 64 slots, the tree root first.
	Each association maps the VM's list index (slot minus one) to its chunk."

	| slots |
	slots := Array new: 64 withAll: 0.
	aCollectionOfAssociations do: [ :each |
		slots at: each key + 1 put: each value ].
	^ {
		  #( 3075 0 0 ).
		  #( 3077 0 0 ).
		  #( 3079 0 0 ).
		  { 19. 9. 64. slots } }
