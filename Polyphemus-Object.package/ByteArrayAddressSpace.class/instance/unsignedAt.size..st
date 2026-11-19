reading
unsignedAt: anAddress size: aCount

	"A little endian unsigned integer, or nil when those bytes are not all here. Read straight
	from the bytes: a walk asks this millions of times (#152)."

	| start |
	start := anAddress - baseAddress.
	(start >= 0 and: [ start + aCount <= bytes size ]) ifFalse: [ ^ nil ].
	^ LittleEndian unsignedIn: bytes from: start + 1 size: aCount
