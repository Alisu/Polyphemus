writing
bytesOf: anInteger size: aCount

	"aCount bytes, lowest first: a negative integer as its two's complement, what does not fit cut off."

	| bytes |
	bytes := ByteArray new: aCount.
	1 to: aCount do: [ :index | bytes at: index put: ((anInteger bitShift: index - 1 * -8) bitAnd: 255) ].
	^ bytes
