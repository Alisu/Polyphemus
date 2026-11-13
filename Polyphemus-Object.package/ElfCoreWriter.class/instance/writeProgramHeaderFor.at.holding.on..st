dumping
writeProgramHeaderFor: aSegment at: anOffset holding: aCount on: aStream

	"Fifty-six bytes saying where a region was in memory and where its bytes are in this file:
	aCount of them, fewer than in memory when a block did not read, the rest absent (#182)."

	self write: 1 bytes: 4 on: aStream "PT_LOAD".
	self write: 4 bytes: 4 on: aStream "readable".
	self write: anOffset bytes: 8 on: aStream.
	self write: aSegment address bytes: 8 on: aStream.
	self write: 0 bytes: 8 on: aStream "no physical address".
	self write: aCount bytes: 8 on: aStream.
	self write: aSegment sizeInMemory bytes: 8 on: aStream.
	self write: 1 bytes: 8 on: aStream "no alignment required"