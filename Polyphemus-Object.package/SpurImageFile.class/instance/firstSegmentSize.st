header
firstSegmentSize

	^ LittleEndian unsignedIn: header from: 73 size: 8
