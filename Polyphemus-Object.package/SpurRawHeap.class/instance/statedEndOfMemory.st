finding a heap
statedEndOfMemory

	"Where the VM says its objects end, when this memory is one of a VM -- a dump, a process --
	and it says so within the mapping. Summing the live objects' sizes fell short by every
	free chunk before the last of them (#46)."

	| stated |
	stated := [ self vmVariables at: 'endOfMemory' ] on: Error do: [ :error | ^ nil ].
	^ (stated isInteger and: [ stated between: heapStart and: mappingLimit ])
		  ifTrue: [ stated ]
		  ifFalse: [ nil ]
