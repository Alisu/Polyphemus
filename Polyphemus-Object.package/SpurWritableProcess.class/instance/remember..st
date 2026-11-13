objects
remember: anOop

	"Tell the collector this old object may now point at a younger one. A young one is never told:
	the remembered set holds old ones only, and the next scavenge would leave its entry dangling.
	Refused where the VM may be telling it of one itself, whoever stopped it (#167)."

	| header size |
	(self isYoung: anOop) ifTrue: [ ^ false ].
	header := self wordAt: anOop.
	((header bitShift: -29) bitAnd: 1) = 1 ifTrue: [ ^ false ].
	(process class whyNotToAllocateIn: self variables) ifNotNil: [ :why |
		^ CannotWriteThere signal: 'that image is not told of an old object now: its VM was stopped ' , why ].
	size := self variables at: 'rememberedSetSize'.
	size + 1 >= (self variables at: 'rememberedSetLimit') ifTrue: [ ^ CannotWriteThere signal: 'that image''s remembered set is full' ].
	self wordAt: anOop put: (header bitOr: (1 bitShift: 29)).
	self wordAt: (self variables at: 'rememberedSet') + (size * 8) put: anOop.
	self wordAt: (self variables addressOf: 'rememberedSetSize') put: size + 1.
	^ true
