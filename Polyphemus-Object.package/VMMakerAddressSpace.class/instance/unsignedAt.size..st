reading
unsignedAt: anAddress size: aCount

	"A little endian unsigned integer, or nil when those bytes are not here."

	(self hasAddress: anAddress) ifFalse: [ ^ nil ].
	^ [ manager readUnsignedIntegerAt: anAddress size: aCount ] on: Error do: [ :e | nil ]
