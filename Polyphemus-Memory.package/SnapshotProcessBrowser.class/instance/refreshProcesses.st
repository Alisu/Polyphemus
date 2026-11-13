updating
refreshProcesses

	"Deepest first, each stack read once: frames are read off the VM's pages (#183)."

	| depths depthOf |
	depths := Dictionary new.
	depthOf := [ :process |
	           depths at: process address ifAbsentPut: [ (reifiedMemory activationsOfProcess: process) size ] ].
	processList items: (reifiedMemory allReifiedProcesses
			 asSortedCollection: [ :a :b | (depthOf value: a) >= (depthOf value: b) ]) asArray