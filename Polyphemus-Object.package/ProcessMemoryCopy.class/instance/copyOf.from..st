initialization
copyOf: aSegment from: aReader

	"Its bytes, 64 KB at a time (a young ByteArray each, no collection), up to where the reader
	stopped handing them over."

	| buffer copied limit |
	buffer := ByteArray new: aSegment sizeInMemory.
	copied := aSegment address.
	limit := aSegment address + aSegment sizeInMemory.
	[ copied < limit ] whileTrue: [
		| chunk piece |
		chunk := 65536 min: limit - copied.
		piece := aReader bytesAt: copied count: chunk.
		piece ifNil: [
			copied = aSegment address ifTrue: [ ^ nil ].
			^ ByteArrayAddressSpace on: (buffer copyFrom: 1 to: copied - aSegment address) at: aSegment address ].
		buffer replaceFrom: copied - aSegment address + 1 to: copied - aSegment address + chunk with: piece startingAt: 1.
		copied := copied + chunk ].
	^ ByteArrayAddressSpace on: buffer at: aSegment address
