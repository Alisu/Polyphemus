reading the class table
structuralClassTableReasons

	"The class table problems that leave no class resolvable, as opposed to losing a single
	class."

	^ #( #hiddenRootsAreNotWhereTheHeapSaysTheyAre #classTablePageOutsideTheHeap
	     #classTablePageIsTheWrongSize )
