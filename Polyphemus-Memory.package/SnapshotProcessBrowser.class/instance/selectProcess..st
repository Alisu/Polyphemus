selecting
selectProcess: aProcessOrNil

	aProcessOrNil
		ifNil: [ processList unselectAll ]
		ifNotNil: [ processList selectItem: aProcessOrNil ]
