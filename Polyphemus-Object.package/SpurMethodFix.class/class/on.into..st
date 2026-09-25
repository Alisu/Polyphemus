instance creation
on: aReifiedMemory into: aWritableMemory

	"A fix for methods of that reading, written into that memory: in place when the code fits,
	and as a new method when it does not and the memory can make one."

	^ self new setReading: aReifiedMemory into: aWritableMemory
