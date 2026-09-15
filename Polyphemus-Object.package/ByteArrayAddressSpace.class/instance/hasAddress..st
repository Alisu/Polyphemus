testing
hasAddress: anAddress

	^ anAddress >= baseAddress and: [ anAddress < (baseAddress + bytes size) ]
