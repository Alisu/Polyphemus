reading
refresh

	"Read the process again into the same buffers, stopped: a reading built on this memory
	keeps its classes (LazyReifiedMemory>>forgetAllButClasses). Refused when the heap grew,
	or a full GC compacted it and moved what the reading was built around."

	| now pages |
	now := (self class on: raw space) raw.
	(now mappingStart = raw mappingStart and: [ now mappingLimit = raw mappingLimit ]) ifFalse: [
		^ self error: 'the image''s memory changed its shape; read it again' ].
	pages := self classTablePages.
	(raw copyInto: raw bytes) = raw mappingLimit ifFalse: [
		^ self error: 'the image''s memory changed its shape; read it again' ].
	(self classTablePages = pages and: [
		 raw scanner looksLikeTheSpecialObjectsArrayAt: raw specialObjectsOop from: raw heapStart ])
		ifFalse: [ ^ self error: 'the image''s heap was compacted; read it again' ].
	(memory memoryManager regionAtAddress: raw mappingStart) memory
		replaceFrom: 1
		to: raw bytes size
		with: raw bytes
		startingAt: 1
