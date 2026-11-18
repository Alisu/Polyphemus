tests
testAReaderOfBytesHoldsNoPolicyOfTheCollectorsAndBuildsNoReading

	"#118: a reader of bytes built a reading of what it read and held what the collector allows.
	Both are a safe moment's, which the reader hands its questions on to."

	self deny: (ProcessMemory class includesSelector: #whyCollectingIn:).
	self deny: (ProcessMemory class includesSelector: #whyNotToAllocateIn:).
	ProcessMemory methods , ProcessMemory class methods do: [ :each |
		self deny: (each referencedClasses includes: SpurDumpedMemory) description: each printString ]
