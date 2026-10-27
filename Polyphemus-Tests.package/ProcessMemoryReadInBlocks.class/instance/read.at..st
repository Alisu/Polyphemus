reading
read: aCount at: anAddress

	asked := asked + 1.
	^ space bytesAt: anAddress count: aCount
