accessing
library

	"The file the memory says it mapped, unless another was given."

	^ library ifNil: [
		  self mapping path asFileReference exists ifFalse: [
			  ^ self refuse: #itsVMLibraryIsNotOnThisMachine ].
		  library := ({
			              ('.dylib' -> MachOSharedObject).
			              ('.dll' -> PeSharedObject) }
			              detect: [ :each | self mapping path asLowercase endsWith: each key ]
			              ifNone: [ nil -> ElfSharedObject ]) value on: self mapping path ]
