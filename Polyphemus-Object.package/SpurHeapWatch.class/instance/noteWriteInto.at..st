checking
noteWriteInto: aProcessMemory at: anAddress

	(written at: aProcessMemory ifAbsentPut: [ OrderedCollection new ]) add: anAddress
