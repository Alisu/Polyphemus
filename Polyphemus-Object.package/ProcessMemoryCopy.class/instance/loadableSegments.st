reading
loadableSegments

	"What it holds, region by region, as a core's segments are."

	^ pieces collect: [ :each |
		  ElfCoreSegment ofProcessAt: each baseAddress size: each size ]
