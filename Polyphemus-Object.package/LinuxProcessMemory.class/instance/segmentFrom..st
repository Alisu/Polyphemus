reading the map
segmentFrom: aLine

	"One line of the map, or nil if it is not one we can read. The shape is

		7f3c1a400000-7f3c1a600000 rw-p 00000000 00:00 0    [heap]

	and the offsets of `/proc/<pid>/mem` are addresses, so a region's offset in the file we
	read from is its own address."

	| parts range from to |
	parts := aLine substrings: ' '.
	parts size < 2 ifTrue: [ ^ nil ].
	(parts at: 2) first = $r ifFalse: [ ^ nil ].
	(#( '[vvar]' '[vsyscall]' ) includes: parts last) ifTrue: [ ^ nil ].
	range := (parts at: 1) substrings: '-'.
	range size = 2 ifFalse: [ ^ nil ].
	from := Number readFrom: (range at: 1) base: 16.
	to := Number readFrom: (range at: 2) base: 16.
	^ ElfCoreSegment new
		  kind: 1
		  address: from
		  offset: from
		  inFile: to - from
		  inMemory: to - from;
		  yourself
