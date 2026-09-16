accessing
globalLevels

	"The rungs that are preconditions for reading anything at all, as against the ones where
	damage is local and belongs in the data instead.

	Without bytes, a heap, or a navigable class table there is nothing to be done: no object
	anywhere can be read, or placed, or named. Everything else is damage to *part* of the
	memory -- a walk that stops somewhere, a free chunk that is not one, a class index that
	answers nothing -- and the rest of the heap is unaffected. Those are reported and carried
	in the objects themselves, not turned into a refusal to read the image."

	^ #( #bytes #heap #classes )
