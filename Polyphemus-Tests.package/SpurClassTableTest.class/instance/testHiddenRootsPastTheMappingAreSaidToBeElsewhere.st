tests
testHiddenRootsPastTheMappingAreSaidToBeElsewhere

	"#182: a free lists object claiming more slots than the mapping holds puts the hidden roots past
	its end; the check sent formatIn: to the nil read there. It names the problem instead."

	<readsAnUnsoundHeap>
	| space problems |
	space := self spaceFor: {
			         #( 3075 0 0 ).
			         #( 3077 0 0 ).
			         #( 3079 0 0 ).
			         { 19. 9. 254. (Array new: 8 withAll: 0) } }.

	problems := (SpurHeapScanner on: space)
		            classTableProblemsFrom: self baseAddress
		            upTo: self baseAddress + space size.

	self
		assert: (problems collect: [ :each | each key ]) asArray
		equals: #( #hiddenRootsAreNotWhereTheHeapSaysTheyAre )