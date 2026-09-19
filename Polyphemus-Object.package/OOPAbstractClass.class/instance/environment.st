as a compilation scope
environment

	"Where this image keeps its own classes, for the compiling machinery. Names in analysed
	source resolve through #lookupVar:declare: instead."

	^ self class environment
