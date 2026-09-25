private
readAgain

	"A whole new copy and reading of the image. The last one is left as it was: the debugger
	still holds contexts of it, and they must go on reading the moment they were taken from."

	reader whileStopped: [
		dumped := SpurDumpedMemory on: reader.
		dumped raw bytes ].
	reading := dumped reifiedMemory
