reading
sectionsDo: aBlock

	"Evaluate aBlock with the type, file offset, size and link of each section header."

	| tableStart entrySize count |
	tableStart := (ElfNote unsignedFrom: self bytes at: 16r28 + 1 size: 8).
	entrySize := (ElfNote unsignedFrom: self bytes at: 16r3A + 1 size: 2).
	count := (ElfNote unsignedFrom: self bytes at: 16r3C + 1 size: 2).
	0 to: count - 1 do: [ :index |
		| at |
		at := tableStart + (index * entrySize) + 1.
		aBlock
			value: ((ElfNote unsignedFrom: self bytes at: at + 4 size: 4))
			value: ((ElfNote unsignedFrom: self bytes at: at + 24 size: 8))
			value: ((ElfNote unsignedFrom: self bytes at: at + 32 size: 8))
			value: ((ElfNote unsignedFrom: self bytes at: at + 40 size: 4)) ]
