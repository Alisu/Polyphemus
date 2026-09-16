reading the free lists
numberOfFreeLists

	"Spur keeps 64 of them: one per size from one allocation unit up, and the first is not a
	list at all but the root of a tree of everything too large to have its own. Read out of
	`Spur64BitMemoryManager>>numFreeLists` rather than remembered."

	^ 64
