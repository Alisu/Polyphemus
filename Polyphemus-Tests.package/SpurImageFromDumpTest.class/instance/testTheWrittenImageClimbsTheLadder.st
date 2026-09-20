tests
testTheWrittenImageClimbsTheLadder

	"Read back with the readers a real image gets. Every rung but free space: the free lists
	still describe the dump's trailing free space, which the garbage collection pass will
	settle."

	| readability |
	readability := Polyphemus readabilityOfImageFile: self written.

	#( #bytes #heap #objects #classes #specialObjects ) do: [ :level |
		self assert: (readability canRead: level) description: level printString ].
	self assert: (readability whyNot: #freeSpace) equals: #chunkOutsideTheHeap
