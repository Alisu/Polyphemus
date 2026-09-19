building a heap
pageAddress

	"Where the single class table page lands: nil, false, true (16 bytes each), free lists (520),
	hidden roots (overflow word + 8 + 32768), then the page's own overflow word."

	^ self baseAddress + 48 + 520 + 8 + 8 + 32768 + 8
