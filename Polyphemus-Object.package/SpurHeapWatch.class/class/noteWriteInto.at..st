watching
noteWriteInto: aProcessMemory at: anAddress

	current ifNotNil: [ :watch | watch noteWriteInto: aProcessMemory at: anAddress ]
