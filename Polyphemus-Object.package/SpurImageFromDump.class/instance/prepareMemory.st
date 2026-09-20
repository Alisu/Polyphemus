writing
prepareMemory

	"Make the dump's memory one VMMaker will collect: its own initialization, as after loading
	an image, stack pages of its own to walk (empty: the dump's frames are contexts by then),
	then the dump's new space and remembered set put back -- an image has neither."

	dumped memory segmentManager setCanSwizzle: true.
	self emptyTheFreeListsTheDumpLeft.
	dumped memory initializeObjectMemory: 0.
	dumped interpreter initStackPages.
	self voidTheInterpretersRegisters.
	self restoreNewSpace.
	self restoreRememberedSet
