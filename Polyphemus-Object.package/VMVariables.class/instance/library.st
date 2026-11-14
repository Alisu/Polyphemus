accessing
library

	"The file the memory says it mapped, or a copy of it named for this machine, unless another
	was given."

	^ library ifNil: [ library := self class parsedLibraryAt: self libraryPath ]
