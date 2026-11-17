reading
readabilityOf: aPath

	"How far up the ladder an image file can be read, climbed on its own bytes (bytes, heap,
	objects, free space, classes, special objects), before any simulator is handed it."

	| file |
	file := self on: aPath asFileReference.
	^ [ (SpurRawHeap on: file) expectingIntegerMethodHeaders expectingClassIndexesInTheClassTable readability refusals; yourself ] ensure: [ file close ]