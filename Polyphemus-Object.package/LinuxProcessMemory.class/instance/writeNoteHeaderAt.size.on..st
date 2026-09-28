dumping
writeNoteHeaderAt: anOffset size: aSize on: aStream

	"The program header of the notes: not loaded, only read by whoever reads the core."

	self write: 4 bytes: 4 on: aStream "PT_NOTE".
	self write: 4 bytes: 4 on: aStream "readable".
	self write: anOffset bytes: 8 on: aStream.
	self write: 0 bytes: 8 on: aStream "no address".
	self write: 0 bytes: 8 on: aStream "no physical address".
	self write: aSize bytes: 8 on: aStream.
	self write: 0 bytes: 8 on: aStream "nothing in memory".
	self write: 4 bytes: 8 on: aStream "aligned to four"
