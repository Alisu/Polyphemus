examples
handleFailingBasicNew: sizeRequested

	"As if the heap could not grow for it."

	^ OutOfMemory signal
