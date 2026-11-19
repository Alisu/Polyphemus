reading
fileMappingsIn: aDescription

	"An NT_FILE note: a count and a page size, then start, end and page offset for each
	mapping, then their paths, each ending in a null byte."

	| count pageSize paths |
	count := (LittleEndian unsignedIn: aDescription from: 1 size: 8).
	pageSize := (LittleEndian unsignedIn: aDescription from: 9 size: 8).
	paths := ((aDescription copyFrom: 17 + (count * 24) to: aDescription size) asString
		          substrings: (String with: Character null)).
	^ (1 to: (count min: paths size)) collect: [ :index |
		  | at |
		  at := 17 + ((index - 1) * 24).
		  ElfMappedFile
			  start: ((LittleEndian unsignedIn: aDescription from: at size: 8))
			  stop: ((LittleEndian unsignedIn: aDescription from: at + 8 size: 8))
			  fileOffset: ((LittleEndian unsignedIn: aDescription from: at + 16 size: 8)) * pageSize
			  path: (paths at: index) ]
