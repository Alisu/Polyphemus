writing
prepareMemory

	"Make the dump's memory one VMMaker will collect: its own initialization, as after loading
	an image (new space emptied for it, as loading wants), keeping the dump's free lists (#46),
	stack pages to walk, then its new space and remembered set put back."

	dumped memory segmentManager setCanSwizzle: true.
	dumped emptyNewSpaceIn: dumped memory.
	dumped memory initializeObjectMemory: 0.
	dumped interpreter initStackPages.
	self voidTheInterpretersRegisters.
	self restoreNewSpace.
	self restoreRememberedSet
