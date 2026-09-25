objects
remember: anOop

	"Its remembered bit, and its place in the remembered set, as
	SpurGenerationScavenger>>remember: does it. Without this a scavenge takes the young object."

	| header size |
	header := self wordAt: anOop.
	((header bitShift: -29) bitAnd: 1) = 1 ifTrue: [ ^ false ].
	size := self variables at: 'rememberedSetSize'.
	size + 1 >= (self variables at: 'rememberedSetLimit') ifTrue: [
		^ self error: 'that image''s remembered set is full' ].
	self wordAt: anOop put: (header bitOr: (1 bitShift: 29)).
	self wordAt: (self variables at: 'rememberedSet') + (size * 8) put: anOop.
	self wordAt: (self variables addressOf: 'rememberedSetSize') put: size + 1.
	^ true
