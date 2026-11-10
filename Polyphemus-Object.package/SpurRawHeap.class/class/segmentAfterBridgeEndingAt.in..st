instance creation
segmentAfterBridgeEndingAt: aLimit in: aDump

	"Where the next segment starts when the memory before aLimit ends in a long segment bridge
	(class index 3, word indexable, its slot count in the word before), else nil."

	| header overflow |
	header := aDump unsignedAt: aLimit - 8 size: 8.
	overflow := aDump unsignedAt: aLimit - 16 size: 8.
	(header isNil or: [ overflow isNil ]) ifTrue: [ ^ nil ].
	((SpurHeader isSegmentBridge: header) and: [ SpurHeader overflowsItsSlotCount: header ]) ifFalse: [ ^ nil ].
	^ aLimit + ((SpurHeader countInOverflowWord: overflow) * 8)
