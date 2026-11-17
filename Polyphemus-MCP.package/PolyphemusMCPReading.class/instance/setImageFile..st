initialization
setImageFile: aPath

	kind := 'an image file'.
	path := aPath.
	memory := (Polyphemus checkedInterpreterOnImageFile: aPath) objectMemory.
	census := HeapCensus of: memory
