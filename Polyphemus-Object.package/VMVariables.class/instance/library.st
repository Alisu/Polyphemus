accessing
library

	"The file the memory says it mapped, unless another was given."

	^ library ifNil: [
		  self mapping path asFileReference exists ifFalse: [
			  ^ self refuse: #itsVMLibraryIsNotOnThisMachine ].
		  library := ElfSharedObject on: self mapping path ]
