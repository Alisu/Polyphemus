reading
unsignedAt: anAddress size: aSize

	"Little-endian, nil where no region is."

	^ (regions detect: [ :each | each hasAddress: anAddress ] ifNone: [ ^ nil ]) unsignedAt: anAddress size: aSize
