accessing
stackPages

	"The VM's page records, from pages on, numStackPages of them, read through VMMaker's own
	view of one (OOPCogStackPages surrogateClass)."

	| pages first size |
	pages := OOPCogStackPages on: memory.
	first := self at: 'pages'.
	size := OOPCogStackPages surrogateClass alignedByteSize.
	^ (0 to: (self at: 'numStackPages') - 1) collect: [ :index |
		  pages pageAt: first + (index * size) ]
