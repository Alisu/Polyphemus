header
dataSize

	^ LittleEndian unsignedIn: header from: 9 size: 8
