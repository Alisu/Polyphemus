initialization
close

	"Let go of the file and the block held from it. Reading afterwards opens it again, so this
	is safe to call and safe to forget -- but a dump is a large file and a block of it is
	64 kilobytes of this image's memory."

	cacheBytes := nil.
	cacheStart := nil.
	stream ifNotNil: [
		[ stream close ] on: Error do: [ :e | ].
		stream := nil ]
