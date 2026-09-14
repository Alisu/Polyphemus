building the fixture
read: byteCount from: aStream at: anOffset

	"A little endian unsigned integer of byteCount bytes."

	| bytes value |
	aStream position: anOffset.
	bytes := aStream next: byteCount.
	value := 0.
	byteCount to: 1 by: -1 do: [ :index |
		value := (value bitShift: 8) + (bytes at: index) ].
	^ value
