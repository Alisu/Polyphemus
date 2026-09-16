reading the class table
structuralClassTableReasons

	"The problems that stop the table being usable at all, as against the ones that cost you
	a single class.

	A page missing, in the wrong place or the wrong size means no class index can be
	resolved -- the arithmetic that turns an index into an entry has nowhere to land. One
	entry holding something that is not a class costs exactly the classes at that index:
	every other object in the heap still gets its name."

	^ #( #hiddenRootsAreNotWhereTheHeapSaysTheyAre #classTablePageOutsideTheHeap
	     #classTablePageIsTheWrongSize )
