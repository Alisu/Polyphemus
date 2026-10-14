reading
unsignedIn: someBytes at: anOffset size: aCount

	"Little endian, anOffset from 0, as PE offsets are."

	| value |
	value := 0.
	aCount to: 1 by: -1 do: [ :i | value := (value bitShift: 8) + (someBytes at: anOffset + i) ].
	^ value
