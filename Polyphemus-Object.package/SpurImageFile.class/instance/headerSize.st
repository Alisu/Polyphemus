header
headerSize

	^ LittleEndian unsignedIn: header from: 5 size: 4
