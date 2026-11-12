tests
testAReadingOfAHeapBridgedFarAwayLeavesOutWhatIsMappedInItsGap
	<readsAnUnsoundHeap>

	"#185: what the process mapped between old space's first mapping and a far segment is not
	its heap. Copied, and touching the segment, it made one piece with it, which the bridge
	no longer led to: the reading held memory the VM does not read and lost the segment."

	| copy |
	copy := ProcessMemoryCopy ofWhatAReadingReads: self aProcessWithAHeapBridgedFarAway.
	self assert: (copy hasAddress: 16r10000000).
	self assert: (copy hasAddress: 16r7FB741EF6000).
	self deny: (copy hasAddress: 16r7FB741EF5000).
	self assert: (SpurRawHeap on: copy) mappingLimit equals: 16r7FB741EF6000 + 16r1000
