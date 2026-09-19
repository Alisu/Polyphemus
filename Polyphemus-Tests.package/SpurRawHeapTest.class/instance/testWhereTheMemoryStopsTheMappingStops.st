tests
testWhereTheMemoryStopsTheMappingStops

	"#15: a region listed but gone by the time it is read. What was read is kept, the
	mapping ends there, and nothing is made up for the rest."

	| space raw |
	space := VanishedRegionSpace on: (ByteArray new: 8192 withAll: 7) at: 16r100000.
	raw := SpurRawHeap on: space from: 16r100000 to: 16r100000 + 8192 + 4096.

	self assert: raw bytes size equals: 8192.
	self assert: raw mappingLimit equals: 16r100000 + 8192.
	self assert: (raw bytes allSatisfy: [ :each | each = 7 ])
