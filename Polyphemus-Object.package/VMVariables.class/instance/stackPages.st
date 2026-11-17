accessing
stackPages

	"The VM's page records, from pages on, numStackPages of them, read through VMMaker's own
	view of one (OOPCogStackPages surrogateClass). A count no VM has is damage, refused (#211)."

	| pages first size count |
	count := self at: 'numStackPages'.
	(count between: 0 and: 65536) ifFalse: [ ^ self refuse: #itSaysMoreStackPagesThanAVMHas ].
	pages := OOPCogStackPages on: memory.
	first := self at: 'pages'.
	size := OOPCogStackPages surrogateClass alignedByteSize.
	^ (0 to: count - 1) collect: [ :index | pages pageAt: first + (index * size) ]
