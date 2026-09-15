reading
unsignedAt: anAddress size: aCount

	"A little endian unsigned integer, or nil when those bytes are not here."

	| read value |
	read := self bytesAt: anAddress count: aCount.
	read ifNil: [ ^ nil ].
	value := 0.
	aCount to: 1 by: -1 do: [ :index |
		value := (value bitShift: 8) + (read at: index) ].
	^ value
