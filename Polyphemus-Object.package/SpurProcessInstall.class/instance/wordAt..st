memory
wordAt: anAddress

	^ process unsignedAt: anAddress size: 8
