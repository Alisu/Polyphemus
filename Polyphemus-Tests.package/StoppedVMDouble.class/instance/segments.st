reading the map
segments

	"The heap, the larger, then the VM's data past a gap, so that the heap does not run on into it."

	^ {
		  (ElfCoreSegment ofProcessAt: space baseAddress size: space size // 2).
		  (ElfCoreSegment ofProcessAt: self dataAddress size: space size // 4) }
