interning
scan: aWeakSet for: aString

	"Where the image's lookup stops for that name in one of its symbol sets: its symbol -> the
	slot when it holds it, nil -> a free slot when not. A string hashes by its characters alike."

	| array flag size index start |
	array := aWeakSet reifiedSlotAt: 2.
	flag := aWeakSet reifiedSlotAt: 3.
	size := array oopNumberOfSlots.
	index := start := aString hash \\ size + 1.
	[
	| element |
	element := array reifiedSlotAt: index.
	element address = flag address ifTrue: [ ^ nil -> index ].
	([ element asString ] on: Error do: [ :e | '' ]) = aString ifTrue: [ ^ element -> index ].
	(index := index \\ size + 1) = start ] whileFalse.
	^ self error: 'this image''s symbol set has no room left'
