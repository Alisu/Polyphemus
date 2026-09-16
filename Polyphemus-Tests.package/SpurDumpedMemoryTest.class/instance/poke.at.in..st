running
poke: aValue at: anAddress in: someBytes

	"Write one word into a copy of the dump, little endian. Damaging the bytes rather than
	going through our own API is the only way to prove we can read damage we did not cause."

	0 to: 7 do: [ :offset |
		someBytes
			at: anAddress - dumped mappingStart + offset + 1
			put: (aValue bitShift: offset * -8) \\ 256 ]
