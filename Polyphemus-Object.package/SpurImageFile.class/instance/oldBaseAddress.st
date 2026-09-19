header
oldBaseAddress

	^ self unsignedFrom: header at: 17 size: 8
