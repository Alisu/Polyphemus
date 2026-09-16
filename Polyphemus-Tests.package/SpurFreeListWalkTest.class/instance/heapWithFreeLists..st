building a heap
heapWithFreeLists: aCollectionOfAssociations

	"nil, false and true, then a free lists object of the shape Spur gives it: 64 word
	slots, the first the root of the tree and the rest one per size. Each association says
	which list holds which chunk, by the VM's own index -- which is one less than the slot,
	since the VM counts from zero. Whatever follows is the caller's business."

	| slots |
	slots := Array new: 64 withAll: 0.
	aCollectionOfAssociations do: [ :each |
		slots at: each key + 1 put: each value ].
	^ {
		  #( 3075 0 0 ).
		  #( 3077 0 0 ).
		  #( 3079 0 0 ).
		  { 19. 9. 64. slots } }
