allocating
remember: anOldOop

	"Tell the collector that an old object points into the young: its remembered bit, and its
	place in the remembered set. Without this a scavenge would take what we made for garbage."

	| header size |
	header := process unsignedAt: anOldOop size: 8.
	((header bitShift: -29) bitAnd: 1) = 1 ifTrue: [ ^ false ].
	size := variables at: 'rememberedSetSize'.
	size + 1 >= (variables at: 'rememberedSetLimit') ifTrue: [
		^ self error: 'that image''s remembered set is full' ].
	process storeWord: (header bitOr: (1 bitShift: 29)) at: anOldOop.
	process
		storeWord: anOldOop
		at: (variables at: 'rememberedSet') + (size * 8).
	process storeWord: size + 1 at: (variables addressOf: 'rememberedSetSize').
	^ true
