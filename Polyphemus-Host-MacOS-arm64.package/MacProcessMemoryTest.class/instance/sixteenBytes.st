helpers
sixteenBytes

	"Sixteen bytes 1 to 16, outside the object heap, at an address that stays put."

	| bytes |
	bytes := ExternalAddress allocate: 16.
	1 to: 16 do: [ :i | bytes byteAt: i put: i ].
	^ bytes
