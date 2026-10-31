helpers
spanOfOldSpaceIn: aPid

	"From old space's start to the end of the last segment its bridges lead to: addresses, nothing copied."

	| reader |
	reader := PolyphemusMadeFor current processMemoryClass on: aPid.
	^ [ reader whileStopped: [ | raw | raw := SpurRawHeap on: reader. raw mappingLimit - raw mappingStart ] ]
		  ensure: [ reader close ]
