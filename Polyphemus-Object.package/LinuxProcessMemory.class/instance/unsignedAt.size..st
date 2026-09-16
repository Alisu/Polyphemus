reading
unsignedAt: anAddress size: aCount

	"Little endian, like the machines this runs on."

	| read value |
	read := self bytesAt: anAddress count: aCount.
	read ifNil: [ ^ nil ].
	read size = aCount ifFalse: [ ^ nil ].
	value := 0.
	aCount to: 1 by: -1 do: [ :index |
		value := (value bitShift: 8) + (read at: index) ].
	^ value
