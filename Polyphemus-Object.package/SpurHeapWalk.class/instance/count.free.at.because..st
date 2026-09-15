initialization
count: aCount free: aFreeCount at: anAddress because: aReason

	objectCount := aCount.
	freeChunkCount := aFreeCount.
	stoppedAt := anAddress.
	reason := aReason
