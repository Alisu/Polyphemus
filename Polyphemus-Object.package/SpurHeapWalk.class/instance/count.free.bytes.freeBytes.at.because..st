initialization
count: aCount free: aFreeCount bytes: liveTotal freeBytes: freeTotal at: anAddress because: aReason

	objectCount := aCount.
	freeChunkCount := aFreeCount.
	liveBytes := liveTotal.
	freeBytes := freeTotal.
	stoppedAt := anAddress.
	reason := aReason
