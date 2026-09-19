reifying
reifiedMemory

	"A LazyReifiedMemory, because the full one rewrites the free lists. Refused when the
	class table cannot be navigated."

	self readability require: #classes.
	^ LazyReifiedMemory on: self memory
