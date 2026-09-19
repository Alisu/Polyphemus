accessing
stackPages

	"The VM's page records, from pages on, numStackPages of them, read through VMMaker's
	CogStackPageSurrogate64."

	| pages first size |
	pages := OOPCogStackPages on: memory.
	first := self at: 'pages'.
	size := CogStackPageSurrogate64 alignedByteSize.
	^ (0 to: (self at: 'numStackPages') - 1) collect: [ :index |
		  pages pageAt: first + (index * size) ]
