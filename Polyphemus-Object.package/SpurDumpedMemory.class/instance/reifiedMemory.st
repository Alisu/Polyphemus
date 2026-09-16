reifying
reifiedMemory

	"Reified lazily, and so without writing.

	`FullyReifiedMemory` rebuilds the free lists of the memory it reads, which is fair for
	an image being repaired and wrong for evidence: it would change the dump as we look at
	it. The lazy view answers direct questions immediately; `#reifyEverything:` is what the
	enumerating ones need.

	Refused outright when the class table cannot be read, because every object reified
	through a broken table gets a name, and the name is wrong."

	self readability require: #classes.
	^ LazyReifiedMemory on: self memory
