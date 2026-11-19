reading
sectionsDo: aBlock

	"Evaluate aBlock with the type, file offset, size and link of each section header."

	| tableStart entrySize count |
	tableStart := (LittleEndian unsignedIn: self bytes from: 16r28 + 1 size: 8).
	entrySize := (LittleEndian unsignedIn: self bytes from: 16r3A + 1 size: 2).
	count := (LittleEndian unsignedIn: self bytes from: 16r3C + 1 size: 2).
	0 to: count - 1 do: [ :index |
		| at |
		at := tableStart + (index * entrySize) + 1.
		aBlock
			value: ((LittleEndian unsignedIn: self bytes from: at + 4 size: 4))
			value: ((LittleEndian unsignedIn: self bytes from: at + 24 size: 8))
			value: ((LittleEndian unsignedIn: self bytes from: at + 32 size: 8))
			value: ((LittleEndian unsignedIn: self bytes from: at + 40 size: 4)) ]
