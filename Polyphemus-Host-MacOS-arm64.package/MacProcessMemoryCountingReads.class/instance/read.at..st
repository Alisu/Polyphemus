reading
read: aCount at: anAddress

	blockReads := self blockReads + 1.
	^ super read: aCount at: anAddress
