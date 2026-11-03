watching
noteWriteInto: aProcessMemory

	current ifNotNil: [ :watch | watch noteWriteInto: aProcessMemory ]
