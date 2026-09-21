interning
scanTheSymbolTableFor: aString

	"Where Symbol class>>lookup: stops for that name: its symbol -> the slot when the image
	holds it, nil -> a free slot when it does not. A string hashes by its characters, so the
	name hashes the same here as there."

	| array flag size index start |
	array := self symbolTable reifiedSlotAt: 2.
	flag := self symbolTable reifiedSlotAt: 3.
	size := array oopNumberOfSlots.
	index := start := aString hash \\ size + 1.
	[
	| element |
	element := array reifiedSlotAt: index.
	element address = flag address ifTrue: [ ^ nil -> index ].
	([ element asString ] on: Error do: [ :e | '' ]) = aString ifTrue: [ ^ element -> index ].
	(index := index \\ size + 1) = start ] whileFalse.
	^ self error: 'this image''s symbol table has no room left'
