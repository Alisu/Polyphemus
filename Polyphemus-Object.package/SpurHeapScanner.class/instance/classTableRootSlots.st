reading the class table
classTableRootSlots

	"How many pages the class table can have. `SpurMemoryManager` calls it
	ClassTableRootSlots; the hidden roots object is this many slots plus a few more for the
	collector's own stacks."

	^ 4096
