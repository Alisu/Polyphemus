writing
describeOldSpaceUpTo: anAddress plantingBridge: plantBridge

	"An image holds its heap as segments, each ending in a bridge, and a dump-built memory
	has none -- which VMMaker's allocator needs as much as its writer. The bridge goes in
	only once nothing more will be allocated: it ends the segment."

	| memory manager |
	memory := dumped memory.
	manager := memory segmentManager.
	memory endOfMemory: anAddress.
	manager clearSegments; allocateOrExtendSegmentInfos.
	manager withNewSegmentDo: [ :segment |
		segment
			segStart: memory oldSpaceStart;
			segSize: anAddress - memory oldSpaceStart;
			swizzle: 0 ].
	plantBridge ifTrue: [ manager plantBridgeAtTheEndOfMemory ]
