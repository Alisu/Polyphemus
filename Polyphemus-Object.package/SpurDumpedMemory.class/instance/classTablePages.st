reading
classTablePages

	"Where the class table's first pages are in the copy, which a compaction would move. Its
	root is among the first objects of the heap, which never move."

	| scanner root |
	scanner := raw scanner.
	root := scanner objectAfter: (scanner objectAfter: raw heapStart + 32).
	^ (1 to: 16) collect: [ :each | scanner slotOf: root at: each ]
