tests
testACopyWhoseClassTableSaysOtherwiseDoesNotHoldTheSameClasses

	"#163, item 11: a reading after a step takes the classes of the one before over when the copy
	holds them where they were. An entry of the table changed (a class redefined, or moved by a
	collection) says no; an entry taken that was empty, or one of a class still in new space, says yes."

	<readsAnUnsoundHeap>
	| soa index page entry free copy changed same gained young youngMoved memoryOn |
	soa := dumped raw specialObjectsOop.
	index := dumped memory classIndexOf: soa.
	page := dumped raw scanner slotOf: (dumped raw scanner hiddenRootsFrom: dumped raw heapStart) at: index // 1024 + 1.
	entry := page + 8 + (index \\ 1024 * 8).
	free := ((0 to: 1023) collect: [ :each | page + 8 + (each * 8) ]) detect: [ :each |
		        (dumped raw space unsignedAt: each size: 8) = dumped raw heapStart ].
	memoryOn := [ :bytes |
	            SpurDumpedMemory
		            on: (ByteArrayAddressSpace on: bytes at: dumped raw mappingStart)
		            from: dumped raw mappingStart
		            to: dumped raw mappingLimit ].
	same := memoryOn value: dumped raw bytes copy.
	copy := dumped raw bytes copy.
	self poke: soa at: entry in: copy.
	changed := memoryOn value: copy.
	copy := dumped raw bytes copy.
	self poke: soa at: free in: copy.
	gained := memoryOn value: copy.

	"A class in new space, as one just defined is: its entry moves with it at a scavenge (seen on
	a held image: two entries of the last page, the class a test defined and its metaclass)."
	copy := dumped raw bytes copy.
	self poke: dumped raw heapStart - 16r1000 at: free in: copy.
	young := memoryOn value: copy.
	copy := dumped raw bytes copy.
	self poke: dumped raw heapStart - 16r2000 at: free in: copy.
	youngMoved := memoryOn value: copy.

	self assert: (same holdsTheClassesOf: dumped).
	self deny: (changed holdsTheClassesOf: dumped).
	self assert: (gained holdsTheClassesOf: dumped).
	self assert: (youngMoved holdsTheClassesOf: young)
