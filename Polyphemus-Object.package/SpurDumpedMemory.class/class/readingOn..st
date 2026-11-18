instance creation
readingOn: anAddressSpace

	"The reading of a dump or of a copy of a process: its objects reified as they are looked at
	(#129), and listed by class through the dumped memory's walk."

	^ (self on: anAddressSpace) reifiedMemory