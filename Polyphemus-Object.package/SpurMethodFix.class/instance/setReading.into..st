initialization
setReading: aReifiedMemory into: aWritableMemory

	reading := aReifiedMemory.
	edit := SpurEdit on: aWritableMemory reading: aReifiedMemory.
	aWritableMemory canMakeObjects ifTrue: [
		installer := SpurMethodInstall on: aReifiedMemory into: aWritableMemory ]
