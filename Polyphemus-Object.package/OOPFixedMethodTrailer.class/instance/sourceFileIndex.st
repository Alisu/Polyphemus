accessing
sourceFileIndex

	"Pharo 12 keeps it in the lowest bit: 1 the .sources, 2 the .changes."

	^ (self sourcePointer bitAnd: 1) + 1
