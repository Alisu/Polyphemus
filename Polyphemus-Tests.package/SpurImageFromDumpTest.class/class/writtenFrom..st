accessing
writtenFrom: aDumpedMemory

	"The dump written out as an image file, once for the class, and kept across runs while its
	key holds (cacheKey): the write is VMMaker's simulated snapshot collection, the longest
	thing a run does. What the dump held is counted first: writing changes the shared memory."

	^ Written ifNil: [
		  | cache |
		  cache := self cacheDirectory / self cacheKey.
		  (cache / 'written.image') exists ifFalse: [
			  self forgetOtherCachesThan: cache.
			  cache ensureCreateDirectory.
			  (cache / 'stacks.ston') writeStreamDo: [ :stream |
				  STON put: (self stacksOf: StackOfADumpTest memory) asArray onStream: stream ].
			  (SpurImageFromDump on: aDumpedMemory) writeTo: cache / 'written.image' ].
		  Stacks := (STON fromString: (cache / 'stacks.ston') contents) asBag.
		  Written := cache / 'written.image' ]
