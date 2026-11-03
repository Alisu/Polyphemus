reading
unsignedAt: anAddress size: aCount

	"A little endian unsigned integer, or nil when those bytes are not all here. Read straight
	from the bytes: a walk asks this millions of times (#152)."

	| start value |
	start := anAddress - baseAddress.
	(start >= 0 and: [ start + aCount <= bytes size ]) ifFalse: [ ^ nil ].
	value := 0.
	start + aCount to: start + 1 by: -1 do: [ :index |
		value := (value bitShift: 8) + (bytes at: index) ].
	^ value
