instance creation
ofProcessAt: anAddress size: aSize

	"A region of a running process, read where it is: its offset is its address, all of it there."

	^ self new
		  kind: 1
		  address: anAddress
		  offset: anAddress
		  inFile: aSize
		  inMemory: aSize;
		  yourself
