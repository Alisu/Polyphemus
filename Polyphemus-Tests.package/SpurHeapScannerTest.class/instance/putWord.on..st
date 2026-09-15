building a heap
putWord: anInteger on: aStream

	"Eight bytes, little endian."

	0 to: 7 do: [ :offset |
		aStream nextPut: (anInteger bitShift: offset * -8) \\ 256 ]
