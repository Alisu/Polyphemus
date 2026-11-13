updating
showStackOf: aProcess

	aProcess
		ifNil: [ frameList items: #(  ) ]
		ifNotNil: [ frameList items: (reifiedMemory activationsOfProcess: aProcess) asArray ]
