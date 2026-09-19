*Polyphemus-Memory
interpreterAllocationReserveBytes
	"VMMaker's margin for allocating contexts on a stack page switch: a large context times the
	maximum frames per page times the number of pages."
	<inline: #never>
	| maxUsedBytesPerPage maxFramesPerPage |
	maxUsedBytesPerPage := self stackPageFrameBytes + self stackLimitOffset.
	maxFramesPerPage := maxUsedBytesPerPage / objectMemory wordSize // FrameSlots.
	^maxFramesPerPage * LargeContextSlots * objectMemory bytesPerOop * 5 "numStackPages"