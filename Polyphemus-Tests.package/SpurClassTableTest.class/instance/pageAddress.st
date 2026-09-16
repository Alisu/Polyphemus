building a heap
pageAddress

	"Where the single class table page lands, given what comes before it.

	nil, false and true are sixteen bytes each; the free lists are 64 slots, so 520; the
	hidden roots ask for 4096 slots, which is over the 255 a header can hold, so they are
	preceded by an overflow word -- eight bytes, then 8 + 32768. The page is over 255 slots
	too, so it has one as well."

	^ self baseAddress + 48 + 520 + 8 + 8 + 32768 + 8
