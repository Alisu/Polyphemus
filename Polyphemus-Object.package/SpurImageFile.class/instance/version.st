header
version

	^ LittleEndian unsignedIn: header from: 1 size: 4
