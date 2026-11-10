instance creation
on: aReifiedMemory into: aWritableMemory

	"The memory must be able to make objects, and hold them where the reading shows them:
	what is found through the reading is written by its address."

	aWritableMemory canMakeObjects ifFalse: [
		^ CannotWriteThere signal: 'that memory cannot make objects, so nothing can be installed in it' ].
	(aWritableMemory shiftFrom: aReifiedMemory) = 0 ifFalse: [
		^ CannotWriteThere signal: 'that memory does not hold the image where the reading shows it' ].
	^ self new setReading: aReifiedMemory memory: aWritableMemory
