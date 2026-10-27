private
rebaseOn: aMemory keeping: anObjectsArray

	"Read aMemory from now on, with only those wrappers made already."

	memory := aMemory.
	objectsArray := anObjectsArray.
	lastKnownObject := nil.
	vmLayout := nil.
	processes := nil.
	stacks := nil.
	compilations := nil.
	self forgetWhatWasRead.
	self createCompressedVersion
