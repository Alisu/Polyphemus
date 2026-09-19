reading
unsignedFrom: aByteArray at: anIndex size: aCount

	"A little endian unsigned integer, one-based index."

	| value |
	value := 0.
	aCount to: 1 by: -1 do: [ :offset |
		value := (value bitShift: 8) + (aByteArray at: anIndex + offset - 1) ].
	^ value
