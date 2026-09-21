memory
remember: anOop

	"Tell the collector that this old object may now point at a young one: its remembered bit,
	and its place in the remembered set, as SpurGenerationScavenger>>remember: does it.
	Without this a scavenge would take what was made for garbage."

	| header size |
	header := self wordAt: anOop.
	((header bitShift: -29) bitAnd: 1) = 1 ifTrue: [ ^ false ].
	size := variables at: 'rememberedSetSize'.
	size + 1 >= (variables at: 'rememberedSetLimit') ifTrue: [
		^ self error: 'that image''s remembered set is full' ].
	self wordAt: anOop put: (header bitOr: (1 bitShift: 29)).
	self wordAt: (variables at: 'rememberedSet') + (size * 8) put: anOop.
	self wordAt: (variables addressOf: 'rememberedSetSize') put: size + 1.
	^ true
