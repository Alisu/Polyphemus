reifying
reifiedMemory

	"Reified lazily, and so without writing.

	`FullyReifiedMemory` rebuilds the free lists of the memory it reads, which is fair for
	an image being repaired and wrong for evidence: it would change the dump as we look at
	it. The lazy view answers direct questions immediately; `#reifyEverything:` is what
	the enumerating ones need."

	^ LazyReifiedMemory on: self memory
