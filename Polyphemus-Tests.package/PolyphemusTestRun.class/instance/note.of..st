running
note: aHeapWatch of: aTest

	"What the readability ladder refuses in each heap aTest read or wrote, unless it damages heaps on
	purpose (<damagesTheHeap>). Noted for now, not failed (#141)."

	| notes |
	((aTest class lookupSelector: aTest selector) hasPragmaNamed: #damagesTheHeap) ifTrue: [ ^ self ].
	notes := aHeapWatch problems , (aHeapWatch heaps flatCollect: [ :each | SpurHeapWatch problemsOf: each ]).
	notes
		ifEmpty: [ heapNotes removeKey: aTest selector ifAbsent: [ nil ] ]
		ifNotEmpty: [ heapNotes at: aTest selector put: notes ]
