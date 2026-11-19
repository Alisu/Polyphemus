header
oldBaseAddress

	^ LittleEndian unsignedIn: header from: 17 size: 8
