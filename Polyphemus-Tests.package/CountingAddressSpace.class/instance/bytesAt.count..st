reading
bytesAt: anAddress count: aCount

	reads := reads + 1.
	^ space bytesAt: anAddress count: aCount
