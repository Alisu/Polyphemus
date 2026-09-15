context protocol
outerContext

	"The activation a block was written in. Frames do not answer it yet: a block frame
	reaches its home through the closure it is running, and reading that is not done. nil
	stops the walks that look for it rather than sending them somewhere wrong."

	^ nil
