running
note: someHeaps of: aTest

	"What the readability ladder refuses in each heap aTest read, unless it damages heaps on purpose
	(<damagesTheHeap>). Noted for now, not failed (#141)."

	| notes |
	((aTest class lookupSelector: aTest selector) hasPragmaNamed: #damagesTheHeap) ifTrue: [ ^ self ].
	notes := someHeaps flatCollect: [ :each |
		         [ each readability refusals associations collect: [ :refusal | refusal key printString , ': ' , refusal value asString ] ]
			         on: Error
			         do: [ :e | { 'the check failed: ' , e messageText asString } ] ].
	notes
		ifEmpty: [ heapNotes removeKey: aTest selector ifAbsent: [ nil ] ]
		ifNotEmpty: [ heapNotes at: aTest selector put: notes ]
