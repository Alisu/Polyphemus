updating
showStackOf: aProcess

	aProcess
		ifNil: [ frameList items: #(  ) ]
		ifNotNil: [ frameList items: (reifiedMemory contextsOfProcess: aProcess) asArray ]
