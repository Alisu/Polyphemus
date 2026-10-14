instance creation
segmentAfterBridgeEndingAt: aLimit in: aDump

	"Where the next segment starts when the memory before aLimit ends in a long segment bridge
	(class index 3, word indexable, its slot count in the word before), else nil."

	| header overflow |
	header := aDump unsignedAt: aLimit - 8 size: 8.
	overflow := aDump unsignedAt: aLimit - 16 size: 8.
	(header isNil or: [ overflow isNil ]) ifTrue: [ ^ nil ].
	((header bitAnd: 16r3FFFFF) = 3 and: [ ((header bitShift: -24) bitAnd: 16r1F) = 9 and: [ (header bitShift: -56) = 255 ] ]) ifFalse: [ ^ nil ].
	^ aLimit + ((overflow bitAnd: 16rFFFFFFFFFFFFFF) * 8)
