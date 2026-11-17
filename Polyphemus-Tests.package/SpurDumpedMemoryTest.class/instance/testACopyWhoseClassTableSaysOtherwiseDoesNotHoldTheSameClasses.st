tests
testACopyWhoseClassTableSaysOtherwiseDoesNotHoldTheSameClasses

	"#163, item 11: a reading after a step takes the classes of the one before over when the copy
	holds them where they were. The table's pages unmoved said yes, though an entry of one had
	changed (a class redefined, or moved by a collection): compared entry by entry now."

	<readsAnUnsoundHeap>
	| soa index page entry copy changed same |
	soa := dumped raw specialObjectsOop.
	index := dumped memory classIndexOf: soa.
	page := dumped raw scanner slotOf: (dumped raw scanner hiddenRootsFrom: dumped raw heapStart) at: index // 1024 + 1.
	entry := page + 8 + (index \\ 1024 * 8).
	copy := dumped raw bytes copy.
	same := SpurDumpedMemory
		        on: (ByteArrayAddressSpace on: copy copy at: dumped raw mappingStart)
		        from: dumped raw mappingStart
		        to: dumped raw mappingLimit.
	self poke: soa at: entry in: copy.
	changed := SpurDumpedMemory
		           on: (ByteArrayAddressSpace on: copy at: dumped raw mappingStart)
		           from: dumped raw mappingStart
		           to: dumped raw mappingLimit.

	self assert: (same holdsTheClassesOf: dumped).
	self deny: (changed holdsTheClassesOf: dumped)
