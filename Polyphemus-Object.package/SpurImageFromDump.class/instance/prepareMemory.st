writing
prepareMemory

	"Make the dump's memory one VMMaker will collect: its own initialization, as after loading
	an image, keeping the dump's free lists -- its free chunks lie among live objects, not after
	them (#46) -- stack pages to walk, then its new space and remembered set put back."

	dumped memory segmentManager setCanSwizzle: true.
	dumped memory initializeObjectMemory: 0.
	dumped interpreter initStackPages.
	self voidTheInterpretersRegisters.
	self restoreNewSpace.
	self restoreRememberedSet
