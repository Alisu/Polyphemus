helpers
library

	"The VM library this Pharo runs on, as its own mappings name it."

	^ MachOSharedObject on: (self vmLibraryOf: MacProcessMemory onSelf) path
