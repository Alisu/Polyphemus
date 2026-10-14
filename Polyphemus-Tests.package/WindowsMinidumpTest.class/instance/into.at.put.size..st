building the dump
into: aByteArray at: anIndex put: aValue size: aCount

	"A little endian unsigned integer, one-based index."

	0 to: aCount - 1 do: [ :offset |
		aByteArray
			at: anIndex + offset
			put: (aValue bitShift: offset * -8) \\ 256 ]
