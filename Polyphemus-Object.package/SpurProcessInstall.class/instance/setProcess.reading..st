initialization
setProcess: aProcessMemory reading: aReifiedMemory

	process := aProcessMemory.
	variables := VMVariables on: aProcessMemory.
	self setReading: aReifiedMemory
