instance creation
on: aProcessMemory reading: aReifiedMemory

	"An installer for that running image: the reader writes to it, the reading says what is
	in it."

	^ self new
		  setProcess: aProcessMemory reading: aReifiedMemory;
		  yourself
