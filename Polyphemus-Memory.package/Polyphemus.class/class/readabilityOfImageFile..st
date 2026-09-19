reading
readabilityOfImageFile: aPath

	"How far up the ladder an image file can be read, climbed on its own bytes (bytes, heap,
	objects, free space, classes, special objects), before any simulator is handed it."

	| file |
	file := SpurImageFile on: aPath asFileReference.
	^ [ (SpurRawHeap on: file) readability refusals; yourself ] ensure: [ file close ]
