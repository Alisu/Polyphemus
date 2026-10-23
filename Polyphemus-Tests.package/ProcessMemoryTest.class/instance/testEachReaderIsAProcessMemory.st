tests
testEachReaderIsAProcessMemory

	"How a process is held still and read back was written three times, and fixed in one reader
	but not the others (#102); it is written once, in their superclass (#118)."

	self readers do: [ :each |
		self assert: each superclass == (Smalltalk at: #ProcessMemory ifAbsent: [ nil ]) description: each name ]
