writing
describeOldSpaceAsOneSegment

	"An image holds its heap as segments, each ending in a bridge, and a dump-built memory
	has none. One segment from the start of old space to past its last object, where the
	bridge goes: VMMaker plants it in the segment's last bytes."

	| memory manager end |
	memory := dumped memory.
	manager := memory segmentManager.
	"Past the last object, which is where the memory allocates next: contexts made for frames
	are there too."
	end := memory freeOldSpaceStart + memory bridgeSize.
	memory endOfMemory: end.
	manager clearSegments; allocateOrExtendSegmentInfos.
	manager withNewSegmentDo: [ :segment |
		segment
			segStart: memory oldSpaceStart;
			segSize: end - memory oldSpaceStart;
			swizzle: 0 ].
	manager plantBridgeAtTheEndOfMemory
