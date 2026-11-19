reading
unsignedAt: anAddress size: aCount

	"A little endian unsigned integer, like the machines this runs on, or nil when its bytes are
	not all there."

	| read |
	read := self bytesAt: anAddress count: aCount.
	(read isNil or: [ read size ~= aCount ]) ifTrue: [ ^ nil ].
	^ LittleEndian unsignedIn: read from: 1 size: aCount
